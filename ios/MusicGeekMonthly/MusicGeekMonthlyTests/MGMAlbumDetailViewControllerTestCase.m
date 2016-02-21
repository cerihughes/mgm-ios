//
//  MGMAlbumDetailViewControllerTestCase.m
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
#import "MGMAlbumDetailViewController.h"
#import "MGMAlbumPlayer.h"
#import "MGMAlbumRenderService.h"
#import "MGMAlbumServiceManager.h"
#import "MGMCore.h"
#import "MGMCoreDataAccess.h"
#import "MGMDefaultMockContainer.h"
#import "MGMImageHelper.h"
#import "MGMSettingsDao.h"
#import "MGMSnapshotTestCaseImageUtilities.h"
#import "MGMUI.h"

@interface MGMAlbumDetailViewControllerTestCase : MGMSnapshotFullscreenDeviceTestCase

@property (nonatomic, strong) MGMUI *ui;
@property (nonatomic, strong) MGMCore *coreMock;
@property (nonatomic, strong) MGMCoreDataAccess *coreDataAccessMock;
@property (nonatomic, strong) MGMAlbumRenderService *albumRenderServiceMock;
@property (nonatomic, strong) MGMImageHelper *imageHelperMock;
@property (nonatomic, strong) MGMAlbumPlayer *albumPlayerMock;
@property (nonatomic, strong) MGMSettingsDao *settingsDaoMock;
@property (nonatomic, strong) MGMAlbumServiceManager *albumServiceManagerMock;
@property (nonatomic, strong) MGMAlbumDetailViewController *viewController;

@end

@implementation MGMAlbumDetailViewControllerTestCase

- (void)setUp
{
    [super setUp];

    self.coreMock = [self.mockContainer mockObject:[MGMCore class]];
    self.coreDataAccessMock = [self.mockContainer mockObject:[MGMCoreDataAccess class]];
    self.albumPlayerMock = [self.mockContainer mockObject:[MGMAlbumPlayer class]];
    self.settingsDaoMock = [self.mockContainer mockObject:[MGMSettingsDao class]];
    self.albumRenderServiceMock = [self.mockContainer mockObject:[MGMAlbumRenderService class]];
    self.imageHelperMock = [self.mockContainer mockObject:[MGMImageHelper class]];
    self.albumServiceManagerMock = [self.mockContainer mockObject:[MGMAlbumServiceManager class]];

    [MKTGiven([self.coreMock coreDataAccess]) willReturn:self.coreDataAccessMock];
    [MKTGiven([self.coreMock settingsDao]) willReturn:self.settingsDaoMock];
    [MKTGiven([self.coreMock albumRenderService]) willReturn:self.albumRenderServiceMock];
    [MKTGiven([self.coreMock serviceManager]) willReturn:self.albumServiceManagerMock];

    [MKTGiven([self.albumPlayerMock determineCapabilities]) willReturn:@(MGMAlbumServiceTypeLastFm | MGMAlbumServiceTypeSpotify | MGMAlbumServiceTypeWikipedia)];
    [MKTGiven([self.settingsDaoMock defaultServiceType]) willReturn:@(MGMAlbumServiceTypeNone)];

    [MGMSnapshotTestCaseImageUtilities setupAlbumRenderServiceMock:self.albumRenderServiceMock];
    [MGMSnapshotTestCaseImageUtilities setupImageHelperMock:self.imageHelperMock toReturnImageOfSize:256];

    self.ui = [[MGMUI alloc] initWithCore:self.coreMock albumPlayer:self.albumPlayerMock imageHelper:self.imageHelperMock];
    self.viewController = [[MGMAlbumDetailViewController alloc] init];
    self.viewController.ui = self.ui;
}

- (void)runTestInFrame:(CGRect)frame
{
    MGMAlbum *album = [self.mockContainer mockObject:[MGMAlbum class]];
    [MKTGiven([album artistName]) willReturn:@"Detail Artist"];
    [MKTGiven([album albumName]) willReturn:@"Detail Album"];
    [MKTGiven([album score]) willReturn:@(5.6)];
    [[MKTGiven([album bestImageUrlsWithPreferredSize:0]) withMatcher:anything()] willReturn:@[@"Image Url"]];

    NSManagedObjectID *moid = [self.mockContainer mockObject:[NSManagedObjectID class]];
    [MKTGiven([self.coreDataAccessMock mainThreadVersion:moid]) willReturn:album];
    self.viewController.albumMoid = moid;

    [MKTGiven([self.albumServiceManagerMock serviceTypesThatPlayAlbum:album]) willReturn:@(MGMAlbumServiceTypeSpotify | MGMAlbumServiceTypeItunes)];

    UIWindow *window = [[UIWindow alloc] initWithFrame:frame];
    window.rootViewController = self.viewController;
    [window makeKeyAndVisible];

    [self snapshotView:self.viewController.view];
}

@end
