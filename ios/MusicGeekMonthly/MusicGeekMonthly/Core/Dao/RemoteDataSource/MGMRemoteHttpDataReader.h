//
//  MGMRemoteHttpDataReader.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@interface MGMRemoteHttpDataReader : MGMRemoteDataReader

- (NSString*) urlForKey:(id)key;
- (NSDictionary*) httpHeaders;

@end
