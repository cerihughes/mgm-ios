//
//  MGMHomeView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMHomeView.h"

#import "CKCalendarView.h"
#import "MGMPulsatingAlbumsView.h"

@interface MGMHomeView () <CKCalendarDelegate>

@property (strong) MGMPulsatingAlbumsView* albumsView;
@property (strong) UILabel* titleLabel;
@property (strong) UILabel* nextMeetingLabel;
@property (strong) CKCalendarView* calendarView;

@end

@implementation MGMHomeView

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    self.albumsView = [[MGMPulsatingAlbumsView alloc] initWithFrame:self.frame];
    self.calendarView = [[CKCalendarView  alloc] initWithFrame:CGRectZero];
    CGFloat titleFontSize = self.ipad ? 20.0 : 14.0;
    CGFloat dayFontSize = self.ipad ? 13.0 : 9.0;
    CGFloat dateFontSize = self.ipad ? 18.0 : 13.0;
    self.calendarView.titleFont = [UIFont boldSystemFontOfSize:titleFontSize];
    self.calendarView.dayOfWeekFont = [UIFont boldSystemFontOfSize:dayFontSize];
    self.calendarView.dateFont = [UIFont boldSystemFontOfSize:dateFontSize];
    self.calendarView.delegate = self;

    self.titleLabel = [MGMView boldLabelWithText:@"This month we're listening to:"];
    self.nextMeetingLabel = [MGMView boldLabelWithText:@"Next meeting:"];

    [self addSubview:self.albumsView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.classicAlbumView];
    [self addSubview:self.newlyReleasedAlbumView];
    [self addSubview:self.classicAlbumLabel];
    [self addSubview:self.newlyReleasedAlbumLabel];
    [self addSubview:self.nextMeetingLabel];
    [self addSubview:self.calendarView];

    self.nextEventDate = nil;
}

- (void) setNextEventDate:(NSDate *)nextEventDate
{
    self.calendarView.hidden = (nextEventDate == nil);
    [self.calendarView selectDate:nextEventDate makeVisible:YES];
}

- (NSUInteger) setBackgroundAlbumsInRow:(NSUInteger)albumsInRow
{
    [self.albumsView setupAlbumsInRow:4];
    return self.albumsView.albumCount;
}

- (void) renderBackgroundAlbumImage:(UIImage *)image atIndex:(NSUInteger)index animation:(BOOL)animation
{
    [self.albumsView renderImage:image atIndex:index animation:YES];
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.albumsView.frame = self.frame;

    self.titleLabel.frame = CGRectMake(20, 20, 280, 21);
    self.classicAlbumView.frame = CGRectMake(0, 49, 160, 160);
    self.newlyReleasedAlbumView.frame = CGRectMake(160, 49, 160, 160);

    CGFloat delta = (self.frame.size.height - 480.0) / 2;
    if (delta > 0)
    {
        self.classicAlbumLabel.frame = CGRectMake(0, 209, 160, 21);
        self.newlyReleasedAlbumLabel.frame = CGRectMake(160, 209, 160, 21);
    }
    else
    {
        self.classicAlbumLabel.frame = CGRectZero;
        self.newlyReleasedAlbumLabel.frame = CGRectZero;
    }

    self.nextMeetingLabel.frame = CGRectMake(20, 217 + delta, 280, 21);
    self.calendarView.frame = CGRectMake(71, 246 + delta, 178, 131);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.albumsView.frame = self.frame;

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
