//
//  NSLayoutConstraint+MGM.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 05/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "NSLayoutConstraint+MGM.h"

@implementation NSLayoutConstraint (MGM)

+(instancetype)constraintWithItem:(id)view1
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

@end
