#import "ListItemTableViewCell.h"
#import "ListItem.h"
#import "FormatUtils.h"
#import "AFCheckbox.h"

@implementation ListItemTableViewCell {
    

    UILabel *creationDateLabel;
    AFCheckbox *checkboxButton;
    ListItem *ourListItem;
    UILabel *titleLabel;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addUIComponents];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleEditing:) name:@"ListTableEditing" object:nil];
    }
    return self;
}

-(void)toggleEditing:(NSNotification *)notif {
    NSNumber *isEditing = notif.userInfo[@"editing"];
    self.editing = [isEditing boolValue];
}

-(void)addUIComponents {
    [self addTitleLabel];
    [self addCreationDateLabel];
    [self addCompletedButton];
    [self setNeedsLayout];
}

-(void)addTitleLabel {
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 260, 20)];
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth);
    titleLabel.font = [UIFont fontWithName:@"Raleway-regular" size:14.0f];
    [self.contentView addSubview:titleLabel];
}

-(void)addCreationDateLabel {
    creationDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 22, 200, 20)];
    creationDateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    [self.contentView addSubview:creationDateLabel];
}

-(void)addCompletedButton {
    checkboxButton = [[AFCheckbox alloc] initWithFrame:CGRectMake(280, 7, 30, 30)];
    
    void(^block)(BOOL checked) = ^(BOOL checked){
        ourListItem.completed = [NSNumber numberWithBool:checked];
        [ourListItem save];
    };

    checkboxButton.buttonChecked = block;
    checkboxButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleLeftMargin);
    checkboxButton.autoresizesSubviews = YES;
    [self addSubview:checkboxButton];
    [self setNeedsLayout];
}

-(void)setEditing:(BOOL)editing {
    [UIView animateWithDuration:0.1f animations:^{
        checkboxButton.alpha = (editing == NO);
        NSInteger multiplier = editing ? 1 : -1;
        titleLabel.frame = CGRectOffset(titleLabel.frame, 10 * multiplier, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            checkboxButton.hidden = editing;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Accessors

-(void)setListItem:(ListItem *)listItem {
    ourListItem = listItem;
    titleLabel.text = ourListItem.title;
    creationDateLabel.text = [FormatUtils stringFromDate:listItem.creationDate];
    checkboxButton.checked = [ourListItem.completed boolValue];
    [self setNeedsLayout];
}

@end