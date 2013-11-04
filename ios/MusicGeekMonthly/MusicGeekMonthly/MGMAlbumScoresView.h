//
//  MGMAlbumScoresView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 04/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMWeeklyChartAlbumsView.h"

typedef enum
{
    MGMAlbumScoresViewSelectionClassicAlbums,
    MGMAlbumScoresViewSelectionNewAlbums,
    MGMAlbumScoresViewSelectionAllAlbums
}
MGMAlbumScoresViewSelection;

@protocol MGMAlbumScoresViewDelegate <NSObject>

- (void) selectionChanged:(MGMAlbumScoresViewSelection)selection;

@end

@interface MGMAlbumScoresView : MGMView

@property (weak) id<MGMAlbumScoresViewDelegate> delegate;

@property (readonly) MGMWeeklyChartAlbumsView* albumsView;

- (void) setSelection:(MGMAlbumScoresViewSelection)selection;

@end
