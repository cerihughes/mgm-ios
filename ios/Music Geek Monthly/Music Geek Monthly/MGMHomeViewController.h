//
//  MGMHomeViewController.h
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 04/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMViewController.h"


typedef enum
{
    MGMHomeViewControllerOptionPreviousEvents,
    MGMHomeViewControllerOptionNextEvent,
    MGMHomeViewControllerOptionCharts
}
MGMHomeViewControllerOption;

@protocol MGMHomeViewControllerDelegate <NSObject>

- (void) optionSelected:(MGMHomeViewControllerOption)option;

@end

@interface MGMHomeViewController : MGMViewController

@property (weak) id<MGMHomeViewControllerDelegate> delegate;

@end
