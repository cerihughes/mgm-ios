//
//  MGMInitialLoadingViewController.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 16/09/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMViewController.h"

@import Foundation;

@class MGMBackgroundAlbumArtCollection;

@protocol MGMInitialLoadingViewControllerDelegate <NSObject>

- (void) initialisationComplete:(MGMBackgroundAlbumArtCollection*)albumArtCollection;

@end

@interface MGMInitialLoadingViewController : MGMViewController

@property (weak) id<MGMInitialLoadingViewControllerDelegate> delegate;

@end
