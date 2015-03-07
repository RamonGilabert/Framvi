#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

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
@property UIImageView *imageRefreshingButton;
@property UILongPressGestureRecognizer *longTouchGestureRecognizer;
@property int yPositionTextField;
@property UIVisualEffect *blurrEffect;
@property UIVisualEffectView *blurrViewBar;
@property UITapGestureRecognizer *tapGestureBlurrEffect;
@property UITapGestureRecognizer *tapGestureThreeFingers;
@property UIProgressView *progressBar;
@property BOOL controllerOneTime;
@property NSTimer *timerProgressBar;
@property BOOL valueProgressBar;
@property NSMutableArray *arrayOfWebsitesVisited;
@property NSMutableArray *arrayOfSnapshots;
@property int websitesVisited;
@property UISwipeGestureRecognizer *tapGestureGoBack;
@property UISwipeGestureRecognizer *tapGestureGoForward;
@property NSString *stringFramerURL;

#define FIRST_WEBSITE @"http://ramongilabert.com"

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

    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:FIRST_WEBSITE]];
    [self.webView loadRequest:requestURL];

    self.webView.scalesPageToFit = YES;
    self.webView.allowsInlineMediaPlayback = YES;

    UIImage *imageRefreshingButton = [UIImage imageNamed:@"cross-image"];
    self.imageRefreshingButton = [UIImageView new];
    self.imageRefreshingButton.image = [imageRefreshingButton imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    self.blurrEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurrViewBar = [[UIVisualEffectView alloc] initWithEffect:self.blurrEffect];
    self.blurrViewBar.frame = CGRectMake(0, 0, self.deviceWidth, self.deviceHeight);
    self.blurrViewBar.alpha = 1;
    [self.view addSubview:self.blurrViewBar];

    self.viewContainerTextField = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.deviceWidth, 50)];
    self.viewContainerTextField.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    self.textFieldEnterAddress = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.deviceWidth - 20, 30)];
    self.textFieldEnterAddress.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
    self.textFieldEnterAddress.borderStyle = UITextBorderStyleRoundedRect;
    self.textFieldEnterAddress.delegate = self;
    self.textFieldEnterAddress.keyboardAppearance = UIKeyboardAppearanceDark;
    self.textFieldEnterAddress.tintColor = [UIColor whiteColor];
    self.textFieldEnterAddress.textColor = [UIColor whiteColor];
    self.textFieldEnterAddress.keyboardType = UIKeyboardTypeURL;

    self.buttonCancelText = [[UIButton alloc] initWithFrame:CGRectMake(self.textFieldEnterAddress.frame.origin.x + self.textFieldEnterAddress.frame.size.width, 10, 100, self.textFieldEnterAddress.frame.size.height)];
    [self.buttonCancelText addTarget:self action:@selector(onCancelTextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonCancelText setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.buttonCancelText setTitleColor:[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1] forState:UIControlStateNormal];

    self.buttonRefresh = [self.textFieldEnterAddress valueForKey:@"_clearButton"];
    [self.buttonRefresh setImage:self.imageRefreshingButton.image forState:UIControlStateNormal];
    [self.buttonRefresh setImage:self.imageRefreshingButton.image forState:UIControlStateHighlighted];
    self.buttonRefresh.tintColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.32 alpha:1];

    self.textFieldEnterAddress.clearButtonMode = UITextFieldViewModeAlways;
    [self.viewContainerTextField addSubview:self.buttonCancelText];
    [self.viewContainerTextField addSubview:self.textFieldEnterAddress];
    [self.view addSubview:self.viewContainerTextField];

    self.longTouchGestureRecognizer = [UILongPressGestureRecognizer new];
    self.longTouchGestureRecognizer.minimumPressDuration = 0.1;
    [self.longTouchGestureRecognizer addTarget:self action:@selector(longPressGestureRecognizer:)];
    self.longTouchGestureRecognizer.delegate = self;
    [self.webView addGestureRecognizer:self.longTouchGestureRecognizer];

    self.tapGestureBlurrEffect = [UITapGestureRecognizer new];
    self.tapGestureBlurrEffect.numberOfTapsRequired = 1;
    [self.tapGestureBlurrEffect addTarget:self action:@selector(tapGestureBlurrEffect:)];
    [self.blurrViewBar addGestureRecognizer:self.tapGestureBlurrEffect];

    self.tapGestureThreeFingers = [UITapGestureRecognizer new];
    self.tapGestureThreeFingers.numberOfTouchesRequired = 3;
    self.tapGestureThreeFingers.numberOfTapsRequired = 1;
    self.tapGestureThreeFingers.delegate = self;
    [self.tapGestureThreeFingers addTarget:self action:@selector(tapGestureRecognizerThreeFingers:)];
    [self.webView addGestureRecognizer:self.tapGestureThreeFingers];

    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressBar.frame = CGRectMake(0, 0, self.deviceWidth, 10);
    self.progressBar.progress = 0;
    self.progressBar.progressTintColor = [UIColor colorWithRed:0.69 green:0.25 blue:0.38 alpha:1];

    [self.view addSubview:self.progressBar];

    self.yPositionTextField = -50;
    self.controllerOneTime = NO;

    self.arrayOfWebsitesVisited = [NSMutableArray new];
    self.arrayOfSnapshots = [NSMutableArray new];
    self.websitesVisited = 0;

    self.tapGestureGoBack = [UISwipeGestureRecognizer new];
    self.tapGestureGoBack.direction = UISwipeGestureRecognizerDirectionLeft;
    self.tapGestureGoBack.delegate = self;
    [self.tapGestureThreeFingers addTarget:self action:@selector(tapGestureGoBack:)];
    [self.webView addGestureRecognizer:self.tapGestureGoBack];

    self.tapGestureGoForward = [UISwipeGestureRecognizer new];
    self.tapGestureGoForward.delegate = self;
    [self.tapGestureThreeFingers addTarget:self action:@selector(tapGestureGoForward:)];
    [self.webView addGestureRecognizer:self.tapGestureGoForward];

    self.valueOfTimer = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"goFirstTimeInApp" sender:self];
    } else {
        NSString *stringOfLocalHost = [self getIPAddress];
        self.stringFramerURL = [[@"http://" stringByAppendingString:stringOfLocalHost] stringByAppendingString:@":8000/"];

        [self checkFramer:0];

        [self.textFieldEnterAddress becomeFirstResponder];

        self.alertControllerOpenFramer = [UIAlertController alertControllerWithTitle:@"Framer active" message:@"It appears that FramerJS is opened, do you want to test your prototype?" preferredStyle:UIAlertControllerStyleAlert];

        self.timerSelector = [NSTimer scheduledTimerWithTimeInterval:self.valueOfTimer target:self selector:@selector(checkFramer:) userInfo:nil repeats:YES];
    }
}

