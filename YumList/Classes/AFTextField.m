#import "AFTextField.h"

@interface AFTextFieldDelegate : NSObject <UITextFieldDelegate>

@property (strong, nonatomic) NSString *placeholder;
@property (copy) void(^returnKeyboardButtonAction)(AFTextField *textField);
@property (copy) void(^didBeginEditingAction)(AFTextField *textField);
@property (copy) void(^didEndEditingAction)(AFTextField *textField);

@end

@implementation AFTextFieldDelegate

#pragma mark Delegate Methods

-(void)textFieldDidBeginEditing:(AFTextField *)textField {
    if (_didBeginEditingAction != NULL) {
        _didBeginEditingAction(textField);
    }
}

-(void)textFieldDidEndEditing:(AFTextField*)textField {
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
    NSAttributedString *placeHolder;
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
    placeHolder = self.attributedPlaceholder;
}

- (void)setLeftPadding {
    // http://stackoverflow.com/questions/3727068/set-padding-for-uitextfield-with-uitextborderstylenone
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    attributedPlaceholder = attributedPlaceholder;
    [super setAttributedPlaceholder:attributedPlaceholder];
}
-(CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 4, 0);
}
@end
