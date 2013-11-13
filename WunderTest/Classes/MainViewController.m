#import "MainViewController.h"
#import "ListTableView.h"
#import "TestDataGenerator.h"

@implementation MainViewController {
    
    ListTableView *tableViewList;
}

-(id)init {
    self = [super init];
    if (self) {
        [TestDataGenerator generateTestListItemDataWithCount:10];
    }
    return self;
}

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 560)];
//    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableViewList = [[ListTableView alloc] initWithFrame:self.view.frame];

    [self.view addSubview:tableViewList];
    [tableViewList reloadData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
