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

@interface MGMAlbumPlayer : NSObject

@property (strong) MGMDaoFactory* daoFactory;

- (void) playAlbum:(MGMAlbum*)album onService:(MGMAlbumServiceType)service;

@end
