//
//  MGMPlayerSelectionViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlayerSelectionViewController.h"

#import "MGMAlbumPlayer.h"
#import "MGMAlbumServiceType.h"
#import "MGMCore.h"
#import "MGMPlayerSelectionView.h"
#import "MGMSettingsDao.h"
#import "MGMUI.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMPlayerSelectionViewController () <MGMAbstractPlayerSelectionViewDelegate>

@end

@implementation MGMPlayerSelectionViewController

- (void) loadView
{
    Class viewClass = mgm_isIpad() ? [MGMPlayerSelectionViewPad class] : [MGMPlayerSelectionViewPhone class];
    MGMPlayerSelectionView* view = [[viewClass alloc] initWithFrame:[self fullscreenRect]];
    view.delegate = self;
    self.view = view;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MGMPlayerSelectionView* view = (MGMPlayerSelectionView*)self.view;
    [view clearServiceTypes];

    NSUInteger capabilities = [self.ui.albumPlayer determineCapabilities];
    MGMAlbumServiceType serviceType = MGMAlbumServiceTypeLastFm;
    while (serviceType <= MGMAlbumServiceTypeDeezer)
    {
        NSString* label = [self.ui labelForServiceType:serviceType];
        UIImage* image = [self.ui imageForServiceType:serviceType];
        [view addServiceType:serviceType text:label image:image available:(capabilities & serviceType)];
        serviceType = serviceType << 1;
    }

    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;
    view.selectedServiceType = defaultServiceType;
}

- (MGMPlayerSelectionMode) mode
{
    MGMPlayerSelectionView* view = (MGMPlayerSelectionView*)self.view;
    return view.mode;
}

- (void) setMode:(MGMPlayerSelectionMode)mode
{
    MGMPlayerSelectionView* view = (MGMPlayerSelectionView*)self.view;
    view.mode = mode;
}

#pragma mark -
#pragma mark MGMAbstractPlayerSelectionViewDelegate

- (void) playerSelectionComplete:(MGMAlbumServiceType)selectedServiceType
{
    self.core.settingsDao.defaultServiceType = selectedServiceType;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self.delegate playerSelectionChangedFrom:self.existingServiceType to:selectedServiceType];
    }];
}

@end
