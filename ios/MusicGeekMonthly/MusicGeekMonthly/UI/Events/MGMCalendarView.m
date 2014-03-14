//
//  MGMCalendarView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMCalendarView.h"

@interface MGMCalendarView ()

@property (readonly) UIImageView* imageView;
@property (readonly) UILabel* monthLabel;
@property (readonly) UILabel* dayLabel;

@end

@implementation MGMCalendarView

- (void) commonInit
{
    [super commonInit];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image = [UIImage imageNamed:@"date.png"];
    _imageView.backgroundColor = [UIColor clearColor];

    _monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    _monthLabel.backgroundColor = [UIColor clearColor];
    _monthLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:15];
    _monthLabel.adjustsFontSizeToFitWidth = NO;

    _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:40];
    _dayLabel.adjustsFontSizeToFitWidth = NO;

    [self addSubview:_imageView];
    [_imageView addSubview:_monthLabel];
    [_imageView addSubview:_dayLabel];

    self.backgroundColor = [UIColor clearColor];
}

- (NSString*) month
{
    return self.monthLabel.text;
}

- (void) setMonth:(NSString*)month
{
    self.monthLabel.text = month;
}

- (NSString*) day
{
    return self.dayLabel.text;
}

- (void) setDay:(NSString*)day
{
    self.dayLabel.text = day;
}

- (UIFont*) monthFont
{
    return self.monthLabel.font;
}

- (void) setMonthFont:(UIFont*)monthFont
{
    self.monthLabel.font = monthFont;
}

- (UIFont*) dayFont
{
    return self.dayLabel.font;
}

- (void) setDayFont:(UIFont*)dayFont
{
    self.dayLabel.font = dayFont;
}

- (void) layoutSubviews
{
    CGSize size = self.frame.size;
    self.imageView.frame = CGRectMake(0, 0, size.width, size.height);

    CGFloat height = size.height;

    CGFloat monthY = 44.0 / 512.0 * height;
    CGFloat monthHeight = (114.0 - 44.0) / 512.0 * height;
    self.monthLabel.frame = CGRectMake(0, monthY, size.width, monthHeight);

    CGFloat dayY = 126.0 / 512.0 * height;
    CGFloat dayHeight = (426.0 - 126.0) / 512.0 * height;
    self.dayLabel.frame = CGRectMake(0, dayY, size.width, dayHeight);
}

@end
