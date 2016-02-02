//
//  MGMRemoteFileDataReader.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 08/03/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMRemoteFileDataReader.h"

@implementation MGMRemoteFileDataReader

- (NSData *)readRemoteData:(id)key error:(NSError**)error
{
    NSString *path = [self.dataSource pathForKey:key];
    return [[NSFileManager defaultManager] contentsAtPath:path];
}

@end
