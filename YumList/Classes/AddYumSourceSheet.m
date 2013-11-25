#import "AddYumSourceSheet.h"
#import "YumSource.h"

@implementation AddYumSourceSheet {
    UITextField *URLTextField;
    UIButton *submitButton;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

-(void)finishExpandAnimation {
    
    [self addURLTextField];
    [self addSubmitButton];
    [self addLayoutConstraints];
}

-(void)beginContractAnimation {
    [self removeConstraints:[self constraints]];
}

-(void)addURLTextField {

    URLTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self addSubview:URLTextField];
    URLTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    URLTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    URLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    URLTextField.backgroundColor = [UIColor purpleColor];
}

-(void)addSubmitButton {
    submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    submitButton.backgroundColor = [UIColor redColor];
    [submitButton setTitle:NSLocalizedString(@"Submit", @"Submit button text") forState:UIControlStateNormal];
    [submitButton addEventHandler:[self submitButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    
}

-(void)addLayoutConstraints {
    
    [self addConstraintWithVisualFormat:@"V:|-10-[URLTextField]-5-[submitButton(44)]-10-|" bindings:MXDictionaryOfVariableBindings(URLTextField, submitButton)];
    [self addConstraintWithVisualFormat:@"H:|-10-[URLTextField]-10-|" bindings:MXDictionaryOfVariableBindings(URLTextField)];
    [self addConstraintWithVisualFormat:@"H:|-10-[submitButton]-10-|" bindings:MXDictionaryOfVariableBindings(submitButton)];
}

-(void(^)(id sender))submitButtonEventHandler {
    return ^(id sender){
        YumSource *newSource = [YumSource new];
        newSource.sourceURL = URLTextField.text;
        [newSource save];
        if (self.newSourceAdded != NULL) {
            self.newSourceAdded(newSource);
        }
    };
}

@end
