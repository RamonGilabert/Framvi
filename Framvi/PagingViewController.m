#import "PagingViewController.h"

@interface PagingViewController ()

@end

@implementation PagingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, 300, 300);
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
}

- (id)initWithPageNumber:(NSUInteger)page
{
    if (self = [super initWithNibName:@"PagingView" bundle:nil]) {
        
    }
    return self;
}

@end
