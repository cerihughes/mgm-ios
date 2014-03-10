//
//  MGMRemoteDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGMRemoteData.h"

@interface MGMRemoteDataReader : NSObject

@property BOOL reachability;

- (NSData*) readRemoteData:(id)key error:(NSError**)error;

@end

@interface MGMRemoteDataConverter : NSObject

- (MGMRemoteData*) convertRemoteData:(NSData*)remoteData key:(id)key;

@end

@interface MGMRemoteDataSource : NSObject

- (MGMRemoteDataReader*) createRemoteDataReader;
- (MGMRemoteDataConverter*) createRemoteDataConverter;

- (void) setReachability:(BOOL)reachability;

- (MGMRemoteData*) fetchRemoteData:(id)key;

@end
