//
//  UIWindow+Shake.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 04/12/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "UIWindow+Shake.h"

@implementation UIWindow (Shake)

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ((event.type == UIEventTypeMotion) && (event.subtype == UIEventSubtypeMotionShake))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUIWindowDidShake object:nil userInfo:nil];
    }
}

@end
