//
//  ALAlarmsManager.h
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAlarmObject;

@interface ALAlarmsManager : NSObject

@property (strong, nonatomic) NSMutableArray *allAlarmsList;

+ (ALAlarmsManager *)sharedManager;

- (void)saveCurrentAlarmList;
- (void)saveNewAlarmsWithList:(NSArray *)alarmsList;

- (void)addAlarmWithTitle:(NSString *)title andDate:(NSString *)dateString;
- (void)removeAllAlarms;
- (void)removeAlarmWithIdentifier:(NSString *)alarmUniqueID;

- (ALAlarmObject *)alarmObjectWithID:(NSString *)alarmUniqueID;

@end
