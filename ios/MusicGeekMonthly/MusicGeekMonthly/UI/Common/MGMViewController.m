//
//  MGMViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 23/06/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMViewController.h"

#import "MGMAlbum.h"
#import "MGMAlbumRenderService.h"
#import "MGMAlbumView.h"
#import "MGMCore.h"
#import "MGMImageHelper.h"
#import "MGMUI.h"
#import "UIViewController+MGMAdditions.h"

@interface MGMViewController () <UIPopoverControllerDelegate>

@property (strong) UIPopoverController* iPadPopoverController;

@end

@implementation MGMViewController

- (instancetype)init
{
    if (self = [super init]) {
        _screenScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (BOOL) ipad
{
    return self.ui.ipad;
}

- (void) transitionCompleteWithState:(id)state
{
    // OVERRIDE
}

- (CGRect) fullscreenRect
{
    return [UIScreen mainScreen].bounds;
}

- (void) showError:(NSError*)error
{
    [self.ui showError:error];
}

- (void) logError:(NSError*)error
{
    [self.ui logError:error];
}

- (void) presentViewModally:(UIView*)view sender:(id)sender
{
    if (self.ipad)
    {
        [self presentIpadViewModally:view sender:sender];
    }
    else
    {
        [self presentIphoneViewModally:view sender:sender];
    }
}

- (void) dismissModalPresentation:(UIView *)view
{
    if ([self isPresentingModally:view]) {
        if (self.ipad) {
            [self dismissIpadModalPresentation:view];
        } else {
            [self dismissIphoneModalPresentation:view];
        }
    }
}

- (BOOL) isPresentingModally:(UIView *)view
{
    if (self.ipad)
    {
        return [self isIpadPresentingModally:view];
    }
    else
    {
        return [self isIphonePresentingModally:view];
    }
}

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView completion:(ALBUM_DISPLAY_COMPLETION)completion
{
    [self displayAlbum:album inAlbumView:albumView rank:0 listeners:0 completion:completion];
}

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView rank:(NSUInteger)rank completion:(ALBUM_DISPLAY_COMPLETION)completion
{
    [self displayAlbum:album inAlbumView:albumView rank:rank listeners:0 completion:completion];
}

- (void) displayAlbum:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView rank:(NSUInteger)rank listeners:(NSUInteger)listeners completion:(ALBUM_DISPLAY_COMPLETION)completion
{
    albumView.activityInProgress = YES;
    if (album)
    {
        albumView.artistName = album.artistName;
    }
    else
    {
        albumView.artistName = @"NO ALBUM";
    }
    albumView.albumName = album.albumName;
    albumView.score = [album.score floatValue];
    albumView.rank = rank;
    albumView.listeners = listeners;

    [self.core.albumRenderService refreshAlbum:album completion:^(NSError* refreshError) {
        if (refreshError)
        {
            completion(refreshError);
        }
        [self displayAlbumImage:album inAlbumView:albumView completion:completion];
    }];
}

- (void) displayAlbumImage:(MGMAlbum*)album inAlbumView:(MGMAlbumView*)albumView completion:(ALBUM_DISPLAY_COMPLETION)completion
{
    MGMAlbumImageSize preferredSize = preferredImageSize(albumView.frame.size, self.screenScale);
    NSArray* albumArtUrls = [album bestImageUrlsWithPreferredSize:preferredSize];
    [self displayAlbumImages:albumArtUrls inAlbumView:albumView completion:completion];
}

- (void) displayAlbumImages:(NSArray*)albumArtUrls inAlbumView:(MGMAlbumView*)albumView completion:(ALBUM_DISPLAY_COMPLETION)completion
{
    if (albumView)
    {
        if (albumArtUrls.count > 0)
        {
            [self.ui.imageHelper imageFromUrls:albumArtUrls completion:^(UIImage* image, NSError* imageError) {
                if (imageError)
                {
                    completion(imageError);
                }
                if (image == nil)
                {
                    image = [self.ui.imageHelper nextDefaultImage];
                }
                [self renderImage:image inAlbumView:albumView];
            }];
        }
        else
        {
            [self renderImage:[self.ui.imageHelper nextDefaultImage] inAlbumView:albumView];
        }
    }
}

- (void) renderImage:(UIImage*)image inAlbumView:(MGMAlbumView*)albumView
{
    albumView.activityInProgress = NO;
    [albumView renderImage:image];
}

#pragma mark -
#pragma mark iPad modal presentation

- (void) presentIpadViewModally:(UIView*)view sender:(id)sender
{
    UIViewController* tempVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    tempVC.view = view;
    self.iPadPopoverController = [[UIPopoverController alloc] initWithContentViewController:tempVC];
    self.iPadPopoverController.delegate = self;
    [self.iPadPopoverController presentPopoverFromBarButtonItem:(UIBarButtonItem*)sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void) dismissIpadModalPresentation:(UIView *)view
{
    [self.iPadPopoverController dismissPopoverAnimated:YES];
    [self popoverControllerDidDismissPopover:self.iPadPopoverController];
}

- (BOOL) isIpadPresentingModally:(UIView *)view
{
    return ([self.iPadPopoverController.contentViewController.view isEqual:view]);
}

#pragma mark -
#pragma mark iPhone modal presentation

- (void) presentIphoneViewModally:(UIView*)view sender:(id)sender
{
    UIViewController* tempVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    tempVC.view = view;

    [self presentViewController:tempVC animated:YES completion:NULL];
}

- (void) dismissIphoneModalPresentation:(UIView *)view
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL) isIphonePresentingModally:(UIView *)view
{
    return ([self.presentedViewController.view isEqual:view]);
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate

- (void) popoverControllerDidDismissPopover:(UIPopoverController*)popoverController
{
    self.iPadPopoverController = nil;
}

@end
