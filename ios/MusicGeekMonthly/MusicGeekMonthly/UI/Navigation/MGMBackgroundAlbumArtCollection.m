//
//  MGMBackgroundAlbumArtCollection.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMBackgroundAlbumArtCollection.h"

@interface MGMBackgroundAlbumArtCollection ()

@property (readonly) NSMutableArray* mutableArray;

@end

@implementation MGMBackgroundAlbumArtCollection

- (id) init
{
    if (self = [super init])
    {
        _mutableArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray*) albumArtUrlArrays
{
    return [self.mutableArray copy];
}

- (void) addAlbumArtUrlArray:(NSArray*)albumArtUrls
{
    [self.mutableArray addObject:albumArtUrls];
}

@end
