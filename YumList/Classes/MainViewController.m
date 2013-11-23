#import "MainViewController.h"
#import "ListTableView.h"
#import "TestDataGenerator.h"

@implementation MainViewController {
    
    ListTableView *tableViewList;
}

-(id)init {
    self = [super init];
    if (self) {
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    tableViewList = [[ListTableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tableViewList];
    
    [tableViewList reloadData];
}
-(BOOL)shouldAutorotate {
    return YES;
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
