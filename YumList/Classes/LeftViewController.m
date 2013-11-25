#import "LeftViewController.h"
#import "AddYumSourceView.h"
#import "NSFetchedResultsControllerFactory.h"
#import "YumSource.h"
#import "YumSourcesTable.h"


#define AddSourceSection 0
#define SourceListSection 1
@implementation LeftViewController {
    CGFloat addSourceCellHeight;
    NSFetchedResultsController *fetchController;
    NSLayoutConstraint *animatableConstraint;
    AddYumSourceView *addSourceView;
    YumSourcesTable *sourcesTable;
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)addLayoutConstraints {
    
    NSDictionary *bindings = MXDictionaryOfVariableBindings(addSourceView, sourcesTable);
    animatableConstraint = [NSLayoutConstraint constraintWithItem:addSourceView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:50];
    [self.view addConstraint:animatableConstraint];
    [self.view addConstraintWithVisualFormat:@"V:|-20-[addSourceView][sourcesTable]|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|[sourcesTable]|" bindings:bindings];
    [self.view addConstraintWithVisualFormat:@"H:|[addSourceView]|" bindings:bindings];
}

-(void)setupTableView {
    sourcesTable = [[YumSourcesTable alloc] initWithFrame:CGRectZero];
    [self.view addSubview:sourcesTable];
    [sourcesTable reloadData];
}

-(void)setupAddSourceView {
    AddYumSourceView *sourceView = [[AddYumSourceView alloc] initWithFrame:CGRectZero];
    [sourceView setAddSourceButtonTapped:^(CGFloat newSize) {
        [UIView animateWithDuration:1.3f animations:^{
            animatableConstraint.constant = newSize;
        }];
    }];
    [sourceView setExpandAnimationCompleted:^{
        [self.view setNeedsLayout];
    }];
    addSourceView = sourceView;
    [self.view addSubview:addSourceView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self setupAddSourceView];
    [self addLayoutConstraints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
