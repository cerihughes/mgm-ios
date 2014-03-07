//
//  MGMPlayerGroupView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/12/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlayerGroupView.h"

#define GAP 10.0

@interface MGMPlayerGroupView ()

@property (readonly) NSMutableArray* buttons;

@end

@implementation MGMPlayerGroupView

- (void) commonInit
{
    [super  commonInit];
    
    _buttons = [NSMutableArray array];
}

- (void) clearAll
{
    for (UIButton* button in self.buttons)
    {
        [button removeFromSuperview];
    }

    [self.buttons removeAllObjects];
    [self setNeedsLayout];
}

- (void) addServiceType:(MGMAlbumServiceType)serviceType withImage:(UIImage *)image label:(NSString *)label available:(BOOL)available
{
    if (!available)
    {
        image = [self greyscaleImage:image];
    }

    UIButton* button = [MGMView shadowedButtonWithText:label image:image];
    button.alpha = available ? 1.0 : 0.1;
    button.userInteractionEnabled = available;
    button.tag = serviceType;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:button];
    [self.buttons addObject:button];
    [self setNeedsLayout];
}

- (UIImage*) greyscaleImage:(UIImage*)image
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, image.size.width, colorSpace, 0);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);

    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    UIImage* greyscaleImage = [UIImage imageWithCGImage:bwImage];
    CGImageRelease(bwImage);
    return greyscaleImage;
}

- (void) buttonPressed:(UIButton*)pressed
{
    MGMAlbumServiceType serviceType = (MGMAlbumServiceType)pressed.tag;
    [self.delegate serviceTypeSelected:serviceType];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    NSUInteger iconsPerRow = self.buttons.count / 2;

    CGSize size = self.frame.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat iconWidth = (width - ((iconsPerRow + 1) * GAP)) / iconsPerRow;
    CGFloat iconHeight = (height - (3 * GAP)) / 2.0;
    CGFloat iconSize = iconWidth < iconHeight ? iconWidth : iconHeight;

    [self.buttons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL* stop) {
        NSUInteger row = idx < iconsPerRow ? 0 : 1;
        NSUInteger column = idx < iconsPerRow ? idx : idx - iconsPerRow;
        CGFloat xSpace =  (width - (iconSize * iconsPerRow)) / (iconsPerRow + 1);
        CGFloat x = (column * (iconSize + xSpace)) + xSpace;
        CGFloat y = row * (iconSize + GAP) + GAP;
        button.frame = CGRectMake(x, y, iconSize, iconSize);
        CGFloat inset = button.titleLabel.frame.size.height - iconSize;
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, inset, 0.0);
    }];
}

@end
