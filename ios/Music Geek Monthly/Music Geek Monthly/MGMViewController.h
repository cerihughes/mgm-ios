
#import <UIKit/UIKit.h>
#import "MGMUI.h"

@interface MGMViewController : UIViewController

@property (weak) MGMUI* ui;

- (void) transitionCompleteWithState:(id)state;

@end
