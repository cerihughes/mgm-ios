
#import <Foundation/Foundation.h>
#import "MGMDaoFactory.h"
#import "MGMReachabilityManager.h"

@interface MGMCore : NSObject

@property (strong) MGMDaoFactory* daoFactory;
@property (strong) MGMReachabilityManager* reachabilityManager;

/**
 * Notifies the core that it's entering background mode.
 */
- (void) enteringBackground;

/**
 * Notifies the core that it's entered foreground mode.
 */
- (void) enteredForeground;

@end
