
#import <UIKit/UIKit.h>

#define DEFAULT_FONT_MEDIUM @"HelveticaNeue-Medium"
#define DEFAULT_FONT_ITALIC @"HelveticaNeue-MediumItalic"
#define DEFAULT_FONT_BOLD @"HelveticaNeue-Bold"

typedef NS_ENUM(NSUInteger, MGMViewScreenSize)
{
    MGMViewScreenSizeiPhone480,
    MGMViewScreenSizeiPhone576,
    MGMViewScreenSizeiPad
};

@interface MGMView : UIView

@property (readonly) MGMViewScreenSize screenSize;
@property (readonly) CGFloat statusBarHeight;
@property (readonly) CGFloat navigationBarHeight;
@property (readonly) CGFloat tabBarHeight;

+ (UILabel*) boldTitleLabelWithText:(NSString*)text;
+ (UILabel*) boldSubtitleLabelWithText:(NSString*)text;
+ (UILabel*) italicTitleLabelWithText:(NSString*)text;
+ (UILabel*) italicSubtitleLabelWithText:(NSString*)text;
+ (UIButton*) shadowedButtonWithText:(NSString*)text image:(UIImage*)image;
+ (UIButton*) buttonWithText:(NSString*)text image:(UIImage*)image;

- (void) commonInit;
- (void) commonInitIphone;
- (void) commonInitIpad;

- (void) layoutSubviewsIphone;
- (void) layoutSubviewsIpad;

@end
