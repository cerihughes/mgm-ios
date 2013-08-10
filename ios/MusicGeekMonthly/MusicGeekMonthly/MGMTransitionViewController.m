
#import "MGMTransitionViewController.h"

@implementation MGMTransitionViewController

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return self.currentViewController.supportedInterfaceOrientations;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.currentViewController = self.initialViewController;
    [self addChildViewController:self.currentViewController];
    [self.view addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];
}

- (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return YES;
}

- (void) transitionTo:(UIViewController*)newController
{
    [newController.view layoutIfNeeded];

    [self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:newController];

    [self transitionFromViewController:self.currentViewController toViewController:newController duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:^(BOOL finished)
    {
        [self.currentViewController removeFromParentViewController];
        [newController didMoveToParentViewController:self];
        self.currentViewController = newController;
    }];
}

@end
