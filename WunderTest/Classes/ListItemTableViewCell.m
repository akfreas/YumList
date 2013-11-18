#import "ListItemTableViewCell.h"
#import "ListItem.h"
#import "FormatUtils.h"

@implementation ListItemTableViewCell {
    
    UILabel *titleLabel;
    UILabel *creationDateLabel;
    UISwitch *completedSwitch;
    ListItem *ourListItem;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addUIComponents];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    titleLabel.frame = CGRectMake(0, 0, 100, 30);
    creationDateLabel.frame = CGRectMake(100, 0, 100, 30);
    completedSwitch.frame = CGRectMake(270, 0, 30, 30);
    [completedSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    //    [self addLayoutConstraints];
}

-(void)switchAction {
    ourListItem.completed = [NSNumber numberWithBool:completedSwitch.isOn];
    [ourListItem save];
}

-(void)addUIComponents {
    [self addTitleLabel];
    [self addCreationDateLabel];
    [self addCompletedSwitch];
}

-(void)addTitleLabel {
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor redColor];
    
    [self addSubview:titleLabel];
}

-(void)addCreationDateLabel {
    creationDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:creationDateLabel];
}

-(void)addCompletedSwitch {
    completedSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self addSubview:completedSwitch];
}

-(void)addLayoutConstraints {
    [self addTitleConstraints];
//    [self addCreationDateContstraints];
//    [self addCompletedSwitchConstraints];
}

-(void)addTitleConstraints {
    
//    NSArray *titleConstraints = @[
//                                  [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:0 constant:5],
//                                  [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:0 constant:5]];
//    
//    [self addConstraints:titleConstraints];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(titleLabel, self);
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]|" options:0 metrics:nil views:viewsDictionary]];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:array];
}

-(void)addCreationDateContstraints {
    
}

-(void)addCompletedSwitchConstraints {
    
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
    creationDateLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Created", @"Created label."), [FormatUtils stringFromDate:listItem.creationDate]];
    completedSwitch.on = [ourListItem.completed boolValue];
//    [self setNeedsLayout];
}

@end
