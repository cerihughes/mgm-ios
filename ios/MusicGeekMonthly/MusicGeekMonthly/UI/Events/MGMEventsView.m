//
//  MGMEventsView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 03/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMEventsView.h"

#import "MGMAlbumView.h"
#import "MGMAlbumGridView.h"
#import "NSLayoutConstraint+MGM.h"

@interface MGMEventsView ()

@property (nonatomic, readonly) UIScrollView *parentView;
@property (nonatomic, readonly) UIView *leftGuideView;
@property (nonatomic, readonly) UIView *rightGuideView;
@property (nonatomic, readonly) UINavigationBar *navigationBar;
@property (nonatomic, readonly) UINavigationItem *navigationItem;

@end

@implementation MGMEventsView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        _navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"More..." style:UIBarButtonItemStyleBordered target:self action:@selector(moreButtonPressed:)];
        [_navigationItem setRightBarButtonItem:bbi];
        [_navigationBar pushNavigationItem:_navigationItem animated:YES];

        _leftGuideView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftGuideView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightGuideView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightGuideView.translatesAutoresizingMaskIntoConstraints = NO;

        _parentView = [[UIScrollView alloc] initWithFrame:frame];
        _parentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_parentView addSubview:self.classicAlbumLabel];
        [_parentView addSubview:self.classicAlbumView];
        [_parentView addSubview:self.newlyReleasedAlbumLabel];
        [_parentView addSubview:self.newlyReleasedAlbumView];
        [_parentView addSubview:self.playlistLabel];
        [_parentView addSubview:self.playlistView];

        [self addSubview:_leftGuideView];
        [self addSubview:_rightGuideView];
        [self addSubview:_parentView];
        [self addSubview:_navigationBar];
    }
    return self;
}

- (void) setTitle:(NSString*)title
{
    self.navigationItem.title = title;
}

- (void) moreButtonPressed:(id)sender
{
    [self.delegate moreButtonPressed:sender];
}

- (void)addFixedConstraints
{
    [super addFixedConstraints];

    NSMutableArray<__kindof NSLayoutConstraint *> *constraints = [NSMutableArray array];

    // Self
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherViewToSuperview:self]];

    // Navigation bar
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherNavigationBar:self.navigationBar toSuperview:self]];

    // Parent view
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsThatTetherView:self.parentView belowNavigationBar:self.navigationBar superview:self]];

    // Guide views
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.leftGuideView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.leftGuideView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.5
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.leftGuideView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.leftGuideView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rightGuideView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rightGuideView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.5
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rightGuideView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.rightGuideView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0]];

    // Classic album label
    CGFloat labelOffset = mgm_isIpad() ? 45 : 25;
    CGFloat labelHeight = mgm_isIpad() ? 30 : 21;
    CGFloat labelWidth = mgm_isIpad() ? 196 : 160;

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.navigationBar
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:labelOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:labelHeight]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:labelWidth]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.leftGuideView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    // Newly released album label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:labelWidth]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.rightGuideView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    // Classic album view
    CGFloat albumOffset = 10;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.classicAlbumLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:albumOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.classicAlbumView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.classicAlbumView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    // Newly released album view
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.newlyReleasedAlbumLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.newlyReleasedAlbumLabel
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.newlyReleasedAlbumLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:albumOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.newlyReleasedAlbumView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.newlyReleasedAlbumView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    // Playlist label
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.classicAlbumView
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:labelOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistLabel
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1
                                                         constant:labelHeight]];

    // Playlist view
    CGFloat  playlistViewSize = mgm_isIpad() ? 528 : 220;
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:playlistViewSize]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.playlistLabel
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:albumOffset]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.playlistView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.playlistView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1
                                                         constant:0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end

@implementation MGMEventsViewPhone

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    // Need to create a contentRect that's got space to scroll over the tab bar...
//    UIView* lastView = self.newlyReleasedAlbumView;
//    if (self.playlistLabel.hidden == NO)
//    {
//        lastView = self.playlistView;
//    }
//
//    CGRect contentRect = CGRectUnion(self.frame, lastView.frame);
//    CGFloat offset = self.tabBarHeight / 4.0;
//    contentRect = CGRectInset(contentRect, 0, -offset);
//    contentRect = CGRectOffset(contentRect, 0, offset);
//
//    self.parentView.contentSize = contentRect.size;
//}

@end

@implementation MGMEventsViewPad

@end
