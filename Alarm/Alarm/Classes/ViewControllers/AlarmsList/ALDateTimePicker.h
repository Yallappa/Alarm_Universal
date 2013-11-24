//
//  ALDateTimePicker.h
//  Alarm
//
//  Created by Yallappa Kuntennavar on 25/11/13.
//  Copyright (c) 2013 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALDateTimePickerDelegate;

@interface ALDateTimePicker : UIView

@property (strong, nonatomic, readonly) UIDatePicker *datePicker;
@property (unsafe_unretained, nonatomic) BOOL isHidden;

@property (weak, nonatomic) id<ALDateTimePickerDelegate>datePickerViewDelegate;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end


@protocol ALDateTimePickerDelegate <NSObject>
@optional

- (void)didTapDatePickerDoneBtn:(id)sender;

@end
