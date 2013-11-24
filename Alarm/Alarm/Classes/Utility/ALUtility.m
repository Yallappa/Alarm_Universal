//
//  ALUtility.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALUtility.h"

@implementation ALUtility

+ (void)showAlertWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonTitle:(NSString *)inCancelTitle
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:inTitle
                                                            message:inMessage
                                                           delegate:nil
                                                  cancelButtonTitle:inCancelTitle
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}

+ (BOOL)isValidAlarmDate:(NSString *)dateString
{
    BOOL isValidDate = NO;
    
    return isValidDate;
}

+ (NSString *)generateUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    return (__bridge NSString *)uuidStringRef;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a EEEE, MMM-dd-yyyy"];
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a EEEE, MMM-dd-yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
