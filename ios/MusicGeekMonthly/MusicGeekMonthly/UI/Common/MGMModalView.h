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

@interface MGMModalView<ModalContentViewType:MGMView *>  : MGMView

@property (nonatomic, weak) id<MGMModalViewDelegate> delegate;
@property (nonatomic, readonly) ModalContentViewType contentView;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(ModalContentViewType)contentView;

@end

@interface MGMModalViewPhone<ModalContentViewType:MGMView *> : MGMModalView

- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(ModalContentViewType)contentView NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
              navigationTitle:(NSString *)navigationTitle
                  buttonTitle:(NSString *)buttonTitle
                  contentView:(ModalContentViewType)contentView;

@end

@interface MGMModalViewPad<ModalContentViewType:MGMView *> : MGMModalView

- (instancetype)initWithFrame:(CGRect)frame
                  contentView:(ModalContentViewType)contentView NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
                  contentView:(ModalContentViewType)contentView;

@end
