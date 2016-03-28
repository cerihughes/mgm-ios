//
//  MGMWeeklyChartModalViewTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#import "MGMCoreDataAccess.h"
#import "MGMCoreDataTableViewDataSource.h"
#import "MGMDefaultMockContainer.h"
#import "MGMMockModelUtilities.h"
#import "MGMWeeklyChartModalView.h"

@interface MGMWeeklyChartModalViewTestCase : MGMSnapshotFullscreenDeviceTestCase

@property (nonatomic, strong) MGMMockModelUtilities *mockModelUtilities;

@property (nonatomic, strong) MGMCoreDataAccess *coreDataAccessMock;

@property (nonatomic, strong) MGMPopoutView *view;
@property (nonatomic, strong) MGMCoreDataTableViewDataSource *dataSource;

@end

@implementation MGMWeeklyChartModalViewTestCase

- (void)setUp
{
    [super setUp];

    self.mockModelUtilities = [[MGMMockModelUtilities alloc] initWithMockGenerator:self.mockContainer];

    self.coreDataAccessMock = [self.mockContainer mockObject:[MGMCoreDataAccess class]];

    NSString *initialDateString = @"15/05/2013";
    NSMutableArray *mockTimePeriods = [NSMutableArray array];
    for (int i = 1; i < 26; i++) {
        NSString *startDateString = [self dateStringFromDateString:initialDateString afterWeeks:i];
        NSString *endDateString = [self dateStringFromDateString:initialDateString afterWeeks:i + 1];
        [mockTimePeriods addObject:[self.mockModelUtilities mockTimePeriodWithStartDateString:startDateString
                                                                            endDateString:endDateString
                                                                       coreDataAccessMock:self.coreDataAccessMock]];
    }

    self.dataSource = [[MGMCoreDataTableViewDataSource alloc] initWithCellId:@"CellID"];
    [self.dataSource setRenderables:mockTimePeriods];
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
    Class viewClass = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? [MGMWeeklyChartModalViewPad class] : [MGMWeeklyChartModalViewPhone class];
    self.view = [[viewClass alloc] initWithFrame:frame];
    self.view.tableView.dataSource = self.dataSource;

    [self.view layoutIfNeeded];

    [self snapshotView:self.view];
}

@end
