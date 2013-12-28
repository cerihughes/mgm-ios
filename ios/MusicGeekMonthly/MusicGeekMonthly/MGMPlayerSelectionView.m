//
//  MGMPlayerSelectionView.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/11/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMPlayerSelectionView.h"

#define NO_PLAYER_TEXT @"Welcome to the Music Geek Monthly app. Please choose a default app for playing music."
#define DELETED_PLAYER_TEXT @"Your default music player has been removed. Please choose a new default app for playing music."
#define NEW_PLAYERS_TEXT @"New music players detected. Select this from the following if you'd like to make it the default player."

#define CELL_ID @"PLAYER_SELECTION_CELL_ID"

@interface MGMPlayerSelectionViewTableData : NSObject

@property MGMAlbumServiceType serviceType;
@property (strong) NSString* text;
@property (strong) UIImage* image;

@end

@implementation MGMPlayerSelectionViewTableData

@end

@interface MGMPlayerSelectionView () <UITableViewDataSource>

@property (strong) NSMutableArray* tableData;

@property (strong) UINavigationBar* navigationBar;
@property (strong) UIButton* closeButton;
@property (strong) UILabel* titleLabel;
@property (strong) UITableView* tableView;

@end

@implementation MGMPlayerSelectionView
{
    MGMPlayerSelectionMode _mode;
    MGMAlbumServiceType _selectedServiceType;
}

- (void) commonInit
{
    [super commonInit];

    self.backgroundColor = [UIColor whiteColor];

    self.tableData = [NSMutableArray array];

    self.titleLabel = [MGMView boldLabelWithText:@""];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;

    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
}

- (void) commonInitIphone
{
    [super commonInitIphone];

    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:@"Player Selection"];
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButtonPressed:)];
    [navigationItem setRightBarButtonItem:bbi];
    [self.navigationBar pushNavigationItem:navigationItem animated:YES];

    [self addSubview:self.navigationBar];
}

- (void) commonInitIpad
{
    [super commonInitIpad];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.closeButton];
}

- (MGMPlayerSelectionMode) mode
{
    return _mode;
}

- (void) setMode:(MGMPlayerSelectionMode)mode
{
    _mode = mode;

    NSString* text;
    switch (mode)
    {
        case MGMPlayerSelectionModeNone:
        default:
            text = @"";
            break;
        case MGMPlayerSelectionModeNoPlayer:
            text = NO_PLAYER_TEXT;
            break;
        case MGMPlayerSelectionModePlayerRemoved:
            text = DELETED_PLAYER_TEXT;
            break;
        case MGMPlayerSelectionModeNewPlayers:
            text = NEW_PLAYERS_TEXT;
            break;
    }

    self.titleLabel.text = text;
}

- (MGMAlbumServiceType) selectedServiceType
{
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    NSUInteger index = [indexPath indexAtPosition:1];
    if (index != NSNotFound)
    {
        MGMPlayerSelectionViewTableData* tableData = [self.tableData objectAtIndex:index];
        if (tableData)
        {
            return tableData.serviceType;
        }
    }
    return MGMAlbumServiceTypeNone;
}

- (void) setSelectedServiceType:(MGMAlbumServiceType)selectedServiceType
{
    _selectedServiceType = selectedServiceType;
    [self.tableView reloadData];
}

- (void) clearAvailableServiceTypes
{
    self.tableData = [NSMutableArray array];
    [self.tableView reloadData];
}

- (void) addAvailableServiceType:(MGMAlbumServiceType)serviceType text:(NSString *)text image:(UIImage *)image
{
    MGMPlayerSelectionViewTableData* tableData = [[MGMPlayerSelectionViewTableData alloc] init];
    tableData.serviceType = serviceType;
    tableData.text = text;
    tableData.image = image;

    [self.tableData addObject:tableData];
    [self.tableView reloadData];
}

- (void) closeButtonPressed:(UIButton*)sender
{
    [self.delegate playerSelectionComplete];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    CGSize size = self.frame.size;
    CGFloat width = size.width;

    self.titleLabel.frame = CGRectMake(20, 60, width - 40, 60);
}

- (void) layoutSubviewsIphone
{
    [super layoutSubviewsIphone];

    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);

    CGFloat remainingHeight = self.frame.size.height - (65 + 240);
    self.tableView.frame = CGRectMake(0, 65 + 240, 320, remainingHeight);
}

- (void) layoutSubviewsIpad
{
    [super layoutSubviewsIpad];

    self.closeButton.frame = CGRectMake(447, 20, 74, 44);
    self.tableView.frame = CGRectMake(0, 291, 540, 329);
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
        cell.textLabel.font = [UIFont fontWithName:DEFAULT_FONT_MEDIUM size:self.ipad ? 22.0 : 14.0];
    }

    MGMPlayerSelectionViewTableData* tableData = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = tableData.text;
    cell.imageView.image = tableData.image;

    return cell;
}

@end
