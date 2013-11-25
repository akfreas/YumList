#import "HeaderToolbar.h"

@implementation HeaderToolbar {
    UIBarButtonItem *leftNavigationButton;
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
