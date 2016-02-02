//
//  MGMRemoteHttpDataReader.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@protocol MGMRemoteHttpDataReaderDataSource <NSObject>

@required
- (NSString *)urlForKey:(id)key;

@optional
- (NSDictionary *)httpHeaders;

@end

@interface MGMRemoteHttpDataReader : MGMRemoteDataReader

@property (nonatomic, weak) id<MGMRemoteHttpDataReaderDataSource> dataSource;

@end
