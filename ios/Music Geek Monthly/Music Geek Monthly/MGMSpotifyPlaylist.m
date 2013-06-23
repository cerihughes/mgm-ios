//
//  MGMSpotifyPlaylist.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMSpotifyPlaylist.h"

@implementation MGMSpotifyPlaylist

+ (MGMSpotifyPlaylist*) playlistWithEventNumber:(NSUInteger)eventNumber eventDate:(NSDate*)eventDate spotifyUrl:(NSString*)spotifyUrl httpUrl:(NSString*)httpUrl
{
    return [[MGMSpotifyPlaylist alloc] initWithEventNumber:eventNumber eventDate:eventDate spotifyUrl:spotifyUrl httpUrl:httpUrl];
}

- (id) initWithEventNumber:(NSUInteger)eventNumber eventDate:(NSDate*)eventDate spotifyUrl:(NSString*)spotifyUrl httpUrl:(NSString*)httpUrl
{
    if (self = [super init])
    {
        self.eventNumber = eventNumber;
        self.eventDate = eventDate;
        self.spotifyUrl = spotifyUrl;
        self.httpUrl = httpUrl;
    }
    return self;
}

@end
