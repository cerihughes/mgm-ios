//
//  SCNode.h
//  Spotify Challenges
//
//  Created by Ceri Hughes on 29/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCStick.h"

@interface SCNode : NSObject

@property (nonatomic, readonly) NSArray* sticks;

- (void) addStrick:(SCStick*)stick;

@end
