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

@interface MGMModalView<__covariant ObjectType:MGMView *>  : MGMView

@property (nonatomic, weak) id<MGMModalViewDelegate> delegate;
@property (nonatomic, readonly) ObjectType contentView;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(ObjectType)contentView;

@end

@interface MGMModalViewPhone<__covariant ObjectType:MGMView *> : MGMModalView

- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(ObjectType)contentView NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
              navigationTitle:(NSString *)navigationTitle
                  buttonTitle:(NSString *)buttonTitle
                  contentView:(ObjectType)contentView;

@end

@interface MGMModalViewPad<__covariant ObjectType:MGMView *> : MGMModalView

- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(ObjectType)contentView NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
                  contentView:(ObjectType)contentView;

@end
