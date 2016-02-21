//
//  MGMPlayerSelectionViewControllerTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>

#import "MGMAlbumPlayer.h"
#import "MGMCore.h"
#import "MGMDefaultMockContainer.h"
#import "MGMPlayerSelectionViewController.h"
#import "MGMSettingsDao.h"
#import "MGMUI.h"

@interface MGMPlayerSelectionViewControllerTestCase : MGMSnapshotFullscreenDeviceTestCase

@property (nonatomic, strong) MGMUI *ui;
@property (nonatomic, strong) MGMCore *coreMock;
@property (nonatomic, strong) MGMAlbumPlayer *albumPlayerMock;
@property (nonatomic, strong) MGMSettingsDao *settingsDaoMock;
@property (nonatomic, strong) MGMPlayerSelectionViewController *viewController;

@end

@implementation MGMPlayerSelectionViewControllerTestCase

- (void)setUp
{
    [super setUp];

    self.coreMock = [self.mockContainer mockObject:[MGMCore class]];
    self.albumPlayerMock = [self.mockContainer mockObject:[MGMAlbumPlayer class]];
    self.settingsDaoMock = [self.mockContainer mockObject:[MGMSettingsDao class]];

    [MKTGiven([self.coreMock settingsDao]) willReturn:self.settingsDaoMock];

    [MKTGiven([self.albumPlayerMock determineCapabilities]) willReturn:@(MGMAlbumServiceTypeLastFm | MGMAlbumServiceTypeSpotify | MGMAlbumServiceTypeWikipedia)];
    [MKTGiven([self.settingsDaoMock defaultServiceType]) willReturn:@(MGMAlbumServiceTypeNone)];

    self.ui = [[MGMUI alloc] initWithCore:self.coreMock albumPlayer:self.albumPlayerMock imageHelper:nil];
    self.viewController = [[MGMPlayerSelectionViewController alloc] init];
    self.viewController.ui = self.ui;
}

- (void)runTestInFrame:(CGRect)frame
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:frame];
    window.rootViewController = self.viewController;
    [window makeKeyAndVisible];

    self.viewController.mode = MGMPlayerSelectionModeNoPlayer;
    [self.viewController.view layoutIfNeeded];

    [self snapshotView:self.viewController.view];
}

@end
