#import "AddYumSourceSheet.h"
#import "YumSource.h"

@implementation AddYumSourceSheet {
    UITextView *URLTextField;
    UITextField *sourceNameTextField;
    UIButton *submitButton;
    UIButton *cancelButton;
    NSArray *constraintsForHeight;
    UIImageView *underlineImageView;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addURLTextView];
        [self addSubmitButton];
        [self addSourceNameTextField];
        [self addCancelButton];
        [self addLayoutConstraints];
    }
    return self;
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
    
    UIImage *baseImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkbox_underline" ofType:@"png"]];
   UIImage *capInsetImage =  [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 2.0f, 5.0f, 2.0f)];
    underlineImageView = [[UIImageView alloc] initWithImage:capInsetImage];
    underlineImageView.backgroundColor = [UIColor redColor];
}

-(void)addSubmitButton {
    submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    submitButton.backgroundColor = [UIColor crayolaJungleGreenColor];
    [submitButton setTitle:NSLocalizedString(@"Add", @"Submit button text") forState:UIControlStateNormal];
    [submitButton bk_addEventHandler:[self submitButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    
}

-(void)addCancelButton {
    cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
    cancelButton.backgroundColor = [UIColor crayolaBrickRedColor];
    [cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel button title.") forState:UIControlStateNormal];
    [cancelButton bk_addEventHandler:[self cancelButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelButton];
}

-(void)addLayoutConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(sourceNameTextField, URLTextField, submitButton, cancelButton);
    [self addConstraintWithVisualFormat:@"V:|-10-[sourceNameTextField]-[URLTextField(80)]-[cancelButton(44)]" bindings:bindings];
    [self addConstraintWithVisualFormat:@"V:[URLTextField]-[submitButton(44)]" bindings:bindings];
    
    [self addConstraintWithVisualFormat:@"H:|-10-[sourceNameTextField]-10-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:|-10-[URLTextField]-10-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:|-10-[cancelButton(==submitButton)]-10-[submitButton(>=80)]-10-|" bindings:bindings];
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
        
        BOOL shouldDismiss = YES;
        if (URLTextField.text == nil || [URLTextField.text isEqualToString:@""]) {
            shouldDismiss = NO;
            [UIView animateWithDuration:0.3f animations:^{
                URLTextField.layer.borderColor = [UIColor crayolaScarletColor].CGColor;
                URLTextField.layer.borderWidth = 2.0f;
            }];
        } else {
            URLTextField.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        if (sourceNameTextField.text == nil || [URLTextField.text isEqualToString:@""]) {
            shouldDismiss = NO;
                sourceNameTextField.layer.borderColor = [UIColor crayolaScarletColor].CGColor;
                sourceNameTextField.layer.borderWidth = 2.0f;
        } else {
            sourceNameTextField.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
        if (shouldDismiss == YES) {
            YumSource *newSource = [YumSource new];
            newSource.sourceURL = URLTextField.text;
            newSource.name = sourceNameTextField.text;
            
            [newSource save];
            if (self.newSourceAdded != NULL) {
                self.newSourceAdded(newSource);
            }
        } 
    };
}

@end
