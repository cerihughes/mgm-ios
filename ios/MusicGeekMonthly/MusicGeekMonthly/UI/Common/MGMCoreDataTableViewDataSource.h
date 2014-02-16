//
//  MGMCoreDataTableViewDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface MGMCoreDataTableViewDataSource : NSObject <UITableViewDataSource>

@property (strong) NSFetchedResultsController* fetchedResultsController;
@property (readonly) NSString* cellId;

- (id) init __unavailable;
- (id) initWithCellId:(NSString*)cellId;

@end
