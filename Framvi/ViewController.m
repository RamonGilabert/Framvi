//
//  ViewController.m
//  Framvi
//
//  Created by Ramon Gilabert Llop on 2/23/15.
//  Copyright (c) 2015 Ramon Gilabert. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>

@property CGFloat deviceWidth;
@property CGFloat deviceHeight;
@property UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.deviceWidth, self.deviceHeight)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ramongilabert.com"]];
    [self.webView loadRequest:requestURL];
}

@end
