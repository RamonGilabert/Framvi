#import "FirstTimeViewController.h"
#import "PagingViewController.h"

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
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;

    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
//    if (page >= self.contentList.count)
//        return;

    PagingViewController *controller = [self.arrayOfViewControllers objectAtIndex:page];

    if ((NSNull *)controller == [NSNull null]) {
        controller = [[PagingViewController alloc] initWithPageNumber:page];
        [self.arrayOfViewControllers replaceObjectAtIndex:page withObject:controller];
    }

    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;

        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
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
