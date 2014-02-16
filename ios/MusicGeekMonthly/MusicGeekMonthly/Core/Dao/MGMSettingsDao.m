//
//  MGMSettingsDao.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 29/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMSettingsDao.h"

#define LAST_CAPABILITIES_KEY @"LAST_CAPABILITIES_KEY"
#define DEFAULT_SERVICE_TYPE_KEY @"DEFAULT_SERVICE_TYPE_KEY"

@implementation MGMSettingsDao

- (NSUInteger) lastCapabilities
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* value = [defaults valueForKey:LAST_CAPABILITIES_KEY];
    if (value)
    {
        return value.integerValue;
    }
    return MGMAlbumServiceTypeNone;
}

- (void) setLastCapabilities:(NSUInteger)lastCapabilities
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:lastCapabilities] forKey:LAST_CAPABILITIES_KEY];
    [defaults synchronize];
}

- (MGMAlbumServiceType) defaultServiceType
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* value = [defaults valueForKey:DEFAULT_SERVICE_TYPE_KEY];
    if (value)
    {
        return (MGMAlbumServiceType)value.integerValue;
    }
    return MGMAlbumServiceTypeNone;
}

- (void) setDefaultServiceType:(MGMAlbumServiceType)defaultServiceType
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:defaultServiceType] forKey:DEFAULT_SERVICE_TYPE_KEY];
    [defaults synchronize];
}

@end
