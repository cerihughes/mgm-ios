//
//  MGMCoreDataTableViewDataSourceContainer.m
//  MusicGeekMonthly
//
//  Created by Home on 12/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataTableViewDataSourceContainer.h"

#import <CoreData/CoreData.h>

@interface MGMCoreDataTableViewDataSourceSection ()

@property (strong) NSString* name;
@property (readonly) NSMutableArray* mutableData;

- (void) addRenderable:(id<MGMRenderable>)renderable;

@end

@implementation MGMCoreDataTableViewDataSourceSection

- (id) init
{
    if (self = [super init])
    {
        _mutableData = [NSMutableArray array];
    }
    return self;
}

- (NSArray*) data
{
    return [self.mutableData copy];
}

- (void) addRenderable:(id<MGMRenderable>)renderable
{
    [self.mutableData addObject:renderable];
}

@end

@interface MGMCoreDataTableViewDataSourceContainer ()

@property (readonly) NSMutableArray* mutableSections;
@property (readonly) NSMutableDictionary* sectionDictionary;

@end

@implementation MGMCoreDataTableViewDataSourceContainer

- (id) init
{
    if (self = [super init])
    {
        _mutableSections = [NSMutableArray array];
        _sectionDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray*) sections
{
    return [self.mutableSections copy];
}

- (void) setRenderables:(NSArray*)renderables
{
    [self.mutableSections removeAllObjects];
    [self.sectionDictionary removeAllObjects];
    
    for (id<MGMRenderable> renderable in renderables)
    {
        MGMCoreDataTableViewDataSourceSection* section = [self sectionForRenderable:renderable];
        [section addRenderable:renderable];
    }
}

- (MGMCoreDataTableViewDataSourceSection*) sectionForRenderable:(id<MGMRenderable>)renderable
{
    NSString* key = renderable.groupHeader;
    MGMCoreDataTableViewDataSourceSection* section = [self.sectionDictionary objectForKey:key];
    if (section == nil)
    {
        section = [[MGMCoreDataTableViewDataSourceSection alloc] init];
        section.name = key;
        [self.sectionDictionary setObject:section forKey:key];
        [self.mutableSections addObject:section];
    }
    return section;
}

@end
