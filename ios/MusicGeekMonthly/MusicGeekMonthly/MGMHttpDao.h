//
//  MGMHttpDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMDao.h"

@interface MGMHttpDao : MGMDao

- (NSData*) contentsOfUrl:(NSString*)url;
- (NSData*) contentsOfUrl:(NSString*)url withHttpHeaders:(NSDictionary*)headers;

@end
