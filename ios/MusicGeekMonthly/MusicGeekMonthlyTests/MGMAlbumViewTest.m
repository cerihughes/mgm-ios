//
//  MGMAlbumViewTest.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#import "MGMAlbumView.h"

@interface MGMAlbumDetailViewTest : MGMSnapshotTestCase

@end

@implementation MGMAlbumDetailViewTest

- (void)testAllValues
{
    MGMAlbumView *view = [[MGMAlbumView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    view.artistName = @"Artist Name 1";
    view.albumName = @"Album Name 1";
    view.rank = 5;
    view.listeners = 3;
    view.score = 4.5;
    [view renderImageWithNoAnimation:[self imageOfSize:160 withSeed:view.artistName]];

    FBSnapshotVerifyView(view, nil);
}

- (void)testArtistAndAlbum
{
    MGMAlbumView *view = [[MGMAlbumView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    view.artistName = @"Artist Name 2";
    view.albumName = @"Album Name 2";
    [view renderImageWithNoAnimation:[self imageOfSize:160 withSeed:view.artistName]];

    FBSnapshotVerifyView(view, nil);
}

- (void)testLongTitles
{
    MGMAlbumView *view = [[MGMAlbumView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    view.artistName = @"Another Very Very Long Artist Name";
    view.albumName = @"Another Very Very Long Album Name";
    [view renderImageWithNoAnimation:[self imageOfSize:160 withSeed:view.artistName]];

    FBSnapshotVerifyView(view, nil);
}

- (void)testArtistAndAlbumWithListeners
{
    MGMAlbumView *view = [[MGMAlbumView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    view.artistName = @"Artist Name 3";
    view.albumName = @"Album Name 3";
    view.listeners = 1;
    [view renderImageWithNoAnimation:[self imageOfSize:160 withSeed:view.artistName]];

    FBSnapshotVerifyView(view, nil);
}

- (void)testArtistAndAlbumWithRank
{
    MGMAlbumView *view = [[MGMAlbumView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    view.artistName = @"Artist Name 4";
    view.albumName = @"Album Name 4";
    view.rank = 5;
    [view renderImageWithNoAnimation:[self imageOfSize:160 withSeed:view.artistName]];

    FBSnapshotVerifyView(view, nil);
}

- (void)testArtistAndAlbumWithRankAndScore
{
    MGMAlbumView *view = [[MGMAlbumView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    view.artistName = @"Artist Name 5";
    view.albumName = @"Album Name 5";
    view.rank = 5;
    view.score = 9.9;
    [view renderImageWithNoAnimation:[self imageOfSize:160 withSeed:view.artistName]];

    FBSnapshotVerifyView(view, nil);
}

@end
