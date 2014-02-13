
#import "MGMCore.h"

#define REACHABILITY_END_POINT @"music-geek-monthly.appspot.com"

@implementation MGMCore

- (id) init
{
    if (self = [super init])
    {
        [self createInstances];
    }
    return self;
}

- (void) createInstances
{
    self.reachabilityManager = [[MGMReachabilityManager alloc] init];
    [self.reachabilityManager registerForReachabilityTo:REACHABILITY_END_POINT];
    self.daoFactory = [[MGMDaoFactory alloc] initWithReachabilityManager:self.reachabilityManager];
}

@end
