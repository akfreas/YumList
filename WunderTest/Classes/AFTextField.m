#import "AFTextField.h"

@interface AFTextFieldDelegate : NSObject <UITextFieldDelegate>


@property (copy) void(^returnKeyboardButtonAction)(AFTextField *textField);
@property (copy) void(^didBeginEditingAction)(AFTextField *textField);
@property (copy) void(^didEndEditingAction)(AFTextField *textField);

@end

@implementation AFTextFieldDelegate

#pragma mark Delegate Methods

-(void)textFieldDidBeginEditing:(AFTextField *)textField {
    [textField setSelectedBackground];
    
    if (_didBeginEditingAction != NULL) {
        _didBeginEditingAction(textField);
    }
}

-(void)textFieldDidEndEditing:(AFTextField*)textField {
    [textField setUnselectedBackground];
    if (_didEndEditingAction != NULL) {
        _didEndEditingAction(textField);
    }
}

-(BOOL)textFieldShouldReturn:(AFTextField *)textField {
    if (_returnKeyboardButtonAction != NULL) {
        _returnKeyboardButtonAction(textField);
        return YES;
    } else {
        return NO;
    }
}

@end

@interface AFTextField () <UITextFieldDelegate>

@end

@implementation AFTextField {
    NSString *placeHolder;
    AFTextFieldDelegate *delegate;
}


-(id)init {
    self = [super init];
    
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        delegate = [[AFTextFieldDelegate alloc] init];
        self.delegate = delegate;
        [self initExtras];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        delegate = [[AFTextFieldDelegate alloc] init];
        self.delegate = delegate;
        [self initExtras];
    }
    
    return self;
}

#pragma accessor methods

-(void)setDidBeginEditingAction:(void (^)(AFTextField *))didBeginEditingAction {
    delegate.didBeginEditingAction = didBeginEditingAction;
}

-(void)setDidEndEditingAction:(void (^)(AFTextField *))didEndEditingAction {
    delegate.didEndEditingAction = didEndEditingAction;
}

-(void)setReturnKeyboardButtonAction:(void (^)(AFTextField *))returnKeyboardButtonAction {
    delegate.returnKeyboardButtonAction = returnKeyboardButtonAction;
}

- (void) initExtras {
    [self setLeftPadding];
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    self.borderStyle = UITextBorderStyleNone;
    placeHolder = self.placeholder;
    [self setUnselectedBackground];
}

- (void)setLeftPadding {
    // http://stackoverflow.com/questions/3727068/set-padding-for-uitextfield-with-uitextborderstylenone
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setUnselectedBackground {
//    [self setBackground:[[UIImage imageNamed:@"textfield_unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 2.0f, 5.0f, 2.0f)]];
    self.textColor = [UIColor colorWithRed:122.0f/256.0f green:122.0f/256.0f blue:122.0f/256.0f alpha:1.0f];
    if ([self.text length] == 0 ) {
        self.leftViewMode = UITextFieldViewModeNever;
    }
    self.placeholder = placeHolder;
}

- (void)setSelectedBackground {
//    [self setBackground:[[UIImage imageNamed:@"textfield_selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 2.0f, 5.0f, 2.0f)]];
    self.textColor = [UIColor colorWithRed:32.0f/256.0f green:171.0f/256.0f blue:17.0f/256.0f alpha:1.0f];
    self.placeholder = @"";
    self.leftViewMode = UITextFieldViewModeAlways;
}





@end
