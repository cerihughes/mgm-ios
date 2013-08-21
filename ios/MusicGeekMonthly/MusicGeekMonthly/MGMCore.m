
#import "MGMCore.h"

@interface MGMCore ()

- (void) createInstances;

@end

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
    self.daoFactory = [[MGMDaoFactory alloc] init];
}

- (void) enteredForeground
{
}

- (void) enteringBackground
{
}

- (void) keepAlive
{
}

@end
