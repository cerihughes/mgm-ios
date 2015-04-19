//
//  MGMCoreDataTableViewDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MGMRenderable.h"
#import <UIKit/UIKit.h>

@interface MGMCoreDataTableViewDataSource : NSObject <UITableViewDataSource>

@property (readonly) NSString* cellId;
@property (readonly) CGFloat screenScale;

- (id) init __unavailable;
- (id) initWithCellId:(NSString*)cellId;

- (void) setRenderables:(NSArray*)renderables;
- (id<MGMRenderable>) objectAtIndexPath:(NSIndexPath*)indexPath;

@end
