//
//  MGMAlbumPlayer.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 02/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGMDaoFactory.h"
#import "MGMAlbum.h"

@class MGMUI;

@interface MGMAlbumPlayer : NSObject

@property (weak) MGMUI* ui;
@property (strong) MGMDaoFactory* daoFactory;

- (NSUInteger) determineCapabilities;

- (void) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)service completion:(VOID_COMPLETION)completion;

@end
