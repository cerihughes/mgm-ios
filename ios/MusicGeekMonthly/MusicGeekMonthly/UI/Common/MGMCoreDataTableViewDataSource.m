//
//  MGMCoreDataTableViewDataSource.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataTableViewDataSource.h"

#import "MGMCoreDataTableViewDataSourceContainer.h"

@interface MGMCoreDataTableViewDataSource ()

@property (readonly) MGMCoreDataTableViewDataSourceContainer* container;

@end

@implementation MGMCoreDataTableViewDataSource

- (id) initWithCellId:(NSString*)cellId
{
    if (self = [super init])
    {
        _cellId = cellId;
        _container = [[MGMCoreDataTableViewDataSourceContainer alloc] init];
        _screenScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void) setRenderables:(NSArray*)renderables
{
    [self.container setRenderables:renderables];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.container.sections.count;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self numberOfSectionsInTableView:tableView] > 0)
    {
        MGMCoreDataTableViewDataSourceSection* sectionObject = [self.container.sections objectAtIndex:section];
        return sectionObject.data.count;
    }
    else
    {
        return 0;
    }
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self numberOfSectionsInTableView:tableView] > 0)
    {
        MGMCoreDataTableViewDataSourceSection* sectionObject = [self.container.sections objectAtIndex:section];
        return sectionObject.name;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellId];
    }

    id<MGMRenderable> renderable = [self objectAtIndexPath:indexPath];
    cell.textLabel.text = renderable.groupValue;
    return cell;
}

- (id<MGMRenderable>) objectAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger section = [indexPath indexAtPosition:0];
    MGMCoreDataTableViewDataSourceSection* sectionObject = [self.container.sections objectAtIndex:section];
    
    NSUInteger index = [indexPath indexAtPosition:1];
    return [sectionObject.data objectAtIndex:index];
}

@end
