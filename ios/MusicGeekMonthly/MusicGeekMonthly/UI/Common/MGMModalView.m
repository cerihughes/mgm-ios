//
//  MGMModalView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMModalView.h"

@implementation MGMModalView

- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(MGMView *)contentView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _contentView = contentView;

        [self addSubview:_contentView];
    }
    return self;
}

- (void)buttonPressed:(id)sender
{
    [self.delegate modalButtonPressed];
}

@end

@interface MGMModalViewPhone ()

@property (readonly) UINavigationBar* navigationBar;

@end

@implementation MGMModalViewPhone

- (instancetype)initWithFrame:(CGRect)frame
              navigationTitle:(NSString *)navigationTitle
                  buttonTitle:(NSString *)buttonTitle
                  contentView:(MGMView *)contentView
{
    self = [super initWithFrame:frame contentView:contentView];
    if (self) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:navigationTitle];
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressed:)];
        [navigationItem setRightBarButtonItem:bbi];
        [_navigationBar pushNavigationItem:navigationItem animated:YES];

        [self addSubview:_navigationBar];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Navigation bar
    CGFloat topOffset = 20;
    CGFloat navigationBarHeight = 44;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:topOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.navigationBar
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:navigationBarHeight]];

    // Content view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.navigationBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:5]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end

@interface MGMModalViewPad ()

@property (readonly) UIButton* cancelButton;

@end

@implementation MGMModalViewPad

- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
                  contentView:(MGMView *)contentView
{
    self = [super initWithFrame:frame contentView:contentView];
    if (self) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitle:buttonTitle forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Cancel button
    CGFloat buttonInset = 20;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.cancelButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:-buttonInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.cancelButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:buttonInset]];

    // Content view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.cancelButton
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:buttonInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
