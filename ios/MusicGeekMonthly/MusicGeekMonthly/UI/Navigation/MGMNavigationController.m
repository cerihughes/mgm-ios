//
//  MGMNavigationController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 07/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMNavigationController.h"

#import "MGMExampleAlbumViewController.h"
#import "MGMInitialLoadingViewController.h"
#import "MGMPlayerSelectionViewController.h"
#import "MGMTabBarController.h"

@interface MGMNavigationController () <MGMInitialLoadingViewControllerDelegate, MGMPlayerSelectionViewControllerDelegate>

@property (readonly) MGMUI* ui;

@property (readonly) MGMInitialLoadingViewController* loadingViewController;
@property (readonly) MGMTabBarController* tabBarController;

@property (readonly) MGMPlayerSelectionViewController* playerSelectionModalViewController;
@property (readonly) MGMExampleAlbumViewController* exampleAlbumModalViewController;

@end

@implementation MGMNavigationController
{
    BOOL _loadingViewControllerPushed;
    BOOL _tabBarControllerPushed;
    BOOL _shouldCheckPlayer;
    BOOL _shownExample;
}

- (id) initWithUI:(MGMUI*)ui
{
    if (self = [super init])
    {
        self.navigationBarHidden = YES;

        _ui = ui;

        _loadingViewController = [[MGMInitialLoadingViewController alloc] init];
        _loadingViewController.ui = ui;
        _loadingViewController.delegate = self;
        _tabBarController = [[MGMTabBarController alloc] initWithUI:ui];

        _playerSelectionModalViewController = [[MGMPlayerSelectionViewController alloc] init];
        _playerSelectionModalViewController.ui = ui;
        _playerSelectionModalViewController.delegate = self;

        _exampleAlbumModalViewController = [[MGMExampleAlbumViewController alloc] init];
        _exampleAlbumModalViewController.ui = ui;

        if (ui.ipad)
        {
            _playerSelectionModalViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            _exampleAlbumModalViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (_loadingViewControllerPushed == NO)
    {
        _loadingViewControllerPushed = YES;
        [self pushViewController:self.loadingViewController animated:NO];
    }
}

#pragma mark -
#pragma mark MGMInitialLoadingViewControllerDelegate

- (void) initialisationComplete
{
    if (_tabBarControllerPushed == NO)
    {
        _tabBarControllerPushed = YES;
        [self pushViewController:_tabBarController animated:YES];

        if (_shouldCheckPlayer)
        {
            _shouldCheckPlayer = NO;
            [self doCheckPlayer];
        }
    }
}

- (void) checkPlayer
{
    if (_tabBarControllerPushed == NO)
    {
        // Still initialising - check after initialisation is complete...
        _shouldCheckPlayer = YES;
    }
    else
    {
        [self doCheckPlayer];
    }
}

- (void) doCheckPlayer
{
    // Determine if a default player has been set...
    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;

    // Determine current capabilities...
    NSUInteger lastCapabilities = self.core.settingsDao.lastCapabilities;
    NSUInteger newCapabilities = [self.ui.albumPlayer determineCapabilities];
    self.core.settingsDao.lastCapabilities = newCapabilities;

    MGMPlayerSelectionMode playerSelectionMode = MGMPlayerSelectionModeNone;

    if (defaultServiceType == MGMAlbumServiceTypeNone)
    {
        // None set yet - 1st launch...
        playerSelectionMode = MGMPlayerSelectionModeNoPlayer;
    }
    else
    {
        // Check that the selected service type is still available...
        if (newCapabilities & defaultServiceType)
        {
            // Service type still available. Finally check for new service types...
            if (newCapabilities != lastCapabilities)
            {
                playerSelectionMode = MGMPlayerSelectionModeNewPlayers;
            }
        }
        else
        {
            // Service type no longer available.
            playerSelectionMode = MGMPlayerSelectionModePlayerRemoved;
        }
    }

    if (playerSelectionMode != MGMPlayerSelectionModeNone)
    {
        self.playerSelectionModalViewController.existingServiceType = defaultServiceType;
        self.playerSelectionModalViewController.mode = playerSelectionMode;
        [self presentViewController:self.playerSelectionModalViewController animated:YES completion:NULL];
    }
}

#pragma mark -
#pragma mark MGMPlayerSelectionViewControllerDelegate

- (void) playerSelectionChangedFrom:(MGMAlbumServiceType)oldSelection to:(MGMAlbumServiceType)newSelection
{
    if (oldSelection == MGMAlbumServiceTypeNone && _shownExample == NO)
    {
        // 1st run...
        _shownExample = YES;
        [self presentViewController:self.exampleAlbumModalViewController animated:YES completion:NULL];
    }
}


@end
