//
//  ALAlarmAlertView.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALAlarmAlertView.h"

@implementation ALAlarmAlertView

- (id)init
{
    self = [super init];
    if (self)
    {
        [APP_DELEGATE.window becomeFirstResponder];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (!self.isHidden)
    {
        [self dismissWithClickedButtonIndex:eAlarmAlertActionSnooze animated:YES];
    }
}

@end
