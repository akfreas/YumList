#import "AddListItemTableViewHeader.h"
#import "AFTextField.h"
#import "ListItem.h"

@implementation AddListItemTableViewHeader {
    
    AFTextField *titleTextField;
    UIButton *editButton;
    NSString *textFieldPlaceholder;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUIComponents];
        self.backgroundColor = [UIColor orangeColor];
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
    [self addSubview:editButton];
}

-(void)addTitleTextField {
    
    textFieldPlaceholder = NSLocalizedString(@"Add an item...", @"Add item textfield placeholder");
    titleTextField = [[AFTextField alloc] initWithFrame:CGRectMake(10, 30, 250, 30)];
    titleTextField.backgroundColor = [UIColor purpleColor];
    titleTextField.returnKeyType = UIReturnKeyDone;
    titleTextField.placeholder = textFieldPlaceholder;
    titleTextField.returnKeyboardButtonAction = [self returnButtonAction];
    [self addSubview:titleTextField];
}

-(void(^)(AFTextField *))returnButtonAction {
    return ^(AFTextField *textField) {
        if ([textField.text isEqualToString:@""] == NO) {
            ListItem *newListItem = [ListItem new];
            newListItem.title = textField.text;
            newListItem.creationDate = [NSDate date];
            newListItem.completed = [NSNumber numberWithBool:NO];
            NSInteger allObjects = [[ListItem allObjects] count];
            newListItem.listOrder = [NSNumber numberWithInteger:allObjects + 1];
            [newListItem save];
            textField.text = @"";
        }
        textField.placeholder = textFieldPlaceholder;
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
    [editButton addEventHandler:^(id sender) {
        editButtonAction();
    } forControlEvents:UIControlEventTouchUpInside];
}

@end
