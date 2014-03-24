//
//  SIPListElement.m
//  Stack
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import "SIPListElement.h"

@implementation SIPListElement

+ (instancetype) elementWithNextElement:(SIPListElement *)nextElement value:(id)value
{
    return [[SIPListElement alloc] initWithNextElement:nextElement value:value];
}

- (instancetype) initWithNextElement:(SIPListElement *)nextElement value:(id)value
{
    self = [super init];
    if (self)
    {
        self.nextElement = nextElement;
        self.value = value;
    }
    return self;
}

@end
