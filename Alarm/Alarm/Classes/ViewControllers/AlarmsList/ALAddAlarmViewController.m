//
//  ALAddAlarmViewController.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALAddAlarmViewController.h"
#import "ALAddAlarmTableHeaderView.h"
#import "ALDateTimePicker.h"
#import "ALTextFieldTableViewCellCell.h"
#import "ALAlarmObject.h"

@interface ALAddAlarmViewController () <UITableViewDataSource, UITableViewDelegate, ALTextFieldTableViewCellCellDelegate, ALDateTimePickerDelegate>

typedef enum
{
    eAlarmTitleTableSection,
    eAlarmDateTableSection,
    eAddAlarmTableSectionsCount,
}ALAddAlarmTableSection;

#define kHeaderViewHeight 40.0
#define kDatePickerViewHeight 260.0

@property (strong, nonatomic) UITableView *addAlarmTableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSString *alarmTitleString;
@property (strong, nonatomic) NSString *alarmDateString;

@property (strong, nonatomic) ALDateTimePicker *alarmDatePicker;
@property (weak, nonatomic) UITextField *currentResponderField;
@property (weak, nonatomic) ALAlarmObject *editingAlarmObject;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;

- (void)initialSetup;

@end

@implementation ALAddAlarmViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialSetup];
    }
    return self;
}

- (id)initWithAlarmObject:(ALAlarmObject *)alarmObject
{
    self = [super init];
    if (self)
    {
        self.editingAlarmObject = alarmObject;
        [self initialSetup];
        
        self.alarmTitleString = _editingAlarmObject.alarmTitle;
        self.alarmDateString = _editingAlarmObject.alarmDateString;
    }
    return self;
}

- (void)initialSetup
{
    self.title = _editingAlarmObject ? NSLocalizedString(@"edit.alarms.view.title", nil) :  NSLocalizedString(@"add.alarms.view.title", nil);
    
    UIBarButtonItem *cancelAlarmBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(didTapCancelAlrmBtn:)];
    self.navigationItem.leftBarButtonItem = cancelAlarmBtn;
    
    UIBarButtonItem *saveAlarmBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(didTapSaveAlrmBtn:)];
    self.navigationItem.rightBarButtonItem = saveAlarmBtn;
}

#pragma mark -
#pragma mark View Life Cycle
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0];
    
    self.addAlarmTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _addAlarmTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _addAlarmTableView.backgroundColor = [UIColor clearColor];
    _addAlarmTableView.dataSource = self;
    _addAlarmTableView.delegate = self;
    self.addAlarmTableView.scrollsToTop = YES;
    
    [self.view addSubview:_addAlarmTableView];
    
    CGRect datePickerFrame = self.view.bounds;
    datePickerFrame.origin.y = datePickerFrame.size.height - kDatePickerViewHeight;
    datePickerFrame.size.height = kDatePickerViewHeight;
    
    self.alarmDatePicker = [[ALDateTimePicker alloc] initWithFrame:datePickerFrame];
    _alarmDatePicker.datePickerViewDelegate = self;
    [_alarmDatePicker setHidden:YES animated:YES];
    [self.view addSubview:_alarmDatePicker];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicator];
    _activityIndicator.center = self.view.center;
}

#pragma mark -
#pragma mark Action Methods
#pragma mark -

- (void)didTapCancelAlrmBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didTapSaveAlrmBtn:(id)sender
{
    [_currentResponderField resignFirstResponder];
    
    NSString *errorMessage = [self validateCurrentALarmInputs];
    
    if (errorMessage)
    {
        //Show error
        [ALUtility showAlertWithTitle:@"Alarm"
                              message:errorMessage
                    cancelButtonTitle:NSLocalizedString(@"OK", nil)];
        
        return;
    }
    
    [_activityIndicator startAnimating];
    
    //If the an existing alarm is being edited, then delete that alarm and create new one with updated input values.
    if (_editingAlarmObject)
    {
        [[ALAlarmsManager sharedManager] removeAlarmWithIdentifier:_editingAlarmObject.alarmUniqueID];
        [[ALAlarmsManager sharedManager] addAlarmWithTitle:_alarmTitleString andDate:_alarmDateString];
    }
    else
    {
        [[ALAlarmsManager sharedManager] addAlarmWithTitle:_alarmTitleString andDate:_alarmDateString];
    }
    
    [_activityIndicator stopAnimating];
    
    //Dismiss after adding the alarm
    [self didTapCancelAlrmBtn:nil];
}

