//
//  MGMPulsatingAlbumsView.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@interface MGMPulsatingAlbumsView : MGMView

- (void) setupAlbumsInRow:(NSUInteger)albumsInRow;
- (void) renderImages:(NSArray*)images;

@end
