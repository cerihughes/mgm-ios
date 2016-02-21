//
//  MGMEventsModalViewTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "MGMAlbumRenderService.h"
#import "MGMCoreDataAccess.h"
#import "MGMDefaultMockContainer.h"
#import "MGMDaoData.h"
#import "MGMEventsModalView.h"
#import "MGMEventTableViewDataSource.h"
#import "MGMImageHelper.h"
#import "MGMMockModelUtilities.h"
#import "MGMSnapshotTestCaseImageUtilities.h"

@interface MGMEventsModalViewTestCase : MGMSnapshotFullscreenDeviceTestCase

@property (nonatomic, strong) MGMMockModelUtilities *mockModelUtilities;

@property (nonatomic, strong) MGMCoreDataAccess *coreDataAccessMock;
@property (nonatomic, strong) MGMAlbumRenderService *albumRenderServiceMock;
@property (nonatomic, strong) MGMImageHelper *imageHelperMock;

@property (nonatomic, strong) MGMEventsModalView *view;
@property (nonatomic, strong) MGMEventTableViewDataSource *dataSource;

@end

@implementation MGMEventsModalViewTestCase

- (void)setUp
{
    [super setUp];

    self.mockModelUtilities = [[MGMMockModelUtilities alloc] initWithMockGenerator:self.mockContainer];

    self.coreDataAccessMock = [self.mockContainer mockObject:[MGMCoreDataAccess class]];
    self.albumRenderServiceMock = [self.mockContainer mockObject:[MGMAlbumRenderService class]];
    self.imageHelperMock = [self.mockContainer mockObject:[MGMImageHelper class]];

    NSString *initialDateString = @"15/05/2013";
    NSMutableArray *mockEvents = [NSMutableArray array];
    for (int i = 1; i < 26; i++) {
        NSString *eventDateString = [self dateStringFromDateString:initialDateString afterWeeks:i];
        [mockEvents addObject:[self.mockModelUtilities mockEventWithEventNumber:i
                                                                eventDateString:eventDateString
                                                                     playlistId:[NSString stringWithFormat:@"ID%d", i]
                                                              classicArtistName:[NSString stringWithFormat:@"Classic Artist %d", i]
                                                               classicAlbumName:[NSString stringWithFormat:@"Classic Album %d", i]
                                                              classicAlbumScore:i / 2.6f
                                                        newlyReleasedArtistName:[NSString stringWithFormat:@"Newly Released Artist %d", i]
                                                         newlyReleasedAlbumName:[NSString stringWithFormat:@"Newly Released Album %d", i]
                                                        newlyReleasedAlbumScore:i / 2.6f
                                                             coreDataAccessMock:self.coreDataAccessMock]];
    }

    [MGMSnapshotTestCaseImageUtilities setupAlbumRenderServiceMock:self.albumRenderServiceMock];
    [MGMSnapshotTestCaseImageUtilities setupImageHelperMock:self.imageHelperMock toReturnImageOfSize:256];

    self.dataSource = [[MGMEventTableViewDataSource alloc] initWithCellId:@"CellID"];
    self.dataSource.albumRenderService = self.albumRenderServiceMock;
    self.dataSource.coreDataAccess = self.coreDataAccessMock;
    self.dataSource.imageHelper = self.imageHelperMock;
    [self.dataSource setRenderables:mockEvents];
}

- (NSString *)dateStringFromDateString:(NSString *)dateString afterWeeks:(NSUInteger)weeks
{
    NSDateFormatter *formatter = self.mockModelUtilities.dateFormatter;
    NSDate *date = [formatter dateFromString:dateString];
    NSTimeInterval oneWeek = 60 * 60 * 24 * 7;
    date = [date dateByAddingTimeInterval:oneWeek * weeks];
    return [formatter stringFromDate:date];
}

- (void)runTestInFrame:(CGRect)frame
{
    self.view = [[MGMEventsModalView alloc] initWithFrame:frame];
    self.view.eventsTable.dataSource = self.dataSource;

    [self.view layoutIfNeeded];
    
    [self snapshotView:self.view];
}

@end
