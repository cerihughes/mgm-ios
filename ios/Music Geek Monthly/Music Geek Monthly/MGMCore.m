
#import "MGMCore.h"

@interface MGMCore()

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
