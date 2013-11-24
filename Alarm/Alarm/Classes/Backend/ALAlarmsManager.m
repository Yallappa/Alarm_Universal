//
//  ALAlarmsManager.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALAlarmsManager.h"
#import "ALAlarmObject.h"
#import <EventKit/EventKit.h>

@interface ALAlarmsManager ()

+ (NSString *)alarmsDatasourceFilePath;
+ (void)createDatasourceFilePath;

- (NSArray *)fetchAllAlarmsFromStore;

@end

@implementation ALAlarmsManager

- (id)init
{
    self = [super init];
    if (self)
    {
        /**
         Before application will enter to inactive state, save all the added alarms to database(plist).
         */
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          
                                                          [[ALAlarmsManager sharedManager] saveNewAlarmsWithList:[NSArray arrayWithArray:[ALAlarmsManager sharedManager].allAlarmsList]];
                                                      }];
    }
    return self;
}

+ (ALAlarmsManager *)sharedManager
{
    static ALAlarmsManager *sharedManager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[ALAlarmsManager alloc] init];
        
        /**
         If default empty database is not created, now it is the time to do it.
         */
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:[ALAlarmsManager alarmsDatasourceFilePath]])
        {
            [ALAlarmsManager createDatasourceFilePath];
            sharedManager.allAlarmsList = [NSMutableArray arrayWithCapacity:1];
        }
        else
        {
            sharedManager.allAlarmsList = [[sharedManager fetchAllAlarmsFromStore] mutableCopy];
        }
    });
    
    return sharedManager;
}

#pragma mark -
#pragma mark Helpers
#pragma mark -

+ (NSString *)alarmsDatasourceFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *datasourceFilePath = [documentsDirectory stringByAppendingPathComponent:@"ScheduledAlarms.plist"];
    
    return datasourceFilePath;
}

+ (void)createDatasourceFilePath
{
    NSArray *alarmsArray = [[NSArray alloc] init];
    
    NSError *error = nil;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:alarmsArray];
    [archiveData writeToFile:[ALAlarmsManager alarmsDatasourceFilePath] options:NSDataWritingAtomic error:&error];
}

#pragma mark -
#pragma mark Alarms Fetch
#pragma mark -

/**
 Fetch all the stored alarms in databse
 */
- (NSArray *)fetchAllAlarmsFromStore
{
    NSData *archiveData = [NSData dataWithContentsOfFile:[ALAlarmsManager alarmsDatasourceFilePath]];
    NSArray *alarmsArray = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    
    return alarmsArray;
}

- (ALAlarmObject *)alarmObjectWithID:(NSString *)alarmUniqueID
{
    ALAlarmObject *alarmObject = nil;
    
    NSMutableArray *allAlarmsList = [ALAlarmsManager sharedManager].allAlarmsList;
    for (alarmObject in allAlarmsList)
    {
        if ([alarmObject.alarmUniqueID isEqualToString:alarmUniqueID])
        {
            break;
        }
    }
    
    return alarmObject;
}

#pragma mark -
#pragma mark Add Alarm
#pragma mark -

- (void)addAlarmWithTitle:(NSString *)title andDate:(NSString *)dateString
{
    ALAlarmObject *alarmObject = [[ALAlarmObject alloc] init];
    alarmObject.alarmTitle = title;
    alarmObject.alarmDateString = dateString;
    alarmObject.alarmDate = [ALUtility dateFromString:dateString];
    alarmObject.alarmUniqueID = [ALUtility generateUUID];
    
    //Save New Alarm to database
    ALAlarmsManager *sharedManager = [ALAlarmsManager sharedManager];
    [sharedManager.allAlarmsList addObject:alarmObject];
    [sharedManager saveCurrentAlarmList];
    
    //Schedule a local notification for the new alarm time.
    UILocalNotification *localNotification =[[UILocalNotification alloc]init];
    localNotification.fireDate = alarmObject.alarmDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatCalendar = [NSCalendar currentCalendar];
    
    localNotification.alertBody = title;
    localNotification.alertAction = @"Snooze";
    localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.soundName = @"alarm_sound1.mp3";
    localNotification.userInfo = [NSDictionary dictionaryWithObject:alarmObject.alarmUniqueID forKey:@"alarmUniqueID"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddNewAlarmNotification
                                                        object:nil
                                                      userInfo:nil];
}

#pragma mark -
#pragma mark Save Alarms to databae
#pragma mark -

- (void)saveCurrentAlarmList
{
    [self saveNewAlarmsWithList:[NSArray arrayWithArray:[ALAlarmsManager sharedManager].allAlarmsList]];
}

/**
 Save Alarms list to database
 */
- (void)saveNewAlarmsWithList:(NSArray *)alarmsList
{
    NSError *error = nil;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:alarmsList];
    [archiveData writeToFile:[ALAlarmsManager alarmsDatasourceFilePath] options:NSDataWritingAtomic error:&error];
}

#pragma mark -
#pragma mark Delete Alarms
#pragma mark -

- (void)removeAllAlarms
{
    NSArray *allAlarms = [NSArray arrayWithArray:[ALAlarmsManager sharedManager].allAlarmsList];
    
    for (ALAlarmObject *alarmObject in allAlarms)
    {
        [[ALAlarmsManager sharedManager] removeAlarmWithIdentifier:alarmObject.alarmUniqueID];
    }
}

- (void)removeAlarmWithIdentifier:(NSString *)alarmUniqueID
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        /**
         Cancel the shceduled local notification for the alarm and delete it from the list.
         */
        [self cancelLocalNotificationWithID:alarmUniqueID];
        
        NSMutableArray *allAlarmsList = [ALAlarmsManager sharedManager].allAlarmsList;
        for (ALAlarmObject *alarmObject in allAlarmsList)
        {
            if ([alarmObject.alarmUniqueID isEqualToString:alarmUniqueID])
            {
                [allAlarmsList removeObject:alarmObject];
                break;
            }
        }
    });
}

- (void)removeAlarmAtIndex:(NSInteger)alarmIndex
{
    ALAlarmObject *alarmObject = [[ALAlarmsManager sharedManager].allAlarmsList objectAtIndex:alarmIndex];
    [[ALAlarmsManager sharedManager] cancelLocalNotificationWithID:alarmObject.alarmUniqueID];
    
    [[ALAlarmsManager sharedManager].allAlarmsList removeObjectAtIndex:alarmIndex];
}

- (void)cancelLocalNotificationWithID:(NSString *)alarmUniqueID
{
    UILocalNotification *notificationToCancel = nil;
    for (UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if ([[aNotif.userInfo objectForKey:@"alarmUniqueID"] isEqualToString:alarmUniqueID])
        {
            notificationToCancel = aNotif;
            break;
        }
    }
    
    if (notificationToCancel)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }
}

@end
