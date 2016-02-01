//
//  MGMRemoteXmlDataConverter.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 22/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteDataSource.h"

@protocol MGMRemoteXmlDataConverterDelegate <MGMRemoteDataConverterDelegate>

- (MGMRemoteData*) convertXmlData:(NSDictionary*)xml key:(id)key;

@end

@interface MGMRemoteXmlDataConverter : MGMRemoteDataConverter

@property (nonatomic, weak) id<MGMRemoteXmlDataConverterDelegate> delegate;

@end
