#import "AddListItemTableViewHeader.h"
#import "AFTextField.h"
#import "ListItem.h"

@implementation AddListItemTableViewHeader {
    
    AFTextField *titleTextField;
    UIButton *editButton;
    NSAttributedString *textFieldPlaceholder;
    BOOL editModeToggled;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUIComponents];
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin);
        editModeToggled = NO;
    }
    return self;
}

-(void)addUIComponents {
    [self addTitleTextField];
    [self addEditButton];
    [self setNeedsLayout];
}

-(void)addEditButton {
    editButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 30, 60, 30)];
    editButton.autoresizesSubviews = YES;
    editButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [editButton setTitle:NSLocalizedString(@"Edit", @"Edit button title.") forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:editButton];
}

-(void)addTitleTextField {
    
    titleTextField = [[AFTextField alloc] initWithFrame:CGRectMake(10, 30, 250, 30)];
    CALayer *borderlayer = [CALayer layer];
    borderlayer.frame = CGRectMake(0, titleTextField.frame.size.height - 1, titleTextField.frame.size.width, 1);
    borderlayer.backgroundColor = [UIColor blackColor].CGColor;
    titleTextField.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin);
    [titleTextField.layer addSublayer:borderlayer];

    titleTextField.font = [UIFont fontWithName:@"Raleway-Regular" size:14.0f];
    titleTextField.backgroundColor = [UIColor whiteColor];
    titleTextField.returnKeyType = UIReturnKeyDone;
    textFieldPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Add an item...", @"Add item textfield placeholder") attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.3 alpha:1]}];
    titleTextField.attributedPlaceholder = textFieldPlaceholder;
    titleTextField.returnKeyboardButtonAction = [self returnButtonAction];
    [self addSubview:titleTextField];
}

-(void(^)(AFTextField *))returnButtonAction {
    return ^(AFTextField *textField) {
        if ([textField.text isEqualToString:@""] == NO) {
            NSInteger numberOfObjects = [[ListItem allObjects] count];
            ListItem *newListItem = [ListItem new];
            newListItem.title = textField.text;
            newListItem.creationDate = [NSDate date];
            newListItem.completed = [NSNumber numberWithBool:NO];
            newListItem.listOrder = [NSNumber numberWithInteger:numberOfObjects];
            [newListItem save];
            textField.text = @"";
        }
        textField.attributedPlaceholder = textFieldPlaceholder;
        [textField resignFirstResponder];
    };
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    titleTextField.frame = CGRectMake(10, 0, 300, 30);
}

#pragma mark Accessors

-(void)setEditButtonAction:(void (^)())editButtonAction {
    [editButton removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    _editButtonAction = editButtonAction;
    [editButton addEventHandler:[self editButtonEventHandler] forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Helpers

-(void(^)())editButtonEventHandler {
    return ^(UIButton *sender) {
        if (editModeToggled == NO) {
            [sender setTitle:@"Done" forState:UIControlStateNormal];
        } else {
            [sender setTitle:@"Edit" forState:UIControlStateNormal];
        }
        
        editModeToggled = !editModeToggled;
        _editButtonAction();
    };
}

@end
