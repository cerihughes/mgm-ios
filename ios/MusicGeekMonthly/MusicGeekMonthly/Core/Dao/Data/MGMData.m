//
//  MGMData.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMData.h"

@implementation MGMData

- (id) initWithError:(NSError*)error
{
    if (self = [super init])
    {
        self.error = error;
    }
    return self;
}

@end
