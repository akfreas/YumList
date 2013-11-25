@class YumSource;
@interface AddYumSourceSheet : UIView

@property (copy, nonatomic) void(^newSourceAdded)(YumSource *);
-(void)finishExpandAnimation;
-(void)beginContractAnimation;
@end
