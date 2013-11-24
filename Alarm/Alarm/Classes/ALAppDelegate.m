//
//  ALAppDelegate.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 24/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALAppDelegate.h"
#import "ALAlarmsListViewController.h"

@interface ALAppDelegate ()

@property (weak, nonatomic) ALAlarmsListViewController *alarmsListViewController;

@end

@implementation ALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    ALAlarmsListViewController *alarmsListViewController = [[ALAlarmsListViewController alloc] init];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:alarmsListViewController];
    _window.rootViewController = _mainNavigationController;
    self.alarmsListViewController = alarmsListViewController;
    
    [self.window makeKeyAndVisible];
    
    /*
     If the application is launched by tapping on the alarm local notification
     */
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        [_alarmsListViewController handleAlarmNotificationWithID:[localNotif.userInfo objectForKey:@"alarmUniqueID"]
                                            withNotificationBody:localNotif.alertBody
                                                       playAlarm:NO];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // Play a sound and show an alert only if the application is active, to avoid doubly notifiying the user.
    
    /*
     If the alarm is fired while the application is not in suspended state.
     */
    [_alarmsListViewController handleAlarmNotificationWithID:[notification.userInfo objectForKey:@"alarmUniqueID"]
                                        withNotificationBody:notification.alertBody
                                                   playAlarm:(application.applicationState == UIApplicationStateActive)];
}

@end
