#import "MainViewController.h"
#import "YumListTableView.h"
#import "AppDelegate.h"
#import <SWRevealViewController.h>
#import "YumSource.h"
#import "SourceManager.h"
#import "YumDetailViewViewController.h"


@implementation MainViewController {
    YumListTableView *tableViewList;
}

-(id)init {
    self = [super init];
    if (self) {
        self.view.autoresizesSubviews = YES;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)configureNavigationBar {
    UIImage *barImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"256-box2" ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:barImage style:UIBarButtonItemStylePlain handler:^(id sender) {
        [[AppDelegate sharedRevealController] revealToggleAnimated:YES];
    }];
    YumSource *currentSource = [SourceManager currentYumSource];
    if (currentSource != nil) {
        self.title = currentSource.name;
    }
    [SourceManager addYumSourceChangedAction:^(YumSource *changedSource) {
        self.title = changedSource.name;
    }];
}

-(void)addTableView {
    
    YumListTableView *ourTableViewList = [[YumListTableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:ourTableViewList];
    ourTableViewList.yumItemSelected = ^(YumItem *selectedItem){
        YumDetailViewViewController *detailController = [[YumDetailViewViewController alloc] initWithYumItem:selectedItem];
        [self.navigationController pushViewController:detailController animated:YES];
    };
    [ourTableViewList reloadData];
    tableViewList = ourTableViewList;
}

-(void)addLayoutConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(tableViewList);
    [self.view addConstraintWithVisualFormat:@"V:|[tableViewList]|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|[tableViewList]|" bindings:bindings];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self addTableView];
    [self configureNavigationBar];
    
    [self addLayoutConstraints];
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
