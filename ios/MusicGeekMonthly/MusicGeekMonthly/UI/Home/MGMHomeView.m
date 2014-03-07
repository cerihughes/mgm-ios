//
//  MGMHomeView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeView.h"

#import "CKCalendarView.h"

@interface MGMHomeView () <CKCalendarDelegate>

@property (readonly) UIView* parentView;
@property (readonly) UILabel* titleLabel;
@property (readonly) UILabel* nextMeetingLabel;
@property (readonly) CKCalendarView* calendarView;

@end

@implementation MGMHomeView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    _calendarView = [[CKCalendarView  alloc] initWithFrame:CGRectZero];
    BOOL ipad = self.screenSize == MGMViewScreenSizeiPad;
    CGFloat titleFontSize = ipad ? 20.0 : 14.0;
    CGFloat dayFontSize = ipad ? 13.0 : 9.0;
    CGFloat dateFontSize = ipad ? 18.0 : 13.0;
    _calendarView.titleFont = [UIFont boldSystemFontOfSize:titleFontSize];
    _calendarView.dayOfWeekFont = [UIFont boldSystemFontOfSize:dayFontSize];
    _calendarView.dateFont = [UIFont boldSystemFontOfSize:dateFontSize];
    _calendarView.delegate = self;

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
    [self.calendarView selectDate:nextEventDate makeVisible:YES];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.titleLabel.frame = CGRectMake(20, 20, 280, 21);

    self.classicAlbumLabel.frame = CGRectMake(0, 51, 160, 21);
    self.newlyReleasedAlbumLabel.frame = CGRectMake(160, 51, 160, 21);

    self.classicAlbumView.frame = CGRectMake(0, 82, 160, 160);
    self.newlyReleasedAlbumView.frame = CGRectMake(160, 82, 160, 160);

    self.nextMeetingLabel.frame = CGRectMake(20, 260, 280, 21);
    self.calendarView.frame = CGRectMake(71, 290, 178, 131);

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
    self.calendarView.frame = CGRectMake(224, 635, 320, 248);
}

#pragma mark -
#pragma mark CKCalendarDelegate

- (BOOL)calendar:(CKCalendarView*)calendar willSelectDate:(NSDate*)date
{
    return NO;
}

- (BOOL)calendar:(CKCalendarView*)calendar willDeselectDate:(NSDate*)date
{
    return NO;
}

- (BOOL)calendar:(CKCalendarView*)calendar willChangeToMonth:(NSDate*)date
{
    return NO;
}

@end
