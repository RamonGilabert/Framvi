#import "FirstTimeViewController.h"

@interface FirstTimeViewController () <UIScrollViewDelegate>

@property CGFloat deviceWidth;
@property CGFloat deviceHeight;
@property UIScrollView *scrollView;
@property UIPageControl *pageControl;
@property NSMutableArray *arrayOfViewControllers;

@end

@implementation FirstTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.arrayOfViewControllers = [NSMutableArray new];

    for (NSUInteger i = 0; i < 4; i++) {
        [self.arrayOfViewControllers addObject:[NSNull null]];
    }

    self.deviceWidth = [UIScreen mainScreen].bounds.size.width;
    self.deviceHeight = [UIScreen mainScreen].bounds.size.height;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.deviceWidth, self.deviceHeight)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 4, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.deviceHeight - 70, self.deviceWidth, 10)];
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    [self.view addSubview:self.pageControl];

    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= 4) {
        return;
    }

    UIView *viewScrollView = [self.arrayOfViewControllers objectAtIndex:page];

    if ((NSNull *)viewScrollView == [NSNull null]) {
        viewScrollView = [UIView new];
        [self.arrayOfViewControllers replaceObjectAtIndex:page withObject:viewScrollView];
    }

    if (viewScrollView.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        viewScrollView.frame = frame;

        if (page == 0) {
            UILabel *labelFirstView = [[UILabel alloc] initWithFrame:CGRectMake(30, self.deviceHeight - self.deviceHeight/2.3, self.deviceWidth - 60, 100)];
            labelFirstView.textAlignment = NSTextAlignmentCenter;
            labelFirstView.font = [UIFont fontWithName:@"AvenirNext-regular" size:19];
            labelFirstView.text = @"Welcome to Framvi, the best chromeless solution for a web browser.";
            labelFirstView.numberOfLines = 10;
            [viewScrollView addSubview:labelFirstView];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.deviceWidth + self.deviceWidth/3)/4, self.deviceHeight/5, self.deviceWidth/3, self.deviceHeight/4)];
            imageView.image = [UIImage imageNamed:@"First"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [viewScrollView addSubview:imageView];
        } else if (page == 1) {
            UILabel *labelFirstView = [[UILabel alloc] initWithFrame:CGRectMake(30, self.deviceHeight - self.deviceHeight/2.3, self.deviceWidth - 60, 100)];
            labelFirstView.textAlignment = NSTextAlignmentCenter;
            labelFirstView.font = [UIFont fontWithName:@"AvenirNext-regular" size:19];
            labelFirstView.text = @"Use a single long tap, or three simple taps to show the top bar.";
            labelFirstView.numberOfLines = 10;
            [viewScrollView addSubview:labelFirstView];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.deviceWidth + self.deviceWidth/3)/4, self.deviceHeight/5, self.deviceWidth/3, self.deviceHeight/4)];
            imageView.image = [UIImage imageNamed:@"Second"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [viewScrollView addSubview:imageView];
        } else if (page == 2) {
            UILabel *labelFirstView = [[UILabel alloc] initWithFrame:CGRectMake(30, self.deviceHeight - self.deviceHeight/2.3, self.deviceWidth - 60, 100)];
            labelFirstView.textAlignment = NSTextAlignmentCenter;
            labelFirstView.font = [UIFont fontWithName:@"AvenirNext-regular" size:19];
            labelFirstView.text = @"Swipe left and right to go back and forward in your history.";
            labelFirstView.numberOfLines = 10;
            [viewScrollView addSubview:labelFirstView];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.deviceWidth + self.deviceWidth/3)/4, self.deviceHeight/5, self.deviceWidth/3, self.deviceHeight/4)];
            imageView.image = [UIImage imageNamed:@"Third"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [viewScrollView addSubview:imageView];
        } else if (page == 3) {
            UILabel *labelFirstView = [[UILabel alloc] initWithFrame:CGRectMake(30, self.deviceHeight - self.deviceHeight/2.3, self.deviceWidth - 60, 100)];
            labelFirstView.textAlignment = NSTextAlignmentCenter;
            labelFirstView.font = [UIFont fontWithName:@"AvenirNext-regular" size:19];
            labelFirstView.text = @"Edit your preferences, gestures, options.";
            labelFirstView.numberOfLines = 10;
            [viewScrollView addSubview:labelFirstView];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.deviceWidth + self.deviceWidth/3)/4, self.deviceHeight/5, self.deviceWidth/3, self.deviceHeight/4)];
            imageView.image = [UIImage imageNamed:@"Fourth"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [viewScrollView addSubview:imageView];
            UIButton *buttonGoBrowser = [[UIButton alloc] initWithFrame:CGRectMake(self.deviceWidth/4, self.deviceHeight - self.deviceHeight/3.8, self.deviceWidth - self.deviceWidth/2, 50)];
            buttonGoBrowser.backgroundColor = [UIColor colorWithRed:0.73 green:0.27 blue:0.46 alpha:1];
            buttonGoBrowser.layer.cornerRadius = 14;
            [buttonGoBrowser setTitle:@"Start browsing!" forState:UIControlStateNormal];
            [buttonGoBrowser addTarget:self action:@selector(onGoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [viewScrollView addSubview:buttonGoBrowser];
        }

        [self.scrollView addSubview:viewScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

#pragma mark - IBActions

- (IBAction)onGoButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
