//
//  MGMWebViewController.m
//  Music Geek Monthly
//
//  Created by Ceri Hughes on 22/07/2013.
//  Copyright (c) 2013 Ceri Hughes. All rights reserved.
//

#import "MGMWebViewController.h"

@interface MGMWebViewController ()

@property (strong) IBOutlet UIWebView* webView;

@end

@implementation MGMWebViewController

- (id) init
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
    }
    return self;
}

- (void) transitionCompleteWithState:(id)state
{
    NSURL* url = [NSURL URLWithString:state];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
