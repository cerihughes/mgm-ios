//
//  MGMAlbumDetailViewController.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 25/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumDetailViewController.h"

#import "MGMAlbum.h"
#import "MGMAlbumDetailView.h"
#import "MGMAlbumPlayer.h"
#import "MGMAlbumServiceManager.h"
#import "MGMCore.h"
#import "MGMCoreDataAccess.h"
#import "MGMSettingsDao.h"
#import "MGMUI.h"
#import "UIViewController+MGMAdditions.h"

#define CELL_ID @"ALBUM_DETAIL_CELL_ID"

@interface MGMKeyValuePair : NSObject

@property MGMAlbumServiceType serviceType;
@property (copy) NSString* displayString;

@end

@implementation MGMKeyValuePair

@end

@interface MGMAlbumDetailViewController () <MGMAlbumDetailViewDelegate>

@end

@implementation MGMAlbumDetailViewController

- (void) loadView
{
    Class viewClass = mgm_isIpad() ? [MGMAlbumDetailViewPad class] : [MGMAlbumDetailViewPhone class];
    MGMAlbumDetailView* detailView = [[viewClass alloc] initWithFrame:[self fullscreenRect]];
    detailView.delegate = self;

    self.view = detailView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MGMAlbumDetailView* detailView = (MGMAlbumDetailView*)self.view;

    MGMAlbum* album = [self.core.coreDataAccess mainThreadVersion:self.albumMoid];
    [self displayAlbum:album inAlbumView:detailView.albumView completion:^(NSError* error) {
        [self logError:error];
    }];

    [detailView clearServiceTypes];

    NSUInteger metadataServiceTypes = [self.core.serviceManager serviceTypesThatPlayAlbum:album];
    NSUInteger deviceCapabilities = [self.ui.albumPlayer determineCapabilities];
    MGMAlbumServiceType serviceType = MGMAlbumServiceTypeLastFm;
    while (serviceType <= MGMAlbumServiceTypeDeezer)
    {
        NSString* label = [self.ui labelForServiceType:serviceType];
        UIImage* image = [self.ui imageForServiceType:serviceType];
        [detailView addServiceType:serviceType text:label image:image available:(metadataServiceTypes & deviceCapabilities & serviceType)];
        serviceType = serviceType << 1;
    }

    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;
    detailView.selectedServiceType = defaultServiceType;
}

#pragma mark -
#pragma mark MGMAlbumDetailViewDelegate

- (void) playerSelectionComplete:(MGMAlbumServiceType)selectedServiceType
{
    self.core.settingsDao.defaultServiceType = selectedServiceType;

    MGMAlbum* album = [self.core.coreDataAccess mainThreadVersion:self.albumMoid];
    [self.ui albumSelected:album];
    [self cancelButtonPressed:nil];
}

- (void) cancelButtonPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
