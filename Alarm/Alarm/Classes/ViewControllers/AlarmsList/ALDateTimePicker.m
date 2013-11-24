//
//  ALDateTimePicker.m
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import "ALDateTimePicker.h"

@interface ALDateTimePicker ()

#define kDateTimePickerHeight 260
#define kDateTimePickerToolbarHeight 40

@property (strong, nonatomic, readwrite) UIDatePicker *datePicker;
@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation ALDateTimePicker

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = kDateTimePickerHeight + kDateTimePickerToolbarHeight;
    self = [super initWithFrame:frame];
    if (self)
    {
        self.originalFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = self.bounds.size.width;
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, kDateTimePickerToolbarHeight, width, kDateTimePickerHeight)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self addSubview: _datePicker];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, width, kDateTimePickerToolbarHeight)];
        toolbar.barStyle = UIBarStyleBlackOpaque;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(donePressed:)];
        doneButton.width = width - 20;
        toolbar.items = [NSArray arrayWithObject: doneButton];
        [self addSubview:toolbar];
    }
    
    return self;
}

#pragma mark -
#pragma mark Action Methods
#pragma mark -

- (void)donePressed:(id)sender
{
    if ([_datePickerViewDelegate respondsToSelector:@selector(didTapDatePickerDoneBtn:)])
    {
        [_datePickerViewDelegate didTapDatePickerDoneBtn:sender];
    }
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.isHidden = hidden;
    
    CGRect newFrame = self.originalFrame;
    newFrame.origin.y += hidden ? kDateTimePickerHeight : 0;
    if (animated)
    {
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             self.frame = newFrame;
                         }];
    }
    else
    {
        self.frame = newFrame;
    }
}

@end
