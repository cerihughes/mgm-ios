//
//  MGMDao.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 14/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGMDao : NSObject

- (NSData*) getContentsOfUrl:(NSString*)url;
- (NSData*) getContentsOfUrl:(NSString*)url withHttpHeaders:(NSDictionary*)headers;

@end
