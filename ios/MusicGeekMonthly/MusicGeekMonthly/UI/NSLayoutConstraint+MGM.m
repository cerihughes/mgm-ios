//
//  NSLayoutConstraint+MGM.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 05/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "NSLayoutConstraint+MGM.h"

@implementation NSLayoutConstraint (MGM)

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(nullable id)view2
                         attribute:(NSLayoutAttribute)attr2
                        multiplier:(CGFloat)multiplier
                          constant:(CGFloat)c
                          priority:(UILayoutPriority)priority
{
    NSLayoutConstraint *constraint = [self constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
    constraint.priority = priority;
    return constraint;
}

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsThatTetherView:(UIView *)view1
                                                               toView:(UIView *)view2
{
    return [self constraintsThatTetherView:view1
                                    toView:view2
                            priority:UILayoutPriorityRequired];
}

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsThatTetherView:(UIView *)view1
                                                               toView:(UIView *)view2
                                                             priority:(UILayoutPriority)priority
{
    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:view2
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0
                                                         priority:priority]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:view2
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0
                                                         priority:priority]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:view2
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0
                                                         priority:priority]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:view2
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0
                                                         priority:priority]];

    return [constraints copy];
}

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsThatTetherViewToSuperview:(UIView *)view
{
    NSDictionary *views = NSDictionaryOfVariableBindings(view);

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];

    return [constraints copy];
}

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsThatTetherNavigationBar:(UIView *)navigationBar toSuperview:(UIView *)superview
{
    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    CGFloat barOffset = 20;
    CGFloat barHeight = 44;

    [constraints addObject:[NSLayoutConstraint constraintWithItem:navigationBar
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:navigationBar
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:navigationBar
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:barOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:navigationBar
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:barHeight]];

    return [constraints copy];
}

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsThatTetherView:(UIView *)view
                                                   belowNavigationBar:(UIView *)navigationBar
                                               aboveTabBarInSuperview:(UIView *)superview;
{
    CGFloat tabBarHeight = mgm_isIpad() ? 56 : 49;
    return [self constraintsThatTetherView:view belowNavigationBar:navigationBar superview:superview bottomOffset:tabBarHeight];
}

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsThatTetherView:(UIView *)view
                                                   belowNavigationBar:(UIView *)navigationBar
                                             withoutTabBarInSuperview:(UIView *)superview;
{
    return [self constraintsThatTetherView:view belowNavigationBar:navigationBar superview:superview bottomOffset:0];
}

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsThatTetherView:(UIView *)view
                                                   belowNavigationBar:(UIView *)navigationBar
                                                            superview:(UIView *)superview
                                                         bottomOffset:(CGFloat)bottomOffset
{
    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:navigationBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:superview
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:-bottomOffset]];

    return [constraints copy];
}

@end