#pragma mark - Gesture recognizers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapGestureBlurrEffect:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self textFieldDisappear];
}

- (void)tapGestureRecognizerThreeFingers:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        self.viewContainerTextField.frame = CGRectMake(0, 0, self.deviceWidth, 50);
        self.webView.frame = CGRectMake(0, 50, self.deviceWidth, self.deviceHeight + (50 - self.yPositionTextField));
        [self.textFieldEnterAddress becomeFirstResponder];
        self.yPositionTextField = -50;
        self.blurrViewBar.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    self.webView.userInteractionEnabled = NO;

    if (self.yPositionTextField > -25 && longPressGestureRecognizer.state == UIGestureRecognizerStateEnded && !self.controllerOneTime) {
        self.controllerOneTime = YES;
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            self.viewContainerTextField.frame = CGRectMake(0, 0, self.deviceWidth, 50);
            self.webView.frame = CGRectMake(0, 50, self.deviceWidth, self.deviceHeight + (50 - self.yPositionTextField));
            [self.textFieldEnterAddress becomeFirstResponder];
            self.yPositionTextField = -50;
            self.blurrViewBar.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            self.viewContainerTextField.frame = CGRectMake(0, -50, self.deviceWidth, 50);
            self.webView.frame = CGRectMake(0, 0, self.deviceWidth, self.deviceHeight + (50 - self.yPositionTextField));
            self.yPositionTextField = -50;
            self.blurrViewBar.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    } else if (self.yPositionTextField < 0) {
        self.blurrViewBar.alpha = (CGFloat)(50  + self.yPositionTextField) / 50;
        self.viewContainerTextField.frame = CGRectMake(0, self.yPositionTextField, self.deviceWidth, 50);
        self.webView.frame = CGRectMake(0, 50 + self.yPositionTextField, self.deviceWidth, self.deviceHeight + (50 - self.yPositionTextField));
        self.yPositionTextField = self.yPositionTextField + 1.5;
    }

    if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.webView.userInteractionEnabled = YES;
        [self.longTouchGestureRecognizer addTarget:self action:@selector(longPressGestureRecognizer:)];
    }
}

