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
#import "MGMModalView.h"
#import "MGMPlayerSelectionView.h"
#import "MGMSettingsDao.h"
#import "MGMUI.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMPlayerSelectionViewController () <MGMAbstractPlayerSelectionViewDelegate, MGMModalViewDelegate>

@property (nonatomic, weak) MGMPlayerSelectionView *playerSelectionView;

@end

@implementation MGMPlayerSelectionViewController

- (void) loadView
{
    CGRect frame = [self fullscreenRect];

    Class viewClass = mgm_isIpad() ? [MGMPlayerSelectionViewPad class] : [MGMPlayerSelectionViewPhone class];
    MGMPlayerSelectionView* view = [[viewClass alloc] initWithFrame:frame];
    view.delegate = self;

    MGMModalView *modalView = mgm_isIpad() ?
        [[MGMModalViewPad alloc] initWithFrame:frame buttonTitle:@"Close"] :
        [[MGMModalViewPhone alloc] initWithFrame:frame navigationTitle:@"Player Selection" buttonTitle:@"Close"];

    [modalView.contentView addSubview:view];
    modalView.delegate = self;

    self.view = modalView;
    self.playerSelectionView = view;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.playerSelectionView clearServiceTypes];

    NSUInteger capabilities = [self.ui.albumPlayer determineCapabilities];
    MGMAlbumServiceType serviceType = MGMAlbumServiceTypeLastFm;
    while (serviceType <= MGMAlbumServiceTypeDeezer)
    {
        NSString* label = [self.ui labelForServiceType:serviceType];
        UIImage* image = [self.ui imageForServiceType:serviceType];
        [self.playerSelectionView addServiceType:serviceType text:label image:image available:(capabilities & serviceType)];
        serviceType = serviceType << 1;
    }

    MGMAlbumServiceType defaultServiceType = self.core.settingsDao.defaultServiceType;
    self.playerSelectionView.selectedServiceType = defaultServiceType;
}

- (MGMPlayerSelectionMode) mode
{
    return self.playerSelectionView.mode;
}

- (void) setMode:(MGMPlayerSelectionMode)mode
{
    self.playerSelectionView.mode = mode;
}

#pragma mark - MGMAbstractPlayerSelectionViewDelegate

- (void)playerSelectionComplete:(MGMAlbumServiceType)selectedServiceType
{
    self.core.settingsDao.defaultServiceType = selectedServiceType;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [self.delegate playerSelectionChangedFrom:self.existingServiceType to:selectedServiceType];
    }];
}

#pragma mark - MGMModalViewDelegate

- (void)modalButtonPressed
{
    [self playerSelectionComplete:(MGMAlbumServiceTypeNone)];
}

@end
