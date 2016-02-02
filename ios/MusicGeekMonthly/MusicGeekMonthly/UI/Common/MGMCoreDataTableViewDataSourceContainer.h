//
//  MGMCoreDataTableViewDataSourceContainer.h
//  MusicGeekMonthly
//
//  Created by Home on 12/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

@import Foundation;

@interface MGMCoreDataTableViewDataSourceSection : NSObject

@property (readonly) NSString* name;
@property (readonly) NSArray* data;

@end

@interface MGMCoreDataTableViewDataSourceContainer : NSObject

@property (readonly) NSArray* sections;

- (void) setRenderables:(NSArray*)renderables;

@end
