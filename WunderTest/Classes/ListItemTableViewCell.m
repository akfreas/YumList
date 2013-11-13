#import "ListItemTableViewCell.h"
#import "ListItem.h"
#import "FormatUtils.h"

@implementation ListItemTableViewCell {
    
    UILabel *titleLabel;
    UILabel *creationDateLabel;
    UISwitch *completedSwitch;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addUIComponents];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self addLayoutConstraints];

}

-(void)addUIComponents {
    [self addTitleLabel];
    [self addCreationDateLabel];
    [self addCompletedSwitch];
}

-(void)addTitleLabel {
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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
    [self addCreationDateContstraints];
    [self addCompletedSwitchConstraints];
}

-(void)addTitleConstraints {
    
    NSArray *titleConstraints = @[
                                  [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:0 constant:5],
                                  [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeTop multiplier:0 constant:5]];
    [titleLabel addConstraints:titleConstraints];
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
    
    titleLabel.text = listItem.title;
    creationDateLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Created", @"Created label."), [FormatUtils stringFromDate:listItem.creationDate]];
    completedSwitch.on = [listItem.completed boolValue];
    [self setNeedsLayout];
}

@end
