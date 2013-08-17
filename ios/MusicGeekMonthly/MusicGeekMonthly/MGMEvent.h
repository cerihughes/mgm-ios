//
//  MGMEvent.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGMAlbum.h"
#import "MGMCompletion.h"

@interface MGMEvent : NSManagedObject

@property (nonatomic, strong) NSDate* eventDate;
@property (nonatomic, strong) NSNumber* eventNumber;
@property (nonatomic, strong) NSString* spotifyPlaylistId;

- (MGMAlbum*) fetchClassicAlbum;
- (MGMAlbum*) fetchNewlyReleasedAlbum;

- (NSString*) spotifyPlaylistUrl;
- (NSString*) spotifyHttpUrl;

@end