- (void)tapGestureGoBack:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint location = [swipeGestureRecognizer locationInView:self.webView];
    NSLog(@"%f", location.x);
    if ([self.webView canGoBack] && location.x < 20) {

    }
}

- (void)tapGestureGoForward:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGPoint location = [swipeGestureRecognizer locationInView:self.webView];

    if ([self.webView canGoForward] && location.x > self.deviceWidth - 20) {

    }
}

#pragma mark - WebView methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.progressBar.progress = 0;
    self.progressBar.hidden = NO;
    self.valueProgressBar = NO;
    self.timerProgressBar = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerWebViewProgress) userInfo:nil repeats:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.progressBar.progress = 0;
    self.progressBar.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.valueProgressBar = YES;
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

#pragma mark - UIWebViewProgress

- (void)timerWebViewProgress
{
    if (self.valueProgressBar) {
        if (self.progressBar.progress >= 1) {
            self.progressBar.hidden = YES;
            [self.timerProgressBar invalidate];
        }
        else {
            self.progressBar.progress = self.progressBar.progress + 0.01;
        }
    }
    else {
        self.progressBar.progress = self.progressBar.progress + 0.005;
        if (self.progressBar.progress >= 0.95) {
            self.progressBar.progress = 0.95;
        }
    }
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.textFieldEnterAddress.frame.size.width != self.deviceWidth - 85) {
        [UIView animateWithDuration:0.4 delay:0 options:0 animations:^{
            self.textFieldEnterAddress.frame = CGRectMake(self.textFieldEnterAddress.frame.origin.x, self.textFieldEnterAddress.frame.origin.y, self.deviceWidth - 85, 30);
            self.buttonRefresh.frame = CGRectMake(self.buttonRefresh.frame.origin.x - 65, self.buttonRefresh.frame.origin.y, self.buttonRefresh.frame.size.width, self.buttonRefresh.frame.size.height);
            self.buttonCancelText.frame = CGRectMake(self.buttonCancelText.frame.origin.x - 77.5, self.buttonCancelText.frame.origin.y, self.buttonCancelText.frame.size.width, self.buttonCancelText.frame.size.height);
            [self.textFieldEnterAddress setSelected:YES];
        } completion:^(BOOL finished) {
            self.controllerOneTime = NO;
        }];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"Framer"] || [textField.text isEqualToString:@"framer"] || [textField.text isEqualToString:@"Test prototype"]) {
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.stringFramerURL]];
        [self.webView loadRequest:requestURL];
        self.isFramerOpenedAlready = YES;
        [self.textFieldEnterAddress resignFirstResponder];
        [self textFieldDisappear];
        [self.timerSelector invalidate];
    } else if ([self.textFieldEnterAddress.text rangeOfString:@"http://"].location == NSNotFound && [self.textFieldEnterAddress.text rangeOfString:@"https://"].location != NSNotFound) {
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.textFieldEnterAddress.text]];
        [self.webView loadRequest:requestURL];
    } else if ([self.textFieldEnterAddress.text rangeOfString:@"http://"].location != NSNotFound && [self.textFieldEnterAddress.text rangeOfString:@"https://"].location == NSNotFound) {
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.textFieldEnterAddress.text]];
        [self.webView loadRequest:requestURL];
    } else if ([self.textFieldEnterAddress.text rangeOfString:@"http://"].location == NSNotFound) {
        NSString *stringToLookFor = [NSString stringWithFormat:@"http://%@", self.textFieldEnterAddress.text];
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:stringToLookFor]];
        [self.webView loadRequest:requestURL];
    } else {
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.textFieldEnterAddress.text]];
        [self.webView loadRequest:requestURL];
    }

    [self textFieldDisappear];

    return YES;
}

