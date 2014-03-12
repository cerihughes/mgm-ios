//
//  MGMDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"

@interface MGMDaoOperation ()

@property (readonly) NSLock* operationLock;
@property (readonly) MGMCoreDataAccess* coreDataAccess;
@property (readonly) MGMLocalDataSource* localDataSource;
@property (readonly) MGMRemoteDataSource* remoteDataSource;

@end

@implementation MGMDaoOperation

- (id) initWithCoreDataAccess:(MGMCoreDataAccess *)coreDataAccess
{
    if (self = [super init])
    {
        _operationLock = [[NSLock alloc] init];
        _coreDataAccess = coreDataAccess;
        _localDataSource = [self createLocalDataSource:coreDataAccess];
        _remoteDataSource = [self createRemoteDataSource];
    }
    return self;
}

- (NSUInteger) daysBetweenRemoteFetch
{
    return 1;
}

- (void) setReachability:(BOOL)reachability
{
    self.remoteDataSource.reachability = reachability;
}

- (MGMDaoData*) fetchData:(id)key
{
    [self.operationLock lock];
    @try
    {
        return [self synchonizedFetchData:key];
    }
    @finally
    {
        [self.operationLock unlock];
    }
}

- (MGMDaoData*) synchonizedFetchData:(id)key
{
    NSString* refreshIdentifier = [self refreshIdentifierForKey:key];

    NSError* nextAccessError = nil;
    NSManagedObjectID* moid = [self.coreDataAccess fetchNextUrlAccessWithIdentifier:refreshIdentifier error:&nextAccessError];
    MGMNextUrlAccess* nextAccess = [self.coreDataAccess threadVersion:moid];

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

- (MGMLocalDataSource*) createLocalDataSource:(MGMCoreDataAccess*)coreDataAccess
{
    // OVERRIDE
    return nil;
}

- (MGMRemoteDataSource*) createRemoteDataSource
{
    // OVERRIDE
    return nil;
}

- (NSString*) refreshIdentifierForKey:(id)key
{
    return nil;
}

- (BOOL) needsRefresh:(MGMNextUrlAccess*)nextAccess
{
    NSDate* nextAccessDate = nextAccess.date;
    return nextAccessDate == nil || ([[NSDate date] earlierDate:nextAccessDate] == nextAccessDate);
}

@end
