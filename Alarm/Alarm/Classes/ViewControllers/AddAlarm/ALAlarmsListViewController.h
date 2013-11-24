//
//  ALAlarmsListViewController.h
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALAlarmsListViewController : UIViewController

- (void)handleAlarmNotificationWithID:(NSString *)alarmUniqueID withNotificationBody:(NSString *)notificationBody playAlarm:(BOOL)playAlarm;

@end
