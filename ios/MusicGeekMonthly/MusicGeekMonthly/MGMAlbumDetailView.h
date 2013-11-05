//
//  MGMAlbumDetailView.h
//  MusicGeekMonthly
//
//  Created by Home on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMAlbumView.h"

@protocol MGMAlbumDetailViewDelegate <NSObject>

- (void) cancelButtonPressed:(id)sender;

@end

@interface MGMAlbumDetailView : MGMView

@property (weak) id<MGMAlbumDetailViewDelegate> delegate;

@property (readonly) MGMAlbumView* albumView;
@property (readonly) UITableView* tableView;

@end
