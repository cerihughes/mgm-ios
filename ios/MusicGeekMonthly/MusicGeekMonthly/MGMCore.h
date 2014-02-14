
#import <Foundation/Foundation.h>
#import "MGMDaoFactory.h"
#import "MGMReachabilityManager.h"

typedef NS_ENUM(NSUInteger, MGMCoreBackgroundFetchResult)
{
    MGMCoreBackgroundFetchResultNoData,
    MGMCoreBackgroundFetchResultNewData,
    MGMCoreBackgroundFetchResultFailed
};

@interface MGMCore : NSObject

@property (strong) MGMDaoFactory* daoFactory;
@property (strong) MGMReachabilityManager* reachabilityManager;

- (MGMCoreBackgroundFetchResult) performBackgroundFetch;

@end
