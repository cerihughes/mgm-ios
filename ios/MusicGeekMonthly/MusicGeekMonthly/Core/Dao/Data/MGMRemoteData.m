//
//  MGMRemoteData.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteData.h"

@implementation MGMRemoteData

+ (MGMRemoteData*) dataWithError:(NSError*)error
{
    return [[MGMRemoteData alloc] initWithError:error];
}

@end
