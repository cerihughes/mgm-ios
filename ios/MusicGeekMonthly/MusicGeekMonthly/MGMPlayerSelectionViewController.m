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

@interface MGMPlayerSelectionViewController () <MGMAbstractPlayerSelectionViewDelegate>

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
#pragma mark MGMAbstractPlayerSelectionViewDelegate

- (void) playerSelectionComplete:(MGMAlbumServiceType)selectedServiceType
{
    if (selectedServiceType != MGMAlbumServiceTypeNone)
    {
        self.core.daoFactory.settingsDao.defaultServiceType = selectedServiceType;
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self.delegate playerSelectionChangedFrom:self.existingServiceType to:selectedServiceType];
        }];
    }
}

@end
