//
//  MGMExampleAlbumView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 31/01/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMAlbumView.h"

@protocol MGMExampleAlbumViewDelegate <NSObject>

- (void) gotIt;

@end

@interface MGMExampleAlbumView : MGMView

@property (weak) id<MGMExampleAlbumViewDelegate> delegate;

@property (readonly) MGMAlbumView* albumView;

@end
