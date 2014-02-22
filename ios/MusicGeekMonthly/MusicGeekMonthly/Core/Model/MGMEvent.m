//
//  MGMEvent.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEvent.h"

@implementation MGMEvent

@dynamic eventDate;
@dynamic eventNumber;
@dynamic spotifyPlaylistId;
@dynamic classicAlbum;
@dynamic newlyReleasedAlbum;

static NSDateFormatter* groupHeaderFormatter;
static NSDateFormatter* groupItemFormatter;

+ (void)initialize
{
    // yyyy
    groupHeaderFormatter = [[NSDateFormatter alloc] init];
    groupHeaderFormatter.dateFormat = @"yyyy";

    // MMM yyyy
    groupItemFormatter = [[NSDateFormatter alloc] init];
    groupItemFormatter.dateFormat = @"MMM yyyy";
}

- (NSString*) groupHeader
{
    [self willAccessValueForKey:@"groupHeader"];
    NSString* header = [groupHeaderFormatter stringFromDate:self.eventDate];
    [self didAccessValueForKey:@"groupHeader"];
    return header;
}

- (NSString*) groupValue
{
    [self willAccessValueForKey:@"groupValue"];
    NSString* value = [groupItemFormatter stringFromDate:self.eventDate];
    [self didAccessValueForKey:@"groupValue"];
    return value;
}

@end
