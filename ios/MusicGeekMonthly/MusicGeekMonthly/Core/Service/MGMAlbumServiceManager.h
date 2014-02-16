//
//  MGMAlbumServiceManager.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMAlbum.h"
#import "MGMCoreDataAccess.h"

@interface MGMAlbumServiceManager : NSObject

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess;

- (NSUInteger) serviceTypesThatPlayAlbum:(MGMAlbum*)album;
- (NSString*) serviceAvailabilityUrlForServiceType:(MGMAlbumServiceType)serviceType;
- (NSString*) urlForAlbum:(MGMAlbum*)album forServiceType:(MGMAlbumServiceType)serviceType;
- (BOOL) refreshAlbumMetadata:(MGMAlbum*)album forServiceType:(MGMAlbumServiceType)serviceType error:(NSError**)error;

@end
