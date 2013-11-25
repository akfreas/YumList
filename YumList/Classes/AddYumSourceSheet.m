#import "AddYumSourceSheet.h"
#import "YumSource.h"

@implementation AddYumSourceSheet {
    UITextView *URLTextField;
    UITextField *sourceNameTextField;
    UIButton *submitButton;
    UIButton *cancelButton;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)finishExpandAnimation {
    
    [self addURLTextView];
    [self addSubmitButton];
    [self addSourceNameTextField];
    [self addCancelButton];
    [self addLayoutConstraints];
}

-(void)beginContractAnimation {
    [self removeConstraints:[self constraints]];
}

-(void)addSourceNameTextField {
    sourceNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    sourceNameTextField.placeholder = NSLocalizedString(@"Recipe source name...", @"Recipe source name placeholder text.");
    [self addSubview:sourceNameTextField];
}

-(void)addURLTextView {

    URLTextField = [[UITextView alloc] initWithFrame:CGRectZero];
    [self addSubview:URLTextField];
    URLTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    URLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    URLTextField.textContainerInset = UIEdgeInsetsMake(5, 2, 2, 2);
    URLTextField.backgroundColor = [UIColor purpleColor];
}

-(void)addSubmitButton {
    submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    submitButton.backgroundColor = [UIColor greenColor];
    [submitButton setTitle:NSLocalizedString(@"Submit", @"Submit button text") forState:UIControlStateNormal];
    [submitButton addEventHandler:[self submitButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    
}

-(void)addCancelButton {
    cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
    cancelButton.backgroundColor = [UIColor redColor];
    [cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel button title.") forState:UIControlStateNormal];
    [cancelButton addEventHandler:[self cancelButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
}

-(void)addLayoutConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(sourceNameTextField, URLTextField, submitButton, cancelButton);
    [self addConstraintWithVisualFormat:@"V:|-10-[sourceNameTextField]-[URLTextField]-5-[submitButton(44)]-10-[cancelButton(44)]-10-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:|-10-[sourceNameTextField]-10-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:|-10-[URLTextField]-10-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:|-10-[submitButton]-10-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:|-10-[cancelButton]-10-|" bindings:bindings];
}

-(void(^)(id))cancelButtonEventHandler {
    return ^(id sender) {
        if (self.cancelButtonPressed != NULL) {
            self.cancelButtonPressed();
        }
    };
}

-(void(^)(id))submitButtonEventHandler {
    return ^(id sender){
        YumSource *newSource = [YumSource new];
        newSource.sourceURL = URLTextField.text;
        newSource.name = sourceNameTextField.text;
        [newSource save];
        if (self.newSourceAdded != NULL) {
            self.newSourceAdded(newSource);
        }
    };
}

@end
