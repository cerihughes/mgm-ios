//
//  MGMEventTableCell.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

@import UIKit;

@interface MGMEventTableCell : UITableViewCell

@property (readonly) UIActivityIndicatorView* classicAlbumActivityView;
@property (readonly) UIActivityIndicatorView* newlyReleasedAlbumActivityView;
@property (readonly) UIImageView* classicAlbumImageView;
@property (readonly) UIImageView* newlyReleasedAlbumImageView;
@property (readonly) UILabel* eventTextLabel;

@end
