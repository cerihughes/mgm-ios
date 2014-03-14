//
//  MGMBackgroundAlbumArtCollection.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMBackgroundAlbumArtCollection : NSObject

@property (readonly) NSArray* albumArtUrlArrays;

- (void) addAlbumArtUrlArray:(NSArray*)albumArtUrls;

@end
