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
@property NSTimer *timerSelector;

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

    self.webView.scalesPageToFit = YES;
    self.webView.allowsInlineMediaPlayback = YES;

    self.timerSelector = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(checkIfFramerIsOpened:) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self checkIfFramerIsOpened:0];
}

- (void)checkIfFramerIsOpened:(NSTimer *)timer
{
    if ([self isValidURL:[NSURL URLWithString:@"http://192.168.1.130:8000"]]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Framer active" message:@"It appears that FramerJS is opened, do you want to test your prototype?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOpen = [UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.130:8000/"]];
            [self.webView loadRequest:requestURL];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *alertActionClose = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];

        [alertController addAction:alertActionOpen];
        [alertController addAction:alertActionClose];

        [self presentViewController:alertController animated:YES completion:nil];

        [self.timerSelector invalidate];
    }
}

- (BOOL)isValidURL:(NSURL *)usedURL
{
    NSURLRequest *requestFramer = [NSURLRequest requestWithURL:usedURL];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:requestFramer returningResponse:&response error:&error];
    if (error || response.statusCode == 404) {
        return false;
    } else {
        return true;
    }
}

@end
