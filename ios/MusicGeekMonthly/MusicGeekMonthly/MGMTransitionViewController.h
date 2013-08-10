
#import <UIKit/UIKit.h>

@interface MGMTransitionViewController : UIViewController

@property (retain) UIViewController* initialViewController;
@property (retain) UIViewController* currentViewController;

- (void) transitionTo:(UIViewController*)newController;

@end