#pragma mark - IBActions

- (IBAction)onCancelTextButtonPressed:(UIButton *)sender
{
    [self textFieldDisappear];
}

#pragma mark - Helper methods

- (void)textFieldDisappear
{
    [UIView animateWithDuration:0.4 delay:0 options:0 animations:^{
        self.textFieldEnterAddress.frame = CGRectMake(self.textFieldEnterAddress.frame.origin.x, self.textFieldEnterAddress.frame.origin.y, self.deviceWidth - 20, 30);
        self.buttonRefresh.frame = CGRectMake(self.buttonRefresh.frame.origin.x + 65, self.buttonRefresh.frame.origin.y, self.buttonRefresh.frame.size.width, self.buttonRefresh.frame.size.height);
        self.buttonCancelText.frame = CGRectMake(self.buttonCancelText.frame.origin.x + 77.5, self.buttonCancelText.frame.origin.y, self.buttonCancelText.frame.size.width, self.buttonCancelText.frame.size.height);
        self.blurrViewBar.alpha = 0;
        [self.textFieldEnterAddress resignFirstResponder];
        self.viewContainerTextField.frame = CGRectMake(0, -50, self.deviceWidth, 50);
        self.webView.frame = CGRectMake(0, 0, self.deviceWidth, self.deviceHeight + (50 - self.yPositionTextField));
    } completion:^(BOOL finished) {
    }];
}

- (void)checkFramer:(NSTimer *)timer
{
    NSURL *usedURL = [NSURL URLWithString:self.stringFramerURL];

    NSURLRequest *requestFramer = [NSURLRequest requestWithURL:usedURL];
    [NSURLConnection sendAsynchronousRequest:requestFramer queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {

        } else {
            if (!self.isFramerOpenedAlready && timer) {
                [self.timerSelector invalidate];
                UIAlertAction *alertActionOpen = [UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.stringFramerURL]];
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

                [self.textFieldEnterAddress resignFirstResponder];
                [self textFieldDisappear];
                [self.timerSelector invalidate];
            } else if (!self.isFramerOpenedAlready && !timer) {
                NSURLRequest *requestURL = [NSURLRequest requestWithURL:[NSURL URLWithString:self.stringFramerURL]];
                [self.webView loadRequest:requestURL];
                self.valueOfTimer = 10;
                self.isFramerOpenedAlready = YES;
                [self.textFieldEnterAddress resignFirstResponder];
                [self textFieldDisappear];
                [self.timerSelector invalidate];
            }
        }
    }];
}

#pragma mark - Helper methods v.2

- (NSString *)getIPAddress {

    NSString *address = @"error";
    struct ifaddrs *interfaces = nil;
    struct ifaddrs *temp_addr = nil;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];

                }

            }
            temp_addr = temp_addr -> ifa_next;
        }
    }

    freeifaddrs(interfaces);
    return address;
}

@end
