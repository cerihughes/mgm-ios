//
//  MGMCoreDataTableViewDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import Foundation;
@import UIKit;

@protocol MGMRenderable;

@interface MGMCoreDataTableViewDataSource : NSObject <UITableViewDataSource>

@property (readonly) NSString* cellId;
@property (readonly) CGFloat screenScale;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCellId:(NSString *)cellId;

- (void) setRenderables:(NSArray*)renderables;
- (id<MGMRenderable>) objectAtIndexPath:(NSIndexPath*)indexPath;

@end
