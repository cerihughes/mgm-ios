//
//  MGMRemoteJsonDataConverter.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 21/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteJsonDataConverter.h"

#import "MGMRemoteData.h"

@implementation MGMRemoteJsonDataConverter

@dynamic delegate;

- (MGMRemoteData*) convertRemoteData:(NSData *)remoteData key:(id)key
{
    NSDictionary* json = nil;
    if (remoteData) {
        if ([self.delegate respondsToSelector:@selector(preprocessRemoteData:)]) {
            remoteData = [self.delegate preprocessRemoteData:remoteData];
        }

        NSError* jsonError = nil;
        json = [NSJSONSerialization JSONObjectWithData:remoteData options:0 error:&jsonError];
        if (jsonError) {
            return [MGMRemoteData dataWithError:jsonError];
        }
    }
    return [self.delegate convertJsonData:json key:key];
}

@end

