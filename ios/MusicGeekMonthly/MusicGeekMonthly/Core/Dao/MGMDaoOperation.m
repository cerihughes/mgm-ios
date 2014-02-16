//
//  MGMDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation+Protected.h"

@interface MGMDaoOperation ()

@property (readonly) MGMCoreDataAccess* coreDataAccess;
@property (readonly) MGMLocalDataSource* localDataSource;
@property (readonly) MGMRemoteDataSource* remoteDataSource;
@property (readonly) NSUInteger daysBetweenRemoteFetch;

@end

@implementation MGMDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess localDataSource:(MGMLocalDataSource *)localDataSource remoteDataSource:(MGMRemoteDataSource *)remoteDataSource daysBetweenRemoteFetch:(NSUInteger)daysBetweenRemoteFetch
{
    if (self = [super init])
    {
        _coreDataAccess = coreDataAccess;
        _localDataSource = localDataSource;
        _remoteDataSource = remoteDataSource;
        _daysBetweenRemoteFetch = daysBetweenRemoteFetch;
    }
    return self;
}

- (MGMDaoData*) fetchData:(id)key
{
    NSString* refreshIdentifier = [self refreshIdentifierForKey:key];

    NSError* nextAccessError = nil;
    MGMNextUrlAccess* nextAccess = [self.coreDataAccess fetchNextUrlAccessWithIdentifier:refreshIdentifier error:&nextAccessError];

    if (nextAccessError)
    {
        return [MGMDaoData dataWithError:nextAccessError];
    }

    BOOL isNew = NO;
    if ([self needsRefresh:nextAccess])
    {
        MGMRemoteData* remoteData = [self.remoteDataSource fetchRemoteData:key];
        if (remoteData.error == nil && ![remoteData.checksum isEqualToString:nextAccess.checksum])
        {
            // There is new data... Persist it.
            NSError* persistError = nil;
            [self.localDataSource persistRemoteData:remoteData key:key error:&persistError];
            if (persistError)
            {
                return [MGMDaoData dataWithError:persistError];
            }

            NSError* setNextAccessError = nil;
            [self setNextRefresh:refreshIdentifier inDays:self.daysBetweenRemoteFetch error:&setNextAccessError];
            if (setNextAccessError)
            {
                return [MGMDaoData dataWithError:setNextAccessError];
            }

            isNew = YES;
        }
    }

    MGMLocalData* localData = [self.localDataSource fetchLocalData:key];
    return [MGMDaoData dataWithLocalData:localData isNew:isNew];
}

- (BOOL) needsRefresh:(MGMNextUrlAccess*)nextAccess
{
    NSDate* nextAccessDate = nextAccess.date;
    return nextAccessDate == nil || ([[NSDate date] earlierDate:nextAccessDate] == nextAccessDate);
}

- (BOOL) setNextRefresh:(NSString*)identifier inDays:(NSUInteger)days error:(NSError**)error
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = days;

    NSDate* now = [NSDate date];
    NSDate* then = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:now options:0];

    [self.coreDataAccess persistNextUrlAccess:identifier date:then error:error];
    return MGM_NO_ERROR(error);
}

@end

@implementation MGMDaoOperation (Protected)

- (NSString*) refreshIdentifierForKey:(id)key
{
    return nil;
}

@end
