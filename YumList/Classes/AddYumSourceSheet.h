@class YumSource;
@interface AddYumSourceSheet : UIView

@property (copy, nonatomic) void(^newSourceAdded)(YumSource *);
@property (copy, nonatomic) void(^cancelButtonPressed)();
@end
