//
//  MGMRemoteDataSource.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

@import Foundation;

@class MGMRemoteData;

@interface MGMRemoteDataReader : NSObject

@property BOOL reachability;

- (NSData*) readRemoteData:(id)key error:(NSError**)error;
- (void) markRemoteDataAsInvalid:(id)key;

@end

@protocol MGMRemoteDataConverterDelegate <NSObject>

@optional
- (NSData *)preprocessRemoteData:(NSData *)remoteData;

@end

@interface MGMRemoteDataConverter : NSObject

@property (nonatomic, weak) id<MGMRemoteDataConverterDelegate> delegate;

- (MGMRemoteData*) convertRemoteData:(NSData*)remoteData key:(id)key;

@end

typedef void (^REMOTE_DATA_FETCH_COMPLETION) (MGMRemoteData*);

@interface MGMRemoteDataSource : NSObject

- (MGMRemoteDataReader*) createRemoteDataReader;
- (MGMRemoteDataConverter*) createRemoteDataConverter;

- (void) setReachability:(BOOL)reachability;

- (oneway void) fetchRemoteData:(id)key completion:(REMOTE_DATA_FETCH_COMPLETION)completion;

@end
