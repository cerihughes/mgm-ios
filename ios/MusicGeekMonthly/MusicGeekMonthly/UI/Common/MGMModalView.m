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
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
@property (nonatomic, readonly) MGMView *contentViewInternal;

@end

@implementation MGMModalViewPhone

- (instancetype)initWithFrame:(CGRect)frame
              navigationTitle:(NSString *)navigationTitle
                  buttonTitle:(NSString *)buttonTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:navigationTitle];
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressed:)];
        [navigationItem setRightBarButtonItem:bbi];
        [_navigationBar pushNavigationItem:navigationItem animated:YES];

        _contentViewInternal = [[MGMView alloc] initWithFrame:frame];
        _contentViewInternal.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_navigationBar];
        [self addSubview:_contentViewInternal];
    }
    return self;
}

- (MGMView *)contentView
{
    return self.contentViewInternal;
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
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.navigationBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:5]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
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
@property (nonatomic, readonly) MGMView *contentViewInternal;

@end

@implementation MGMModalViewPad

- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitle:buttonTitle forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        _contentViewInternal = [[MGMView alloc] initWithFrame:frame];
        _contentViewInternal.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_cancelButton];
        [self addSubview:_contentViewInternal];
    }
    return self;
}

- (MGMView *)contentView
{
    return self.contentViewInternal;
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
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.cancelButton
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:buttonInset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentViewInternal
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
