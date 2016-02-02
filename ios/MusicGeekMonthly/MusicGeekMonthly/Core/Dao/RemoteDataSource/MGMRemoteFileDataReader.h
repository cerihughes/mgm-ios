//
//  MGMRemoteFileDataReader.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@protocol MGMRemoteFileDataReaderDataSource <NSObject>

- (NSString *)pathForKey:(id)key;

@end

@interface MGMRemoteFileDataReader : MGMRemoteDataReader

@property (nonatomic, weak) id<MGMRemoteFileDataReaderDataSource> dataSource;

@end
