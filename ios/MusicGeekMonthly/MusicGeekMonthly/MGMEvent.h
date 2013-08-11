//
//  MGMEvent.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MGMAlbum.h"

@interface MGMEvent : NSManagedObject

@property (nonatomic, retain) NSDate* eventDate;
@property (nonatomic, retain) NSNumber* eventNumber;
@property (nonatomic, retain) NSString* spotifyPlaylistId;
@property (nonatomic, retain) MGMAlbum* classicAlbum;
@property (nonatomic, retain) MGMAlbum* newlyReleasedAlbum;

- (NSString*) spotifyPlaylistUrl;
- (NSString*) spotifyHttpUrl;

@end
