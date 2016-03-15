//
//  MGMModalView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 14/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@protocol MGMModalViewDelegate <NSObject>

- (void)modalButtonPressed;

@end

@interface MGMModalView : MGMView

@property (nonatomic, weak) id<MGMModalViewDelegate> delegate;
@property (nonatomic, readonly) MGMView *contentView;

@end

@interface MGMModalViewPhone : MGMModalView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
              navigationTitle:(NSString *)navigationTitle
                  buttonTitle:(NSString *)buttonTitle;

@end

@interface MGMModalViewPad : MGMModalView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle;

@end
