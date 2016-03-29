//
//  UIScreen+MGM.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 06/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "UIScreen+MGM.h"

@implementation UIScreen (MGM)

- (CGFloat)mgm_smallestSizeMetric
{
    CGSize screenSize = self.bounds.size;
    return MIN(screenSize.width, screenSize.height);
}

- (CGFloat)mgm_largestSizeMetric
{
    CGSize screenSize = self.bounds.size;
    return MAX(screenSize.width, screenSize.height);
}

@end
