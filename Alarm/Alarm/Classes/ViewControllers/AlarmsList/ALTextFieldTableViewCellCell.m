//
//  ALTextFieldTableViewCellCell.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALTextFieldTableViewCellCell.h"

@implementation ALTextFieldTableViewCellCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.center = self.center;
        _inputTextField.delegate = self;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [self.contentView addSubview:_inputTextField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputFieldTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_inputTextField];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark -
#pragma mark View Layout
#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect nameFieldFrame = self.contentView.frame;
    _inputTextField.frame = nameFieldFrame;
    
    _inputTextField.center = self.contentView.center;
    nameFieldFrame = _inputTextField.frame;
    nameFieldFrame.origin.x = 10.0;
    nameFieldFrame.size.width -= 20.0;
    _inputTextField.frame = nameFieldFrame;
}

#pragma mark -
#pragma mark Delegate Methods Handle
#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([_textFieldCellDelegate respondsToSelector:@selector(inputTextFieldDidBeginEditing:forCellIndexPath:)])
    {
        [_textFieldCellDelegate inputTextFieldDidBeginEditing:textField forCellIndexPath:_cellIndexPath];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([_textFieldCellDelegate respondsToSelector:@selector(inputTextFieldDidEndEditing:forCellIndexPath:)])
    {
        [_textFieldCellDelegate inputTextFieldDidEndEditing:textField forCellIndexPath:_cellIndexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_inputTextField resignFirstResponder];
    if([_textFieldCellDelegate respondsToSelector:@selector(inputTextFieldShouldReturnCalledFor:forCellIndexPath:)])
    {
        [_textFieldCellDelegate inputTextFieldShouldReturnCalledFor:textField forCellIndexPath:_cellIndexPath];
    }
    
    return YES;
}

- (void)inputFieldTextDidChange:(NSNotification *)notification
{
    if([_textFieldCellDelegate respondsToSelector:@selector(inputTextFieldTextDidChange:forCellIndexPath:)])
    {
        [_textFieldCellDelegate inputTextFieldTextDidChange:_inputTextField forCellIndexPath:_cellIndexPath];
    }
}

#pragma mark -
#pragma mark Memory Management
#pragma mark -

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_inputTextField];
}

@end
