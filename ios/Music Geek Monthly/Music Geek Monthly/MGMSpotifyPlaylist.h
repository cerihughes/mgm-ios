//
//  MGMSpotifyPlaylist.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMSpotifyPlaylist : NSObject

@property NSUInteger eventNumber;
@property (strong) NSDate* eventDate;
@property (strong) NSString* spotifyUrl;
@property (strong) NSString* httpUrl;

+ (MGMSpotifyPlaylist*) playlistWithEventNumber:(NSUInteger)eventNumber eventDate:(NSDate*)eventDate spotifyUrl:(NSString*)spotiftUrl httpUrl:(NSString*)spotifyUrl;
- (id) initWithEventNumber:(NSUInteger)eventNumber eventDate:(NSDate*)eventDate spotifyUrl:(NSString*)spotiftUrl httpUrl:(NSString*)spotifyUrl;

@end
