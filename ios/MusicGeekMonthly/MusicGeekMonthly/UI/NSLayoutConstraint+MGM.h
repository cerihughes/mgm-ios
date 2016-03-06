//
//  NSLayoutConstraint+MGM.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 05/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (MGM)

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(nullable id)view2
                         attribute:(NSLayoutAttribute)attr2
                        multiplier:(CGFloat)multiplier
                          constant:(CGFloat)c
                          priority:(UILayoutPriority)priority;

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsWithItem:(id)view1
                                   thatMatchCenterAndSizeOfItem:(id)view2;

+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsWithItem:(id)view1
                                   thatMatchCenterAndSizeOfItem:(id)view2
                                                       priority:(UILayoutPriority)priority;

NS_ASSUME_NONNULL_END

@end
