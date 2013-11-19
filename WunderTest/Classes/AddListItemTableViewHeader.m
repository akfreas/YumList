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
        editModeToggled = NO;
    }
    return self;
}

-(void)addUIComponents {
    [self addTitleTextField];
    [self addEditButton];
}

-(void)addEditButton {
    editButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 30, 60, 30)];
    [editButton setTitle:NSLocalizedString(@"Edit", @"Edit button title.") forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:editButton];
}

-(void)addTitleTextField {
    
    titleTextField = [[AFTextField alloc] initWithFrame:CGRectMake(10, 30, 250, 30)];
    CALayer *borderlayer = [CALayer layer];
    borderlayer.frame = CGRectMake(0, titleTextField.frame.size.height - 1, titleTextField.frame.size.width, 1);
    borderlayer.backgroundColor = [UIColor blackColor].CGColor;
    [titleTextField.layer addSublayer:borderlayer];
//    titleTextField.clipsToBounds = YES;

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
    [editButton addEventHandler:^(UIButton *sender) {
        if (editModeToggled == NO) {
            [sender setTitle:@"Done" forState:UIControlStateNormal];
        } else {
            [sender setTitle:@"Edit" forState:UIControlStateNormal];
        }

        editModeToggled = !editModeToggled;
        editButtonAction();
    } forControlEvents:UIControlEventTouchUpInside];
}

@end
