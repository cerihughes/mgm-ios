//
//  MGMHomeView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMAbstractEventView.h"

@interface MGMHomeView : MGMAbstractEventView

- (void) setNextEventDate:(NSDate *)nextEventDate;

- (NSUInteger) setBackgroundAlbumsInRow:(NSUInteger)albumsInRow;
- (void) renderBackgroundAlbumImage:(UIImage*)image atIndex:(NSUInteger)index animation:(BOOL)animation;

@end
