//
//  MGMRemoteXmlDataConverter.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 22/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteXmlDataConverter.h"

#import "MGMRemoteData.h"
#import "MGMXmlParser.h"

@implementation MGMRemoteXmlDataConverter

@dynamic delegate;

- (MGMRemoteData*) convertRemoteData:(NSData *)remoteData key:(id)key
{
    NSDictionary* xml = nil;
    if (remoteData) {
        if ([self.delegate respondsToSelector:@selector(preprocessRemoteData:)]) {
            remoteData = [self.delegate preprocessRemoteData:remoteData];
        }

        NSError* xmlError = nil;
        xml = [MGMXmlParser dictionaryForXMLData:remoteData error:&xmlError];
        if (xmlError) {
            return [MGMRemoteData dataWithError:xmlError];
        }
    }
    return [self.delegate convertXmlData:xml key:key];
}

@end