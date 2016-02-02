//
//  MGMRemoteJsonDataConverter.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@protocol MGMRemoteJsonDataConverterDelegate <MGMRemoteDataConverterDelegate>

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key;

@end

@interface MGMRemoteJsonDataConverter : MGMRemoteDataConverter

@property (nonatomic, weak) id<MGMRemoteJsonDataConverterDelegate> delegate;

@end
