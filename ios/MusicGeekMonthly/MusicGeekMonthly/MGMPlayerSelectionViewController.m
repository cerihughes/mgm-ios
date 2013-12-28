//
//  MGMPlayerSelectionViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlayerSelectionViewController.h"

#import "MGMAlbumServiceType.h"
#import "MGMPlayerSelectionView.h"

@interface MGMPlayerSelectionViewController () <MGMPlayerSelectionViewDelegate>

@end

@implementation MGMPlayerSelectionViewController

- (void) loadView
{
    MGMPlayerSelectionView* view = [[MGMPlayerSelectionView alloc] initWithFrame:[self fullscreenRect]];
    view.delegate = self;
    self.view = view;
}

- (void) viewDidAppear:(BOOL)animated
{
    MGMPlayerSelectionView* view = (MGMPlayerSelectionView*)self.view;
    [view clearAvailableServiceTypes];

    NSUInteger capabilities = [self.ui.albumPlayer determineCapabilities];
    MGMAlbumServiceType serviceType = MGMAlbumServiceTypeLastFm;
    while (serviceType <= MGMAlbumServiceTypeDeezer)
    {
        if (capabilities & serviceType)
        {
            NSString* label = [self.ui labelForServiceType:serviceType];
            UIImage* image = [self.ui imageForServiceType:serviceType];
            [view addAvailableServiceType:serviceType text:label image:image];
        }
        serviceType = serviceType << 1;
    }

    MGMAlbumServiceType defaultServiceType = self.core.daoFactory.settingsDao.defaultServiceType;
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
#pragma mark MGMPlayerSelectionViewDelegate

- (void) playerSelectionComplete
{
    MGMPlayerSelectionView* view = (MGMPlayerSelectionView*)self.view;
    self.core.daoFactory.settingsDao.defaultServiceType = view.selectedServiceType;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
