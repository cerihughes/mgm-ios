//
//  MGMWeeklyChartViewControllerTestCase.m
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
#import "MGMCore.h"
#import "MGMCoreDataAccess.h"
#import "MGMDao.h"
#import "MGMDaoData.h"
#import "MGMDefaultMockContainer.h"
#import "MGMImageHelper.h"
#import "MGMMockModelUtilities.h"
#import "MGMSnapshotTestCaseImageUtilities.h"
#import "MGMUI.h"
#import "MGMView.h"
#import "MGMWeeklyChartViewController.h"

@interface MGMWeeklyChartViewControllerTestCase : MGMSnapshotFullscreenDeviceTestCase

@property (nonatomic, strong) MGMMockModelUtilities *mockModelUtilities;

@property (nonatomic, strong) MGMUI *ui;
@property (nonatomic, strong) MGMCore *coreMock;
@property (nonatomic, strong) MGMCoreDataAccess *coreDataAccessMock;
@property (nonatomic, strong) MGMDao *daoMock;
@property (nonatomic, strong) MGMAlbumRenderService *albumRenderServiceMock;
@property (nonatomic, strong) MGMImageHelper *imageHelperMock;
@property (nonatomic, strong) MGMWeeklyChartViewController *viewController;

@end

@implementation MGMWeeklyChartViewControllerTestCase

- (void)setUp
{
    [super setUp];

    self.mockModelUtilities = [[MGMMockModelUtilities alloc] initWithMockGenerator:self.mockContainer];

    self.coreMock = [self.mockContainer mockObject:[MGMCore class]];
    self.coreDataAccessMock = [self.mockContainer mockObject:[MGMCoreDataAccess class]];
    self.daoMock = [self.mockContainer mockObject:[MGMDao class]];
    self.albumRenderServiceMock = [self.mockContainer mockObject:[MGMAlbumRenderService class]];
    self.imageHelperMock = [self.mockContainer mockObject:[MGMImageHelper class]];

    [MKTGiven([self.coreMock dao]) willReturn:self.daoMock];
    [MKTGiven([self.coreMock coreDataAccess]) willReturn:self.coreDataAccessMock];
    [MKTGiven([self.coreMock albumRenderService]) willReturn:self.albumRenderServiceMock];

    NSArray *mockMoids = @[];
    MGMDaoData *daoTimePeriodData = [[MGMDaoData alloc] init];
    daoTimePeriodData.data = mockMoids;

    [MKTGivenVoid([self.daoMock fetchAllTimePeriods:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        DAO_FETCH_COMPLETION completion = args[0];
        completion(daoTimePeriodData);
        return nil;
    }];

    NSMutableArray *mockTimePeriods = [NSMutableArray array];
    [mockTimePeriods addObject:[self.mockModelUtilities mockTimePeriodWithStartDateString:@"16/03/2015" endDateString:@"23/03/2015"]];
    [mockTimePeriods addObject:[self.mockModelUtilities mockTimePeriodWithStartDateString:@"23/03/2015" endDateString:@"30/03/2015"]];

    [MKTGiven([self.coreDataAccessMock mainThreadVersions:mockMoids]) willReturn:mockTimePeriods];

    NSManagedObjectID *mockMoid = [self.mockModelUtilities mockMoidForWeeklyChartWithStartDateString:@"16/03/2015"
                                                                                       endDateString:@"23/03/2015"
                                                                              fromCoreDataAccessMock:self.coreDataAccessMock];

    MGMDaoData *daoWeeklyChartData = [[MGMDaoData alloc] init];
    daoWeeklyChartData.data = mockMoid;

    [MKTGivenVoid([self.daoMock fetchWeeklyChartForStartDate:anything() endDate:anything() completion:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        DAO_FETCH_COMPLETION completion = args[2];
        completion(daoWeeklyChartData);
        return nil;
    }];

    [MGMSnapshotTestCaseImageUtilities setupAlbumRenderServiceMock:self.albumRenderServiceMock];
    [MGMSnapshotTestCaseImageUtilities setupImageHelperMock:self.imageHelperMock toReturnImageOfSize:256];

    self.ui = [[MGMUI alloc] initWithCore:self.coreMock albumPlayer:nil imageHelper:self.imageHelperMock];
    self.viewController = [[MGMWeeklyChartViewController alloc] init];
    self.viewController.ui = self.ui;
}

- (void)runTestInFrame:(CGRect)frame
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:frame];
    window.rootViewController = self.viewController;
    [window makeKeyAndVisible];

    [self.viewController.view layoutIfNeeded];

    [self snapshotView:self.viewController.view];
}

@end
