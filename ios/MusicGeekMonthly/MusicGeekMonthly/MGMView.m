
#import "MGMView.h"

@implementation MGMView

static BOOL _iPad;

+ (void) initialize
{
    _iPad = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

+ (UILabel*) boldLabelWithText:(NSString *)text
{
    return [self labelWithText:text fontName:DEFAULT_FONT_BOLD];
}

+ (UILabel*) italicLabelWithText:(NSString *)text
{
    return [self labelWithText:text fontName:DEFAULT_FONT_ITALIC];
}

+ (UILabel*) labelWithText:(NSString *)text fontName:(NSString*)fontName
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];

    BOOL iPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    label.font = [UIFont fontWithName:fontName size:(iPad ? 28.0 : 17.0)];
    return label;
}

- (void) commonInit
{
    if (_iPad)
    {
        [self commonInitIpad];
    }
    else
    {
        [self commonInitIphone];
    }
}

- (void) commonInitIphone
{
    // Override
}

- (void) commonInitIpad
{
    // Override
}

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void) layoutSubviews
{
    if (_iPad)
    {
        [self layoutSubviewsIpad];
    }
    else
    {
        [self layoutSubviewsIphone];
    }
}

- (void) layoutSubviewsIphone
{
    // Override
}

- (void) layoutSubviewsIpad
{
    // Override
}

@end
