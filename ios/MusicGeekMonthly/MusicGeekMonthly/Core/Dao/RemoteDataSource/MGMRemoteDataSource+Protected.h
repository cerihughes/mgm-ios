//
//  MGMRemoteDataSource+Protected.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@interface MGMRemoteDataSource (Protected)

- (NSDate*) dateForJsonString:(NSString*)jsonString;

#pragma mark -
#pragma mark Override the following

- (NSString*) urlForKey:(id)key;
- (NSDictionary*) httpHeaders;
- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key;

@end
