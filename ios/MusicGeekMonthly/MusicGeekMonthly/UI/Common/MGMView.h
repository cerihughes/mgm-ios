
@import UIKit;

#define DEFAULT_FONT_MEDIUM @"HelveticaNeue-Medium"
#define DEFAULT_FONT_ITALIC @"HelveticaNeue-MediumItalic"
#define DEFAULT_FONT_BOLD @"HelveticaNeue-Bold"

@interface MGMView : UIView

+ (UILabel *)boldTitleLabelWithText:(NSString *)text;
+ (UILabel *)boldSubtitleLabelWithText:(NSString *)text;
+ (UILabel *)italicTitleLabelWithText:(NSString *)text;
+ (UILabel *)italicSubtitleLabelWithText:(NSString *)text;
+ (UIButton *)shadowedButtonWithText:(NSString *)text image:(UIImage *)image;
+ (UIButton *)buttonWithText:(NSString *)text image:(UIImage *)image;

- (void)commonInit;
- (void)commonInitIphone;
- (void)commonInitIpad;

- (void)addFixedConstraints;

- (void)layoutSubviewsIphone;
- (void)layoutSubviewsIpad;

@end
