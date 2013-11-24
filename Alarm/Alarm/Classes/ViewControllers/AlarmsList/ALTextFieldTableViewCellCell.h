//
//  ALTextFieldTableViewCellCell.h
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALTextFieldTableViewCellCellDelegate;

@interface ALTextFieldTableViewCellCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<ALTextFieldTableViewCellCellDelegate> textFieldCellDelegate;
@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;

@end

@protocol ALTextFieldTableViewCellCellDelegate <NSObject>
@optional
- (void)inputTextFieldDidBeginEditing:(UITextField*)textField forCellIndexPath:(NSIndexPath*)cellIndexPath;
- (void)inputTextFieldDidEndEditing:(UITextField*)textField forCellIndexPath:(NSIndexPath*)cellIndexPath;
- (void)inputTextFieldShouldReturnCalledFor:(UITextField *)textField forCellIndexPath:(NSIndexPath*)cellIndexPath;
- (void)inputTextFieldTextDidChange:(UITextField *)textField forCellIndexPath:(NSIndexPath*)cellIndexPath;

@end
