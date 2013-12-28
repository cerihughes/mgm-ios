
#import <Foundation/Foundation.h>
#import "MGMDaoFactory.h"
#import "MGMReachabilityManager.h"

@interface MGMCore : NSObject

@property (strong) MGMDaoFactory* daoFactory;
@property (strong) MGMReachabilityManager* reachabilityManager;

@end
