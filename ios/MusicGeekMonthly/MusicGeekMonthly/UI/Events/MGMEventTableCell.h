//
//  MGMEventTableCell.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMEventTableCell : UITableViewCell

@property (strong) UIActivityIndicatorView* classicAlbumActivityView;
@property (strong) UIActivityIndicatorView* newlyReleasedAlbumActivityView;
@property (strong) UIImageView* classicAlbumImageView;
@property (strong) UIImageView* newlyReleasedAlbumImageView;
@property (strong) UILabel* eventTextLabel;

@end
