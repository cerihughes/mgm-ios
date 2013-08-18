//
//  MGMCoreDataTableViewDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataTableViewDataSource.h"
#import "MGMRenderable.h"

@interface MGMCoreDataTableViewDataSource ()

@property (strong) NSString* internalCellId;

@end

@implementation MGMCoreDataTableViewDataSource

- (id) initWithCellId:(NSString*)cellId
{
    if (self = [super init])
    {
        self.internalCellId = cellId;
    }
    return self;
}

- (NSString*) cellId
{
    return self.internalCellId;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fetchedResultsController.sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        return sectionInfo.numberOfObjects;
    }
    else
    {
        return 0;
    }
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.fetchedResultsController.sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        return sectionInfo.name;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.internalCellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.internalCellId];
    }

    id<MGMRenderable> renderable = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = renderable.groupValue;
    return cell;
}

@end
