
#import <UIKit/UIKit.h>

#define DEFAULT_FONT_MEDIUM @"HelveticaNeue-Medium"
#define DEFAULT_FONT_ITALIC @"HelveticaNeue-MediumItalic"
#define DEFAULT_FONT_BOLD @"HelveticaNeue-Bold"

@interface MGMView : UIView

@property (readonly) CGFloat statusBarHeight;
@property (readonly) CGFloat navigationBarHeight;
@property (readonly) CGFloat tabBarHeight;

+ (UILabel*) boldLabelWithText:(NSString*)text;
+ (UILabel*) italicLabelWithText:(NSString*)text;

- (void) commonInit;
- (void) commonInitIphone;
- (void) commonInitIpad;

- (void) layoutSubviewsIphone;
- (void) layoutSubviewsIpad;

@end
