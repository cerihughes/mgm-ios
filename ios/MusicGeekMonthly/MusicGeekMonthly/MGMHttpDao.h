//
//  MGMHttpDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 10/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMCoreDataAwareDao.h"

@interface MGMHttpDao : MGMCoreDataAwareDao

- (BOOL) needsUrlRefresh:(NSString*)identifier;
- (void) setNextUrlRefresh:(NSString*)identifier inDays:(NSUInteger)days;

- (NSData*) contentsOfUrl:(NSString*)url;
- (NSData*) contentsOfUrl:(NSString*)url withHttpHeaders:(NSDictionary*)headers;

@end