- (void)didTapDatePickerDoneBtn:(id)sender
{
    self.alarmDateString = [ALUtility stringFromDate:_alarmDatePicker.datePicker.date];
    [self handleTapGesture:nil];
    
    [_addAlarmTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return eAddAlarmTableSectionsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = nil;
    
    switch (section)
    {
        case eAlarmTitleTableSection:
        {
            headerTitle = NSLocalizedString(@"alarm.title.section.header", nil);
            break;
        }
            
        case eAlarmDateTableSection:
        {
            headerTitle = NSLocalizedString(@"alarm.date.section.header", nil);
            break;
        }
            
        default:
        {
            
            break;
        }
    }
    
    ALAddAlarmTableHeaderView *headerView = [[ALAddAlarmTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, kHeaderViewHeight)];
    headerView.tableViewHeaderLabel.text = headerTitle;
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *footerTitle = nil;
    
    switch (section)
    {
        case eAlarmTitleTableSection:
        {
            footerTitle = NSLocalizedString(@"alarm.title.section.footer", nil);
            break;
        }
            
        case eAlarmDateTableSection:
        {
            footerTitle = NSLocalizedString(@"alarm.date.section.footer", nil);
            break;
        }
            
        default:
        {
            
            break;
        }
    }
    
    ALAddAlarmTableHeaderView *footerView = [[ALAddAlarmTableHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, kHeaderViewHeight)];
    footerView.tableViewHeaderLabel.text = footerTitle;
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *alarmCell = nil;
    
    switch (indexPath.section)
    {
        case eAlarmTitleTableSection:
        {
            ALTextFieldTableViewCellCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"ALTextFieldTableViewCellCell"];
            if (!textFieldCell)
            {
                textFieldCell = [[ALTextFieldTableViewCellCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                    reuseIdentifier:@"ALTextFieldTableViewCellCell"];
                textFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
                textFieldCell.textFieldCellDelegate = self;
                textFieldCell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            textFieldCell.inputTextField.text = _alarmTitleString;
            textFieldCell.inputTextField.tag = 1;
            self.currentResponderField = textFieldCell.inputTextField;
            
            alarmCell = textFieldCell;
            
            break;
        }
            
        case eAlarmDateTableSection:
        {
            UITableViewCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewAlarmCell"];
            if (!dateCell)
            {
                dateCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"UITableViewAlarmCell"];
                dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
                dateCell.textLabel.backgroundColor = [UIColor whiteColor];
                dateCell.textLabel.font = [UIFont systemFontOfSize:15];
                dateCell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            dateCell.textLabel.text = _alarmDateString;
            
            alarmCell = dateCell;
            
            break;
        }
            
        default:
            break;
    }
    
    return alarmCell;
}

#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((indexPath.section == eAlarmDateTableSection) && _alarmDatePicker.isHidden)
    {
        [_currentResponderField resignFirstResponder];
        [_alarmDatePicker setHidden:NO animated:YES];
        [self addTapGesture];
        
        [_addAlarmTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark -
#pragma mark ALTextFieldTableViewCellCellDelegate
#pragma mark -

- (void)inputTextFieldDidBeginEditing:(UITextField*)textField forCellIndexPath:(NSIndexPath*)cellIndexPath
{
    self.currentResponderField = textField;
    [self addTapGesture];
    
    [_alarmDatePicker setHidden:YES animated:YES];
    [_addAlarmTableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)inputTextFieldDidEndEditing:(UITextField*)textField forCellIndexPath:(NSIndexPath*)cellIndexPath
{
    switch (cellIndexPath.section)
    {
        case eAlarmTitleTableSection:
        {
            _alarmTitleString = textField.text;
            break;
        }
            
        default:
        {
            break;
        }
    }
}

- (void)inputTextFieldShouldReturnCalledFor:(UITextField *)textField forCellIndexPath:(NSIndexPath*)cellIndexPath
{
    [self handleTapGesture:nil];
    [_addAlarmTableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark Private Helpers
#pragma mark -

- (NSString *)validateCurrentALarmInputs
{
    NSString *errorMessage = nil;
    
    if (!_alarmTitleString.length)
    {
        errorMessage = NSLocalizedString(@"alarm.no.title.error", nil);
    }
    
    if (!errorMessage && !_alarmDateString.length)
    {
        errorMessage = NSLocalizedString(@"alarm.no.date.error", nil);
    }
    
    if (!errorMessage)
    {
        NSComparisonResult comparisonResult = [_alarmDatePicker.datePicker.date compare:[NSDate date]];
        
        if (comparisonResult != NSOrderedDescending)
        {
            errorMessage = NSLocalizedString(@"alarm.no.date.error", nil);
        }
    }
    
    return errorMessage;
}

#pragma mark -
#pragma mark Gesture Recognizer to Hide Keyboards
#pragma mark -

- (void)addTapGesture
{
    if(_singleTapGesture)
    {
        [_addAlarmTableView removeGestureRecognizer:_singleTapGesture];
        self.singleTapGesture = nil;
    }
    
    self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_addAlarmTableView addGestureRecognizer:_singleTapGesture];
    
    if(!([[UIScreen mainScreen ] bounds].size.height > 480.0))
    {
        // Get the size of the keyboard.
        CGFloat keyboardHeight = 260.0;
        CGRect newTableFrame = _addAlarmTableView.frame;
        newTableFrame.size.height -= keyboardHeight;
        _addAlarmTableView.frame = newTableFrame;
        //Here make adjustments to the tableview frame based on the value in keyboard size
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer*)singleTapGesture
{
    [_addAlarmTableView removeGestureRecognizer:_singleTapGesture];
    self.singleTapGesture = nil;
    
    [_currentResponderField resignFirstResponder];
    [_alarmDatePicker setHidden:YES animated:YES];
    
    if(!([[UIScreen mainScreen ] bounds].size.height > 480.0))
    {
        // Get the size of the keyboard.
        CGFloat keyboardHeight = 260.0;
        CGRect newTableFrame = _addAlarmTableView.frame;
        newTableFrame.size.height += keyboardHeight;
        _addAlarmTableView.frame = newTableFrame;
        //Here make adjustments to the tableview frame based on the value in keyboard size
    }
}

#pragma mark -
#pragma mark Memory Management
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
