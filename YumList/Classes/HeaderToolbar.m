#import "HeaderToolbar.h"
#import "SourceManager.h"
#import "YumSource.h"

@implementation HeaderToolbar {
    UIBarButtonItem *leftNavigationButton;
    UILabel *titleLabel;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.barTintColor = [UIColor whiteColor];
        self.translucent = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addTitleLabelAndConstraints];
        [SourceManager addYumSourceChangedAction:^(YumSource *newSource) {
            titleLabel.text = newSource.name;
        }];
    }
    return self;
}

-(void)addTitleLabelAndConstraints {
    
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Add Some Yums!";
        titleLabel.textColor = [UIColor blackColor];
        [self addConstraintWithVisualFormat:@"H:[titleLabel(250)]" bindings:MXDictionaryOfVariableBindings(titleLabel)];
        [self addConstraintWithVisualFormat:@"V:|[titleLabel(40)]" bindings:MXDictionaryOfVariableBindings(titleLabel)];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    }
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

@end
