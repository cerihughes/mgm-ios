//
//  MGMPopoutView.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 27/03/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMView.h"

@import Foundation;
@import UIKit;

@protocol MGMPopoutViewDelegate <NSObject>

- (void) cancelButtonPressed:(id)sender;

@end

@interface MGMPopoutView : MGMView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView;

@property (weak) id<MGMPopoutViewDelegate> delegate;

@property (readonly) UITableView* tableView;

@end

@interface MGMPopoutViewPhone : MGMPopoutView

- (instancetype)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame
                    tableView:(UITableView *)tableView
              navigationTitle:(NSString *)navigationTitle
                  buttonTitle:(NSString *)buttonTitle;

@end

@interface MGMPopoutViewPad : MGMPopoutView

@end
