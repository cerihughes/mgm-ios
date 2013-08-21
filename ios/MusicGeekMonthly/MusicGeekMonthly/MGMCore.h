
#import <Foundation/Foundation.h>
#import "MGMDaoFactory.h"

@interface MGMCore : NSObject

@property (strong) MGMDaoFactory* daoFactory;

/**
 * Notifies the core that it's entering background mode.
 */
- (void) enteringBackground;

/**
 * Notifies the core that it's entered foreground mode.
 */
- (void) enteredForeground;

/**
 * Notifies the core that it's been woken up for periodic processing when in suspended mode.
 */
- (void) keepAlive;

@end
