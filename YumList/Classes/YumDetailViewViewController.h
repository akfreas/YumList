@class YumItem;
@interface YumDetailViewViewController : UIViewController

@property (strong, nonatomic) YumItem *yumItem;

-(id)initWithYumItem:(YumItem *)yumItem;

@end
