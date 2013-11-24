//
//  ALAlarmObject.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALAlarmObject.h"

@implementation ALAlarmObject

#define kAlarmTitle @"AlarmTitle"
#define kAlarmDateString @"AlarmDateString"
#define kAlarmDate @"AlarmDate"
#define kAlarmUniqueID @"AlarmUniqueID"

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark -
#pragma mark NSCoding
#pragma mark -

// Called when the ALAlarmObject need to be unarchived.
- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.alarmTitle = [decoder decodeObjectForKey:kAlarmTitle];
        self.alarmDateString = [decoder decodeObjectForKey:kAlarmDateString];
        self.alarmDate = [decoder decodeObjectForKey:kAlarmDate];
        self.alarmUniqueID = [decoder decodeObjectForKey:kAlarmUniqueID];
    }
    
    return self;
}

// Called when the ALAlarmObject object needs to be archived.
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_alarmTitle forKey:kAlarmTitle];
    [aCoder encodeObject:_alarmDateString forKey:kAlarmDateString];
    [aCoder encodeObject:_alarmDate forKey:kAlarmDate];
    [aCoder encodeObject:_alarmUniqueID forKey:kAlarmUniqueID];
}

#pragma mark -
#pragma mark NSCopying
#pragma mark -

- (id)copyWithZone:(NSZone *)zone
{
    ALAlarmObject *copyALarmObject = [[ALAlarmObject alloc] init];
    
    //deep copying object properties
    copyALarmObject.alarmTitle = [_alarmTitle copyWithZone:zone];
    copyALarmObject.alarmDateString = [_alarmDateString copyWithZone:zone];
    copyALarmObject.alarmDate = [_alarmDate copyWithZone:zone];
    copyALarmObject.alarmUniqueID = [_alarmUniqueID copyWithZone:zone];
    
    return copyALarmObject;
}

@end
