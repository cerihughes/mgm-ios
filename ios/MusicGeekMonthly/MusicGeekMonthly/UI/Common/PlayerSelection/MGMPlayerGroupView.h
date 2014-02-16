//
//  MGMPlayerGroupView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/12/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

#import "MGMAlbumServiceType.h"

@protocol MGMPlayerGroupViewDelegate <NSObject>

- (void) serviceTypeSelected:(MGMAlbumServiceType)serviceType;

@end

@interface MGMPlayerGroupView : MGMView

@property (weak) id<MGMPlayerGroupViewDelegate> delegate;

- (void) clearAll;
- (void) addServiceType:(MGMAlbumServiceType)serviceType withImage:(UIImage*)image label:(NSString*)label available:(BOOL)available;

@end
