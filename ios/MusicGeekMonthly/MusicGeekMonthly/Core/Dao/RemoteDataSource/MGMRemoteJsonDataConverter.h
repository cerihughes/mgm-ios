//
//  MGMRemoteJsonDataConverter.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@interface MGMRemoteJsonDataConverter : MGMRemoteDataConverter

- (MGMRemoteData*) convertJsonData:(NSDictionary*)json key:(id)key;

@end
