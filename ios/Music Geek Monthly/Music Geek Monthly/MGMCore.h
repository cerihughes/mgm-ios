
#import <Foundation/Foundation.h>

@interface MGMCore : NSObject

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
