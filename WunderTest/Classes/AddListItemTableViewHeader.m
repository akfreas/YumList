#import "AddListItemTableViewHeader.h"
#import "AFTextField.h"
#import "ListItem.h"

@implementation AddListItemTableViewHeader {
    
    AFTextField *titleTextField;
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
}

-(void)addTitleTextField {
    titleTextField = [[AFTextField alloc] initWithFrame:CGRectMake(10, 30, 300, 30)];
    titleTextField.backgroundColor = [UIColor purpleColor];
    titleTextField.returnKeyType = UIReturnKeyDone;
    titleTextField.returnKeyboardButtonAction = [self returnButtonAction];
    [self addSubview:titleTextField];
}

-(void(^)(AFTextField *))returnButtonAction {
    return ^(AFTextField *textField) {
        ListItem *newListItem = [ListItem new];
        newListItem.title = textField.text;
        newListItem.creationDate = [NSDate date];
        newListItem.completed = [NSNumber numberWithBool:NO];
        NSInteger allObjects = [[ListItem allObjects] count];
        newListItem.listOrder = [NSNumber numberWithInteger:allObjects + 1];
        [newListItem save];
        textField.text = @"";
        [textField resignFirstResponder];
    };
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    titleTextField.frame = CGRectMake(10, 0, 300, 30);
}

@end
