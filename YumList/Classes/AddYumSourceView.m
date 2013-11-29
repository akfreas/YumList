#import "AddYumSourceView.h"
#import "AddYumSourceSheet.h"
#import "YumSource.h"

@implementation AddYumSourceView {
    UIButton *addSourceButton;
    AddYumSourceSheet *addSourceSheet;
    NSArray *constraintsAddedToFitAddSourceSheet;
    NSLayoutConstraint *animatableAddSheetConstraint;
    NSArray *addSourceButtonConstraints;
}

#define CollapsedSize 44.0f
#define ExpandedActionSheetSize 130.0f + CollapsedSize
#define ExpandedSize ExpandedActionSheetSize + 10

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
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
    addSourceButtonConstraints = [self addConstraintWithVisualFormat:@"V:|-5-[addSourceButton]" bindings:MXDictionaryOfVariableBindings(addSourceButton)];
    [addSourceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addSourceButton addEventHandler:[self addSourceButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
}

-(void(^)(id sender))addSourceButtonEventHandler {
    return ^(id sender) {
        if (addSourceSheet.superview == nil) {
            [self addSourceSheet];
        } else {
            [self removeSourceSheet];
        }
    };
}

-(void(^)())addCompletedSourceButtonHandler {
    return ^(YumSource *newSource) {
        if (self.submitOrCancelButtonTapped != NULL) {
            self.submitOrCancelButtonTapped(CollapsedSize);
        }
        [self removeSourceSheet];
    };
}

-(void(^)())cancelButtonHandler {
    return ^{
        if (self.submitOrCancelButtonTapped != NULL) {
            self.submitOrCancelButtonTapped(CollapsedSize);
        }
        [self removeSourceSheet];
    };
}

-(void)addSourceSheet {
    
    if (addSourceSheet == nil) {
        addSourceSheet = [[AddYumSourceSheet alloc] initWithFrame:CGRectZero];
        addSourceSheet.newSourceAdded = [self addCompletedSourceButtonHandler];
        addSourceSheet.cancelButtonPressed = [self cancelButtonHandler];
    }
    [self addSubview:addSourceSheet];
    [self removeConstraints:addSourceButtonConstraints];
    [addSourceButton removeFromSuperview];
    constraintsAddedToFitAddSourceSheet = [self addConstraintWithVisualFormat:@"V:|-5-[addSourceSheet]-5-|" bindings:MXDictionaryOfVariableBindings(addSourceButton, addSourceSheet)];
    [self addConstraintWithVisualFormat:@"H:|[addSourceSheet(260)]" bindings:MXDictionaryOfVariableBindings(addSourceSheet)];
    [self addConstraints:constraintsAddedToFitAddSourceSheet];
    [self layoutIfNeeded];
    self.addSourceButtonTapped(ExpandedSize);
}

-(void)removeSourceSheet {
    self.addSourceButtonTapped(CollapsedSize);
    [addSourceSheet removeFromSuperview];
    [self addSubview:addSourceButton];
}
@end
