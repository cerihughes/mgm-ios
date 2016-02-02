//
//  MGMPlaylist.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 24/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface MGMPlaylist : NSManagedObject

@property (nonatomic, strong) NSString* playlistId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSOrderedSet* playlistItems;

@end
