//
//  MGMDaoOperation.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/02/2014.
//  Copyright (c) 2014 Ceri Hughes. All rights reserved.
//

#import "MGMDaoOperation.h"

#import "MGMCoreDataAccess.h"
#import "MGMDaoData.h"
#import "MGMLocalDataSource.h"
#import "MGMNextUrlAccess.h"
#import "MGMRemoteData.h"
#import "MGMRemoteDataSource.h"

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

- (oneway void) fetchData:(id)key completion:(DAO_FETCH_COMPLETION)completion
{
    [self.operationLock lock];
    @try
    {
        [self synchonizedFetchData:key completion:completion];
    }
    @finally
    {
        [self.operationLock unlock];
    }
}

- (oneway void) synchonizedFetchData:(id)key completion:(DAO_FETCH_COMPLETION)completion
{
    NSString* refreshIdentifier = [self refreshIdentifierForKey:key];

    [self.coreDataAccess fetchNextUrlAccessWithIdentifier:refreshIdentifier completion:^(NSManagedObjectID* moid, NSError* nextAccessError) {
        MGMNextUrlAccess* nextAccess = [self.coreDataAccess mainThreadVersion:moid];
        
        if (nextAccessError)
        {
            completion([MGMDaoData dataWithError:nextAccessError]);
        }
        else
        {
            if ([self needsRefresh:nextAccess])
            {
                [self.remoteDataSource fetchRemoteData:key completion:^(MGMRemoteData* remoteData) {
                    if (remoteData.error == nil)
                    {
                        if ([remoteData.checksum isEqualToString:nextAccess.checksum] == NO)
                        {
                            MGMLocalDataSource* lds = self.localDataSource;
                            // There is new data... Persist it.
                            [lds persistRemoteData:remoteData key:key completion:^(NSError* persistError) {
                                if (persistError)
                                {
                                    completion([MGMDaoData dataWithError:persistError]);
                                }
                                else
                                {
                                    [self setNextRefresh:refreshIdentifier inDays:self.daysBetweenRemoteFetch completion:^(NSError* setNextAccessError) {
                                        if (setNextAccessError)
                                        {
                                            completion([MGMDaoData dataWithError:setNextAccessError]);
                                        }
                                        else
                                        {
                                            [lds fetchLocalData:key completion:^(MGMLocalData* localData) {
                                                completion([MGMDaoData dataWithLocalData:localData isNew:YES]);
                                            }];
                                        }
                                    }];
                                }
                            }];
                        }
                        else
                        {
                            [self.localDataSource fetchLocalData:key completion:^(MGMLocalData* localData) {
                                completion([MGMDaoData dataWithLocalData:localData isNew:NO]);
                            }];
                        }
                    }
                    else
                    {
                        [self.localDataSource fetchLocalData:key completion:^(MGMLocalData* localData) {
                            MGMDaoData* daoData = [MGMDaoData dataWithLocalData:localData isNew:NO];
                            daoData.error = remoteData.error;
                            completion(daoData);
                        }];
                    }
                }];
            }
            else
            {
                [self.localDataSource fetchLocalData:key completion:^(MGMLocalData* localData) {
                    completion([MGMDaoData dataWithLocalData:localData isNew:NO]);
                }];
            }
        }
    }];
}

- (oneway void) setNextRefresh:(NSString*)identifier inDays:(NSUInteger)days completion:(CORE_DATA_PERSIST_COMPLETION)completion
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = days;

    NSDate* now = [NSDate date];
    NSDate* then = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:now options:0];

    [self.coreDataAccess persistNextUrlAccess:identifier date:then completion:completion];
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
