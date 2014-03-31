//
//  SCStick.h
//  Spotify Challenges
//
//  Created by Ceri Hughes on 29/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCNode;

@interface SCStick : NSObject

@property (nonatomic, weak) SCNode* nodeA;
@property (nonatomic, weak) SCNode* nodeB;

@end
