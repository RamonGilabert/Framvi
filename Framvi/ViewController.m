//
//  ViewController.m
//  Framvi
//
//  Created by Ramon Gilabert Llop on 2/23/15.
//  Copyright (c) 2015 Ramon Gilabert. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate>

@property CGFloat deviceWidth;
@property CGFloat deviceHeight;
@property UIWebView *webView;
@property NSTimer *timerSelector;
@property BOOL isFramerOpenedAlready;
@property CGFloat valueOfTimer;
@property UIAlertController *alertControllerOpenFramer;
@property UIView *viewContainerTextField;
@property UITextField *textFieldEnterAddress;
@property UIButton *buttonCancelText;
@property UIButton *buttonRefresh;
@property UIButton *buttonCancel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.isFramerOpenedAlready = NO;

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.deviceWidth, self.deviceHeight)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ramongilabert.com"]];
    [self.webView loadRequest:requestURL];

    self.webView.scalesPageToFit = YES;
    self.webView.allowsInlineMediaPlayback = YES;

    self.viewContainerTextField = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.deviceWidth, 50)];
    self.viewContainerTextField.backgroundColor = [UIColor whiteColor];
    self.textFieldEnterAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.deviceWidth - 20, 30)];
    self.textFieldEnterAddress.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    self.textFieldEnterAddress.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldEnterAddress.delegate = self;

    self.buttonCancelText = [[UIButton alloc] initWithFrame:CGRectMake(self.textFieldEnterAddress.frame.origin.x + self.textFieldEnterAddress.frame.size.width, 10, 100, self.textFieldEnterAddress.frame.size.height)];
    [self.buttonCancelText setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.buttonCancelText setTitleColor:[UIColor colorWithRed:0.04 green:0.42 blue:0.94 alpha:1] forState:UIControlStateNormal];

    [self.viewContainerTextField addSubview:self.buttonCancelText];
    [self.viewContainerTextField addSubview:self.textFieldEnterAddress];
    [self.view addSubview:self.viewContainerTextField];

    self.valueOfTimer = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self checkFramer:0];

    self.alertControllerOpenFramer = [UIAlertController alertControllerWithTitle:@"Framer active" message:@"It appears that FramerJS is opened, do you want to test your prototype?" preferredStyle:UIAlertControllerStyleAlert];

    self.timerSelector = [NSTimer scheduledTimerWithTimeInterval:self.valueOfTimer target:self selector:@selector(checkFramer:) userInfo:nil repeats:YES];
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 delay:0 options:0 animations:^{
        self.textFieldEnterAddress.frame = CGRectMake(self.textFieldEnterAddress.frame.origin.x, self.textFieldEnterAddress.frame.origin.y, self.deviceWidth - 85, 30);
        self.buttonCancelText.frame = CGRectMake(self.buttonCancelText.frame.origin.x - 77.5, self.buttonCancelText.frame.origin.y, self.buttonCancelText.frame.size.width, self.buttonCancelText.frame.size.height);
    } completion:^(BOOL finished) {

    }];
    return YES;
}

#pragma mark - IBActions

- (IBAction)onCancelTextButtonPressed:(UIButton *)sender
{

}

- (IBAction)onRefreshButtonPressed:(UIButton *)sender
{

}

- (IBAction)onCancelButtonPressed:(UIButton *)sender
{

}

#pragma mark - Helper methods

- (void)checkFramer:(NSTimer *)timer
{
    BOOL isAValidURL = [self isValidURL:[NSURL URLWithString:@"http://192.168.1.130:8000"]];

    if (!self.isFramerOpenedAlready && isAValidURL && timer) {
        self.valueOfTimer = 100;
        UIAlertAction *alertActionOpen = [UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.130:8000/"]];
            [self.webView loadRequest:requestURL];
            [self.alertControllerOpenFramer dismissViewControllerAnimated:YES completion:nil];
            self.valueOfTimer = 10;
            self.isFramerOpenedAlready = YES;
        }];
        UIAlertAction *alertActionClose = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.alertControllerOpenFramer dismissViewControllerAnimated:YES completion:nil];
            self.valueOfTimer = 1;
            self.isFramerOpenedAlready = NO;
        }];

        [self.alertControllerOpenFramer addAction:alertActionOpen];
        [self.alertControllerOpenFramer addAction:alertActionClose];

        if (![self.alertControllerOpenFramer isFirstResponder]) {
            [self presentViewController:self.alertControllerOpenFramer animated:YES completion:nil];
        }
    } else if (!self.isFramerOpenedAlready && isAValidURL && !timer) {
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.130:8000/"]];
        [self.webView loadRequest:requestURL];
        self.valueOfTimer = 10;
        self.isFramerOpenedAlready = YES;
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
