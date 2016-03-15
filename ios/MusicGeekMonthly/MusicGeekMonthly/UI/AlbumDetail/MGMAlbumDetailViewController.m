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
#import "MGMModalView.h"
#import "MGMSettingsDao.h"
#import "MGMUI.h"
#import "UIViewController+MGMAdditions.h"

#define CELL_ID @"ALBUM_DETAIL_CELL_ID"

@interface MGMKeyValuePair : NSObject

@property (nonatomic) MGMAlbumServiceType serviceType;
@property (nonatomic, copy) NSString *displayString;

@end

@implementation MGMKeyValuePair

@end

@interface MGMAlbumDetailViewController () <MGMAbstractPlayerSelectionViewDelegate, MGMModalViewDelegate>

@property (nonatomic, weak) MGMAlbumDetailView *albumDetailView;

@end

@implementation MGMAlbumDetailViewController

- (void) loadView
{
    CGRect frame = [self fullscreenRect];

    Class viewClass = mgm_isIpad() ? [MGMAlbumDetailViewPad class] : [MGMAlbumDetailViewPhone class];
    MGMAlbumDetailView* view = [[viewClass alloc] initWithFrame:frame];
    view.delegate = self;

    MGMModalView *modalView = mgm_isIpad() ?
        [[MGMModalViewPad alloc] initWithFrame:frame buttonTitle:@"Cancel"] :
        [[MGMModalViewPhone alloc] initWithFrame:frame navigationTitle:@"Album Detail" buttonTitle:@"Cancel"];

    [modalView.contentView addSubview:view];
    modalView.delegate = self;

    self.view = modalView;
    self.albumDetailView = view;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MGMAlbum* album = [self.core.coreDataAccess mainThreadVersion:self.albumMoid];
    [self displayAlbum:album inAlbumView:self.albumDetailView.albumView completion:^(NSError* error) {
        [self logError:error];
    }];

    [self.albumDetailView clearServiceTypes];

    NSUInteger metadataServiceTypes = [self.core.serviceManager serviceTypesThatPlayAlbum:album];
    NSUInteger deviceCapabilities = [self.ui.albumPlayer determineCapabilities];
    MGMAlbumServiceType serviceType = MGMAlbumServiceTypeLastFm;
    while (serviceType <= MGMAlbumServiceTypeDeezer)
    {
        NSString* label = [self.ui labelForServiceType:serviceType];
        UIImage* image = [self.ui imageForServiceType:serviceType];
        [self.albumDetailView addServiceType:serviceType text:label image:image available:(metadataServiceTypes & deviceCapabilities & serviceType)];
        serviceType = serviceType << 1;
    }

    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;
    self.albumDetailView.selectedServiceType = defaultServiceType;
}

#pragma mark - MGMAbstractPlayerSelectionViewDelegate

- (void)playerSelectionComplete:(MGMAlbumServiceType)selectedServiceType
{
    self.core.settingsDao.defaultServiceType = selectedServiceType;

    MGMAlbum* album = [self.core.coreDataAccess mainThreadVersion:self.albumMoid];
    [self.ui albumSelected:album];
    [self modalButtonPressed];
}

#pragma mark - MGMModelViewDelegate

- (void)modalButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
