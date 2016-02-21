//
//  MGMEventsViewControllerTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "MGMAlbum.h"
#import "MGMAlbumRenderService.h"
#import "MGMCore.h"
#import "MGMCoreDataAccess.h"
#import "MGMDao.h"
#import "MGMDaoData.h"
#import "MGMDefaultMockContainer.h"
#import "MGMEvent.h"
#import "MGMEventsViewController.h"
#import "MGMImageHelper.h"
#import "MGMMockModelUtilities.h"
#import "MGMSnapshotTestCaseImageUtilities.h"
#import "MGMUI.h"
#import "MGMView.h"

@interface MGMEventsViewControllerTestCase : MGMSnapshotFullscreenDeviceTestCase

@property (nonatomic, strong) MGMMockModelUtilities *mockModelUtilities;

@property (nonatomic, strong) MGMUI *ui;
@property (nonatomic, strong) MGMCore *coreMock;
@property (nonatomic, strong) MGMCoreDataAccess *coreDataAccessMock;
@property (nonatomic, strong) MGMDao *daoMock;
@property (nonatomic, strong) MGMAlbumRenderService *albumRenderServiceMock;
@property (nonatomic, strong) MGMImageHelper *imageHelperMock;
@property (nonatomic, strong) MGMEventsViewController *viewController;

@end

@implementation MGMEventsViewControllerTestCase

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
    MGMDaoData *daoEventData = [[MGMDaoData alloc] init];
    daoEventData.data = mockMoids;

    [MKTGivenVoid([self.daoMock fetchAllEvents:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        DAO_FETCH_COMPLETION completion = args[0];
        completion(daoEventData);
        return nil;
    }];

    NSMutableArray *mockEvents = [NSMutableArray array];
    [mockEvents addObject:[self.mockModelUtilities mockEventWithEventNumber:1
                                                            eventDateString:@"15/01/2016"
                                                                 playlistId:@"ID1"
                                                          classicArtistName:@"Stevie Wonder"
                                                           classicAlbumName:@"Songs In The Key Of Life"
                                                          classicAlbumScore:7.9
                                                    newlyReleasedArtistName:@"Julia Holter"
                                                     newlyReleasedAlbumName:@"Have You In My Wilderness"
                                                    newlyReleasedAlbumScore:8.2]];

    [mockEvents addObject:[self.mockModelUtilities mockEventWithEventNumber:2
                                                            eventDateString:@"15/02/2016"
                                                                 playlistId:@"ID2"
                                                          classicArtistName:@"Nirvana"
                                                           classicAlbumName:@"Nevermind"
                                                          classicAlbumScore:8.1
                                                    newlyReleasedArtistName:@"Tame Impala"
                                                     newlyReleasedAlbumName:@"Currents"
                                                    newlyReleasedAlbumScore:7.2]];
    [MKTGiven([self.coreDataAccessMock mainThreadVersions:mockMoids]) willReturn:mockEvents];

    NSManagedObjectID *mockMoid = [self.mockModelUtilities mockMoidForPlaylistWithPlaylistId:@"ID1"
                                                                                        name:@"Playlist 1"
                                                                      fromCoreDataAccessMock:self.coreDataAccessMock];

    MGMDaoData *daoPlaylistData = [[MGMDaoData alloc] init];
    daoPlaylistData.data = mockMoid;

    [MKTGivenVoid([self.daoMock fetchPlaylist:@"ID1" completion:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        DAO_FETCH_COMPLETION completion = args[1];
        completion(daoPlaylistData);
        return nil;
    }];

    [MGMSnapshotTestCaseImageUtilities setupAlbumRenderServiceMock:self.albumRenderServiceMock];
    [MGMSnapshotTestCaseImageUtilities setupImageHelperMock:self.imageHelperMock toReturnImageOfSize:256];

    self.ui = [[MGMUI alloc] initWithCore:self.coreMock albumPlayer:nil imageHelper:self.imageHelperMock];
    self.viewController = [[MGMEventsViewController alloc] init];
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
