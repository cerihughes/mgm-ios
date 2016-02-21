//
//  MGMAlbumScoresViewControllerTestCase.m
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 20/02/16.
//  Copyright © 2016 Ceri Hughes. All rights reserved.
//

#import "MGMSnapshotTestCase.h"

#define MKT_DISABLE_SHORT_SYNTAX
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "MGMAlbum.h"
#import "MGMAlbumRenderService.h"
#import "MGMAlbumScoresViewController.h"
#import "MGMCore.h"
#import "MGMCoreDataAccess.h"
#import "MGMDao.h"
#import "MGMDaoData.h"
#import "MGMDefaultMockContainer.h"
#import "MGMImageHelper.h"
#import "MGMUI.h"
#import "MGMView.h"

@interface MGMAlbumScoresViewControllerTestCase : MGMSnapshotFullscreenDeviceTestCase

@property (nonatomic, strong) MGMUI *ui;
@property (nonatomic, strong) MGMCore *coreMock;
@property (nonatomic, strong) MGMCoreDataAccess *coreDataAccessMock;
@property (nonatomic, strong) MGMDao *daoMock;
@property (nonatomic, strong) MGMAlbumRenderService *albumRenderServiceMock;
@property (nonatomic, strong) MGMImageHelper *imageHelperMock;
@property (nonatomic, strong) MGMAlbumScoresViewController *viewController;

@end

@implementation MGMAlbumScoresViewControllerTestCase

- (void)setUp
{
    [super setUp];

    self.coreMock = [self.mockContainer mockObject:[MGMCore class]];
    self.coreDataAccessMock = [self.mockContainer mockObject:[MGMCoreDataAccess class]];
    self.daoMock = [self.mockContainer mockObject:[MGMDao class]];
    self.albumRenderServiceMock = [self.mockContainer mockObject:[MGMAlbumRenderService class]];
    self.imageHelperMock = [self.mockContainer mockObject:[MGMImageHelper class]];

    [MKTGiven([self.coreMock dao]) willReturn:self.daoMock];
    [MKTGiven([self.coreMock coreDataAccess]) willReturn:self.coreDataAccessMock];
    [MKTGiven([self.coreMock albumRenderService]) willReturn:self.albumRenderServiceMock];

    NSMutableArray *mockMoids = [NSMutableArray array];
    for (int i = 0; i < 50; i++) {
        NSString *artistName = [NSString stringWithFormat:@"Artist%d", i];
        NSString *albumName = [NSString stringWithFormat:@"Album%d", i];
        float scoreAscending = i / 5.0f;
        float scoreDescending = 10.0f - scoreAscending;
        NSManagedObjectID *mockMoid = [self mockMoidForAlbumWithArtistName:artistName albumName:albumName score:scoreDescending];
        [mockMoids addObject:mockMoid];
    }

    MGMDaoData *daoData = [[MGMDaoData alloc] init];
    daoData.data = mockMoids;

    [MKTGivenVoid([self.daoMock fetchAllClassicAlbums:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        DAO_FETCH_COMPLETION completion = args[0];
        completion(daoData);
        return nil;
    }];

    [MKTGivenVoid([self.albumRenderServiceMock refreshAlbum:anything() completion:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        ALBUM_SERVICE_COMPLETION completion = args[1];
        completion(nil);
        return nil;
    }];

    [MKTGivenVoid([self.imageHelperMock imageFromUrls:anything() completion:anything()]) willDo:^id (NSInvocation *invocation){
        NSArray *args = [invocation mkt_arguments];
        NSArray* urls = args[0];
        IMAGE_HELPER_COMPLETION completion = args[1];
        UIImage *image = [self imageOfSize:256 withSeed:urls[0]];
        completion(image, nil);
        return nil;
    }];

    self.ui = [[MGMUI alloc] initWithCore:self.coreMock albumPlayer:nil imageHelper:self.imageHelperMock];
    self.viewController = [[MGMAlbumScoresViewController alloc] init];
    self.viewController.ui = self.ui;
}

- (NSManagedObjectID *)mockMoidForAlbumWithArtistName:(NSString *)artistName
                                            albumName:(NSString *)albumName
                                                score:(float)score
{
    MGMAlbum *album = [self.mockContainer mockObject:[MGMAlbum class]];
    [MKTGiven([album artistName]) willReturn:artistName];
    [MKTGiven([album albumName]) willReturn:albumName];
    [MKTGiven([album score]) willReturn:@(score)];
    [[MKTGiven([album bestImageUrlsWithPreferredSize:0]) withMatcher:anything()] willReturn:@[artistName, albumName]];

    NSManagedObjectID *moid = [self.mockContainer mockObject:[NSManagedObjectID class]];
    [MKTGiven([self.coreDataAccessMock mainThreadVersion:moid]) willReturn:album];

    return moid;
}

- (void)runTestInFrame:(CGRect)frame
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:frame];
    window.rootViewController = self.viewController;
    [window makeKeyAndVisible];

    [self.viewController.view layoutIfNeeded];

    FBSnapshotVerifyView(self.viewController.view, nil);
}

@end
