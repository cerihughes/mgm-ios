//
//  SIPListElement.h
//  Stack
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIPListElement : NSObject

@property (nonatomic, strong) SIPListElement* nextElement;
@property (nonatomic, strong) id value;

+ (instancetype) elementWithNextElement:(SIPListElement*)nextElement value:(id)value;

- (instancetype) initWithNextElement:(SIPListElement*)nextElement value:(id)value;

@end
