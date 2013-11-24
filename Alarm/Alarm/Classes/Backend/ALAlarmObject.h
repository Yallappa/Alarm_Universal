//
//  ALAlarmObject.h
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALAlarmObject : NSObject

@property (strong, nonatomic) NSString *alarmTitle;
@property (strong, nonatomic) NSString *alarmDateString;
@property (strong, nonatomic) NSDate *alarmDate;
@property (strong, nonatomic) NSString *alarmUniqueID;

@end
