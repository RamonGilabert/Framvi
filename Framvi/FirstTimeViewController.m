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
            viewScrollView.backgroundColor = [UIColor blueColor];
        } else if (page == 1) {
            viewScrollView.backgroundColor = [UIColor blackColor];
        } else if (page == 2) {
            viewScrollView.backgroundColor = [UIColor redColor];
        } else if (page == 3) {
            viewScrollView.backgroundColor = [UIColor yellowColor];
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

@end
