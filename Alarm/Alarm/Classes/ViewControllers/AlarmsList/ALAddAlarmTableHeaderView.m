//
//  ALAddAlarmTableHeaderView.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALAddAlarmTableHeaderView.h"

@implementation ALAddAlarmTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(.0, frame.size.height - 1.0, frame.size.width, 1.0)];
        separatorLine.backgroundColor = [UIColor clearColor];
        [self addSubview:separatorLine];
        
        frame.origin.x = 15.0;
        frame.size.width = frame.size.width - frame.origin.x;
        
        self.tableViewHeaderLabel = [[UILabel alloc] initWithFrame:frame];
        _tableViewHeaderLabel.backgroundColor = [UIColor clearColor];
        _tableViewHeaderLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:_tableViewHeaderLabel];
    }
    
    return self;
}

@end
