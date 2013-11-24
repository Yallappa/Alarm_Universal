//
//  ALUtility.h
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALUtility : NSObject

+ (void)showAlertWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonTitle:(NSString *)inCancelTitle;
+ (BOOL)isValidAlarmDate:(NSString *)dateString;

+ (NSString *)generateUUID;

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
