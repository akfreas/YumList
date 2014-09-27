#import "AFCheckbox.h"

@implementation AFCheckbox {
    UILabel *checkedLabel;
    UIImage *backgroundImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *baseImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkbox_underline" ofType:@"png"]];
        backgroundImage = [baseImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 2.0f, 5.0f, 2.0f)];
        
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        checkedLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 22, 25)];
        [self addSubview:checkedLabel];
    }
    return self;
}

-(void)setButtonChecked:(void (^)(BOOL checked))buttonChecked {

    if (buttonChecked != NULL) {
        _buttonChecked = buttonChecked;
        [self bk_addEventHandler:[self checkedAction]
             forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void(^)(AFCheckbox *))checkedAction {
    return ^(AFCheckbox *sender) {
        self.checked = !self.checked;
        _buttonChecked(sender.checked);
    };
}

-(void)setChecked:(BOOL)checked {
    _checked = checked;
    if (checked == YES) {
        checkedLabel.text = @"✔";
    } else {
        checkedLabel.text = @"";
    }
}
@end
