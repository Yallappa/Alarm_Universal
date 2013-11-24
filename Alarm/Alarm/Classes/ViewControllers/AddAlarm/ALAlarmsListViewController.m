//
//  ALAlarmsListViewController.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALAlarmsListViewController.h"
#import "ALAddAlarmViewController.h"
#import "ALAlarmObject.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ALAlarmAlertView.h"

@interface ALAlarmsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *alarmsTableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) NSMutableArray *alarmsList;

@property (strong, nonatomic) NSString *currentAlarmUiniqueID;
@property (strong, nonatomic) ALAlarmAlertView *alarmAlertView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ALAlarmsListViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = NSLocalizedString(@"alarms.view.title", nil);
        
        UIBarButtonItem *addAlarmBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self
                                                                                     action:@selector(didTapAddAlarmBtn:)];
        self.navigationItem.rightBarButtonItem = addAlarmBtn;
        
        /**
         If a new alarm is added this notification is posted. Here fetch new alarm list and reload the table view.
         */
        __weak ALAlarmsListViewController *weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:kDidAddNewAlarmNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              
                                                              weakSelf.alarmsList = [ALAlarmsManager sharedManager].allAlarmsList;
                                                              [_alarmsTableView reloadData];
                                                          });
                                                      }];
        
        self.alarmsList = [ALAlarmsManager sharedManager].allAlarmsList;
    }
    return self;
}

#pragma mark -
#pragma mark View Life Cycle
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.alarmsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _alarmsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _alarmsTableView.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:244.0/255 alpha:1.0];
    _alarmsTableView.dataSource = self;
    _alarmsTableView.delegate = self;
    self.alarmsTableView.scrollsToTop = YES;
    
    [self.view addSubview:_alarmsTableView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicator];
    _activityIndicator.center = self.view.center;
}

#pragma mark -
#pragma mark Action Methods
#pragma mark -

- (void)didTapAddAlarmBtn:(id)sender
{
    //Before showing new alarm add view, save the current list to repo.
    [[ALAlarmsManager sharedManager] saveNewAlarmsWithList:[NSArray arrayWithArray:_alarmsList]];
    
    ALAddAlarmViewController *addAlarmViewController = [[ALAddAlarmViewController alloc] init];
    UINavigationController *addAlarmNavigationController = [[UINavigationController alloc] initWithRootViewController:addAlarmViewController];
    
    [self presentViewController:addAlarmNavigationController
                       animated:YES
                     completion:^{
                         
                     }];
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _alarmsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *alarmCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewAlarmCell"];
    
    if (alarmCell == nil)
    {
        alarmCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewAlarmCell"];
        alarmCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAlarmObject *alarmObject = [_alarmsList objectAtIndex:indexPath.row];
    alarmCell.textLabel.text = alarmObject.alarmTitle;
    alarmCell.detailTextLabel.text = alarmObject.alarmDateString;
    
    return alarmCell;
}

#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALAlarmObject *alarmObject = [_alarmsList objectAtIndex:indexPath.row];
    ALAddAlarmViewController *addAlarmViewController = [[ALAddAlarmViewController alloc] initWithAlarmObject:alarmObject];
    UINavigationController *addAlarmNavigationController = [[UINavigationController alloc] initWithRootViewController:addAlarmViewController];
    
    [self presentViewController:addAlarmNavigationController
                       animated:YES
                     completion:^{
                         
                     }];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //Code here for when you hit delete
        [_activityIndicator startAnimating];
        
        ALAlarmObject *alarmObject = [_alarmsList objectAtIndex:indexPath.row];
        [[ALAlarmsManager sharedManager] removeAlarmWithIdentifier:alarmObject.alarmUniqueID];
        
        [tableView reloadData];
        
        [_activityIndicator stopAnimating];
    }
}

#pragma mark -
#pragma mark Alarm Notification Handlers
#pragma mark -

- (void)handleAlarmNotificationWithID:(NSString *)alarmUniqueID withNotificationBody:(NSString *)notificationBody playAlarm:(BOOL)playAlarm
{
    /**
     Play alarm only if the application is in actiove(fore ground state). If the application is come from background does mean that, he has already heard the alarm sound
     */
    if (playAlarm)
    {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"alarm_sound1" ofType:@"mp3"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        if (!_audioPlayer)
        {
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            _audioPlayer.numberOfLoops = -1;
        }
        [_audioPlayer play];
    }
    
    self.currentAlarmUiniqueID = alarmUniqueID;
    self.alarmAlertView = [[ALAlarmAlertView alloc] initWithTitle:NSLocalizedString(@"Alarm", nil)
                                                          message:notificationBody
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"close", nil)
                                                otherButtonTitles:NSLocalizedString(@"snooze", nil), nil];
    [_alarmAlertView show];
    
}

//UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [_audioPlayer stop];
    
    switch (buttonIndex)
    {
        case eAlarmAlertActionDismiss:
        {
            
            break;
        }
        case eAlarmAlertActionSnooze:
        {
            ALAlarmsManager *sharedManager = [ALAlarmsManager sharedManager];
            ALAlarmObject *alarmObject = [[sharedManager alarmObjectWithID:_currentAlarmUiniqueID] copy];
            alarmObject.alarmDate = [alarmObject.alarmDate dateByAddingTimeInterval:(60 * 15)];//Snooze by 15minutes
            alarmObject.alarmDateString = [ALUtility stringFromDate:alarmObject.alarmDate];
            
            [[ALAlarmsManager sharedManager] removeAlarmWithIdentifier:_currentAlarmUiniqueID];
            [[ALAlarmsManager sharedManager] addAlarmWithTitle:alarmObject.alarmTitle andDate:alarmObject.alarmDateString];
            
            break;
        }
            
        default:
            break;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidAddNewAlarmNotification object:nil];
}

@end
