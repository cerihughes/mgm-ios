//
//  MGMWebsitePlayerService.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 15/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMAlbumPlayerService.h"

@interface MGMWebsitePlayerService : MGMAlbumPlayerService

- (id) init __unavailable;
- (id) initWithCoreDataAccess:(MGMCoreDataAccess*)coreDataAccess albumUrlPattern:(NSString*)albumUrlPattern searchUrlPattern:(NSString*)searchUrlPattern serviceType:(MGMAlbumServiceType)serviceType;

@end
