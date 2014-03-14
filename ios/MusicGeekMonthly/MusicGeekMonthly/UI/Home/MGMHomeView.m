//
//  MGMHomeView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeView.h"

#import "MGMCalendarView.h"

@interface MGMHomeView ()

@property (readonly) NSDateFormatter* monthDateFormatter;
@property (readonly) NSDateFormatter* dayDateFormatter;

@property (readonly) UIView* parentView;
@property (readonly) UILabel* titleLabel;
@property (readonly) UILabel* nextMeetingLabel;
@property (readonly) MGMCalendarView* calendarView;

@end

@implementation MGMHomeView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    _monthDateFormatter = [[NSDateFormatter alloc] init];
    _monthDateFormatter.dateFormat = @"MMM";

    _dayDateFormatter = [[NSDateFormatter alloc] init];
    _dayDateFormatter.dateFormat = @"d";

    BOOL ipad = self.screenSize == MGMViewScreenSizeiPad;
    CGFloat monthFontSize = ipad ? 30.0 : 20.0;
    CGFloat dayFontSize = ipad ? 80.0 : 64.0;
    _calendarView = [[MGMCalendarView  alloc] initWithFrame:CGRectZero];
    _calendarView.monthFont = [UIFont boldSystemFontOfSize:monthFontSize];
    _calendarView.dayFont = [UIFont boldSystemFontOfSize:dayFontSize];

    _titleLabel = [MGMView boldTitleLabelWithText:@"This month we're listening to:"];
    _nextMeetingLabel = [MGMView italicTitleLabelWithText:@"Next meeting:"];

    [_parentView addSubview:_titleLabel];
    [_parentView addSubview:self.classicAlbumView];
    [_parentView addSubview:self.newlyReleasedAlbumView];
    [_parentView addSubview:self.classicAlbumLabel];
    [_parentView addSubview:self.newlyReleasedAlbumLabel];
    [_parentView addSubview:_nextMeetingLabel];
    [_parentView addSubview:_calendarView];
    [_parentView addSubview:self.playlistLabel];
    [_parentView addSubview:self.playlistView];
    [self addSubview:_parentView];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    CGRect frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 20);
    _parentView = [[UIScrollView alloc] initWithFrame:frame];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    _parentView = [[UIView alloc] initWithFrame:self.frame];
}

- (void) setNextEventDate:(NSDate *)nextEventDate
{
    self.calendarView.hidden = (nextEventDate == nil);

    self.calendarView.month = [self.monthDateFormatter stringFromDate:nextEventDate];
    self.calendarView.day = [self.dayDateFormatter stringFromDate:nextEventDate];

    [self.calendarView setNeedsLayout];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.titleLabel.frame = CGRectMake(20, 20, 280, 21);

    self.classicAlbumLabel.frame = CGRectMake(0, 51, 160, 21);
    self.newlyReleasedAlbumLabel.frame = CGRectMake(160, 51, 160, 21);

    self.classicAlbumView.frame = CGRectMake(0, 82, 160, 160);
    self.newlyReleasedAlbumView.frame = CGRectMake(160, 82, 160, 160);

    self.nextMeetingLabel.frame = CGRectMake(20, 265, 280, 21);

    CGFloat calendarWidth = 512.0 / 3.0;
    CGFloat calendarHeight = 512.0 / 3.0;
    self.calendarView.frame = CGRectMake((320.0 - calendarWidth) / 2.0, 295, calendarWidth, calendarHeight);

    UIView* lastView = self.calendarView;
    if (self.playlistLabel.hidden == NO)
    {
        self.playlistLabel.frame = CGRectMake(0, 484, 320, 21);
        self.playlistView.frame = CGRectMake(50, 515, 220, 220);
        lastView = self.playlistView;
    }

    // Need to create a contentRect that's got space to scroll over the tab bar...
    CGRect contentRect = CGRectUnion(CGRectZero, lastView.frame);
    contentRect = CGRectInset(contentRect, 0, -self.tabBarHeight);

    UIScrollView* scrollView = (UIScrollView*)self.parentView;
    scrollView.contentSize = contentRect.size;
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.titleLabel.frame = CGRectMake(20, 42, 728, 49);
    self.classicAlbumView.frame = CGRectMake(55, 135, 300, 300);
    self.newlyReleasedAlbumView.frame = CGRectMake(413, 135, 300, 300);
    self.classicAlbumLabel.frame = CGRectMake(55, 442, 300, 45);
    self.newlyReleasedAlbumLabel.frame = CGRectMake(413, 442, 300, 45);

    self.nextMeetingLabel.frame = CGRectMake(20, 545, 728, 49);

    CGFloat calendarWidth = 512.0 / 2.0;
    CGFloat calendarHeight = 512.0 / 2.0;
    self.calendarView.frame = CGRectMake((768.0 - calendarWidth) / 2.0, 635, calendarWidth, calendarHeight);
}

@end
