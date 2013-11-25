#import "AddYumSourceCell.h"
#import "AddYumSourceSheet.h"
#import "YumSource.h"

@implementation AddYumSourceCell {
    UIButton *addSourceButton;
    AddYumSourceSheet *addSourceSheet;
    NSArray *constraintsAddedToFitAddSourceSheet;
    NSLayoutConstraint *animatableAddSheetConstraint;
}

static CGFloat collapsedSize = 44;
static CGFloat expandedSize = 250;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addAddSourceButton];
    }
    return self;
}

-(CGSize)intrinsicContentSize {
    return CGSizeMake(320, 44);
}

-(void)addAddSourceButton {
    addSourceButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [addSourceButton setTitle:NSLocalizedString(@"Add Source", @"Add source button.") forState:UIControlStateNormal];
    [self addSubview:addSourceButton];
    [self addConstraintWithVisualFormat:@"H:|-20-[addSourceButton]" bindings:MXDictionaryOfVariableBindings(addSourceButton)];
    [self addConstraintWithVisualFormat:@"V:|-5-[addSourceButton]" bindings:MXDictionaryOfVariableBindings(addSourceButton)];
    [addSourceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addSourceButton addEventHandler:[self addSourceButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
}

-(void(^)(id sender))addSourceButtonEventHandler {
    return ^(id sender) {
        if (self.addSourceButtonTapped != NULL) {
        }
        if (addSourceSheet == nil) {
            [self addSourceSheet];
        } else {
            [self removeSourceSheet];
        }
    };
}

-(void(^)())newSourceAddedHandler {
    return ^(YumSource *newSource) {
        [self removeSourceSheet];
    };
}

-(void)addSourceSheet {
    if (addSourceSheet == nil) {
        addSourceSheet = [[AddYumSourceSheet alloc] initWithFrame:CGRectZero];
        addSourceSheet.newSourceAdded = [self newSourceAddedHandler];
    }
    [self addSubview:addSourceSheet];
    constraintsAddedToFitAddSourceSheet = [self addConstraintWithVisualFormat:@"V:|-5-[addSourceButton][addSourceSheet(0)]|" bindings:MXDictionaryOfVariableBindings(addSourceButton, addSourceSheet)];
    [self addConstraintWithVisualFormat:@"H:|[addSourceSheet(260)]|" bindings:MXDictionaryOfVariableBindings(addSourceSheet)];
    NSInteger animatableIndex = [constraintsAddedToFitAddSourceSheet indexOfObjectPassingTest:^BOOL(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == addSourceSheet && constraint.secondItem == nil) {
            return YES;
        } else {
            return NO;
        }
    }];
    [self layoutIfNeeded];
    animatableAddSheetConstraint = constraintsAddedToFitAddSourceSheet[animatableIndex];
    self.addSourceButtonTapped(expandedSize);
    [UIView animateWithDuration:0.3f animations:^{
        animatableAddSheetConstraint.constant = expandedSize - 44;
        [self layoutIfNeeded];
        self.expandAnimationCompleted();
    } completion:^(BOOL finished) {
        [addSourceSheet finishExpandAnimation];
    }];
}

-(void)removeSourceSheet {
    
    [addSourceSheet beginContractAnimation];
    self.addSourceButtonTapped(collapsedSize);
    [UIView animateWithDuration:0.3f animations:^{
        animatableAddSheetConstraint.constant = 0;
        [self layoutIfNeeded];
        self.expandAnimationCompleted();
    } completion:^(BOOL finished) {
        [self addConstraints:constraintsAddedToFitAddSourceSheet];
        [addSourceSheet removeFromSuperview];
        addSourceSheet = nil;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
