#import "HeaderToolbar.h"

@implementation HeaderToolbar {
    UIBarButtonItem *leftNavigationButton;
    UIBarButtonItem *rightNavigationButton;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.barTintColor = [UIColor whiteColor];
        self.translucent = NO;
    }
    return self;
}

-(void)setRightNavigationButtonTappedAction:(void (^)())rightNavigationButtonTappedAction {
    _rightNavigationButtonTappedAction = rightNavigationButtonTappedAction;
    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:self.items];
    if (rightNavigationButton != nil) {
        [itemArray removeObject:rightNavigationButton];
    }
    rightNavigationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        _rightNavigationButtonTappedAction();
    }];
    [itemArray addObject:rightNavigationButton];
    self.items = [NSArray arrayWithArray:itemArray];
}

-(void)setLeftNavigationButtonTappedAction:(void (^)())leftNavigationButtonTappedAction {
    _leftNavigationButtonTappedAction = leftNavigationButtonTappedAction;
    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:self.items];
    if (leftNavigationButton != nil) {
        [itemArray removeObject:leftNavigationButton];
    }
    leftNavigationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction handler:^(id sender) {
        _leftNavigationButtonTappedAction();
    }];
    [itemArray addObject:leftNavigationButton];
    self.items = [NSArray arrayWithArray:itemArray];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    NSMutableArray *itemArray = [NSMutableArray arrayWithArray:self.items];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace handler:NULL];
    [itemArray insertObject:item atIndex:1];
    self.items = [NSArray arrayWithArray:itemArray];
}

@end
