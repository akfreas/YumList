#import "ListItemTableViewCell.h"
#import "FormatUtils.h"
#import "AFCheckbox.h"
#import "UIView+LayoutHelpers.h"
#import <AFNetworking.h>

@implementation ListItemTableViewCell {
    

    UILabel *creationDateLabel;
    AFCheckbox *checkboxButton;
    YumItem *ourYumItem;
    UILabel *titleLabel;
    UIImageView *imageView;
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
    [self addYumImage];
    [self addConstraintsToSubviews];
    [self setNeedsLayout];
}

-(void)addYumImage {
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
    }
    if (ourYumItem.image == nil) {
        [ourYumItem fetchImageAndSave:^(UIImage *image) {
            imageView.image = image;
        }];
    } else {
        imageView.image = [UIImage imageWithData:ourYumItem.image];
    }
}
-(CGSize)intrinsicContentSize {
    return CGSizeMake(320.0f, 120.0f);
}

-(void)addTitleLabel {
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth);
    titleLabel.font = [UIFont fontWithName:@"Raleway-regular" size:14.0f];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
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
        ourYumItem.completed = [NSNumber numberWithBool:checked];
        [ourYumItem save];
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

-(void)addConstraintsToSubviews {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(titleLabel, imageView, creationDateLabel);
    [self addConstraintWithVisualFormat:@"H:|-10-[imageView(50)]-10-[titleLabel]-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:[imageView]-10-[creationDateLabel]" bindings:bindings];
    [self addConstraintWithVisualFormat:@"V:|-5-[titleLabel]" bindings:bindings];
    [self addConstraintWithVisualFormat:@"V:|-20-[imageView(50)]" bindings:bindings];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Accessors

-(void)setYumItem:(YumItem *)listItem {
    ourYumItem = listItem;
    titleLabel.text = ourYumItem.title;
    creationDateLabel.text = [FormatUtils stringFromDate:listItem.syncDate];
    checkboxButton.checked = [ourYumItem.completed boolValue];
    [self addYumImage];
}

@end
