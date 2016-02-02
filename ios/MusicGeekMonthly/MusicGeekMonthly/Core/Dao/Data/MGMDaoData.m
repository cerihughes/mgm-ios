//
//  MGMDaoData.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoData.h"

#import "MGMLocalData.h"

@implementation MGMDaoData

+ (MGMDaoData*) dataWithError:(NSError*)error
{
    return [[MGMDaoData alloc] initWithError:error];
}

+ (MGMDaoData*) dataWithLocalData:(MGMLocalData*)localData isNew:(BOOL)isNew
{
    MGMDaoData* data = [[MGMDaoData alloc] init];
    data.data = localData.data;
    data.error = localData.error;
    data.isNew = isNew;
    return data;
}

@end
