//
//  MGMAbstractPlayerSelectionView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/12/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractPlayerSelectionView.h"

#import "MGMPlayerGroupView.h"

@interface MGMAbstractPlayerSelectionView () <MGMPlayerGroupViewDelegate>

@end

@implementation MGMAbstractPlayerSelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _groupView = [[MGMPlayerGroupView alloc] initWithFrame:CGRectZero];
        _groupView.translatesAutoresizingMaskIntoConstraints = NO;
        _groupView.delegate = self;
    }
    return self;
}

- (void) setSelectedServiceType:(MGMAlbumServiceType)selectedServiceType
{
}

- (void) clearServiceTypes
{
    [self.groupView clearAll];
}

- (void) addServiceType:(MGMAlbumServiceType)serviceType text:(NSString*)text image:(UIImage*)image available:(BOOL)available
{
    [self.groupView addServiceType:serviceType withImage:image label:text available:available];
}

#pragma mark -
#pragma mark MGMPlayerGroupViewDelegate

- (void) serviceTypeSelected:(MGMAlbumServiceType)serviceType
{
    [self.delegate playerSelectionComplete:serviceType];
}

@end
