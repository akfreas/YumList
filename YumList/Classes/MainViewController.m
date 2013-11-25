#import "MainViewController.h"
#import "ListTableView.h"
#import "HeaderToolbar.h"
#import "AppDelegate.h"
#import <SWRevealViewController.h>
@implementation MainViewController {
    
    HeaderToolbar *toolbar;
    ListTableView *tableViewList;
}

-(id)init {
    self = [super init];
    if (self) {
        self.view.autoresizesSubviews = YES;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)addHeaderToolbar {
    toolbar = [[HeaderToolbar alloc] initWithFrame:CGRectZero];
    toolbar.leftNavigationButtonTappedAction = ^{
        [[AppDelegate sharedRevealController] revealToggleAnimated:YES];
    };
    [self.view addSubview:toolbar];
}

-(void)addTableView {
    
    tableViewList = [[ListTableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tableViewList];
    
    [tableViewList reloadData];
}

-(void)addLayoutConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(tableViewList, toolbar);
    [self.view addConstraintWithVisualFormat:@"V:|-20-[toolbar][tableViewList]|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|[toolbar]|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|[tableViewList]|" bindings:bindings];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTableView];
    [self addHeaderToolbar];
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
