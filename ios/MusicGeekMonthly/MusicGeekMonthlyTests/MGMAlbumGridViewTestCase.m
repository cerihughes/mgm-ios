//
//  MGMAlbumGridViewTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#import "MGMAlbumGridView.h"
#import "MGMAlbumView.h"

@interface MGMAlbumGridViewTestCase : MGMSnapshotTestCase

@end

@implementation MGMAlbumGridViewTestCase

- (NSArray *)albumFrames
{
    return @[
             @[@0, @0, @80, @80],
             @[@80, @0, @80, @80],
             @[@0, @80, @80, @80],
             @[@80, @80, @80, @80],
             @[@160, @0, @160, @160],
             @[@0, @160, @160, @160],
             @[@160, @160, @80, @80],
             @[@240, @160, @80, @80],
             @[@160, @240, @80, @80],
             @[@240, @240, @80, @80],
             ];
}

- (void)testAllValues
{
    MGMAlbumGridView *view = [[MGMAlbumGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [view setAlbumCount:10 detailViewShowing:YES];

    int rank = 1;
    for (NSArray *frame in [self albumFrames]) {
        NSNumber *x = frame[0];
        NSNumber *y = frame[1];
        NSNumber *w = frame[2];
        NSNumber *h = frame[3];
        CGRect frame = CGRectMake(x.floatValue, y.floatValue, w.floatValue, h.floatValue);
        [view setAlbumFrame:frame forRank:rank++];
    }

    for (rank = 1; rank < 11; rank++) {
        MGMAlbumView *albumView = [view albumViewForRank:rank];
        albumView.artistName = [NSString stringWithFormat:@"ARTIST %d", rank];
        albumView.albumName = [NSString stringWithFormat:@"ALBUM %d", rank];
        albumView.rank = rank;
        albumView.score = 11 - rank;
        albumView.listeners = albumView.score * 2;
        [albumView renderImageWithNoAnimation:[self imageOfSize:160 withSeed:albumView.artistName]];
    }

    FBSnapshotVerifyView(view, nil);
}

@end
