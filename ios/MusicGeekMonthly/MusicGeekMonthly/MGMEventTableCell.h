//
//  MGMEventTableCell.h
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 18/08/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMEventTableCell : UITableViewCell

@property (strong) IBOutlet UIImageView* classicAlbumImageView;
@property (strong) IBOutlet UIImageView* newlyReleasedAlbumImageView;
@property (strong) IBOutlet UILabel* eventTextLabel;

@end
