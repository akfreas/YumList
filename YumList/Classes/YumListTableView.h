@class YumItem;
@interface YumListTableView : UITableView <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchController;

@property (copy, nonatomic) void(^yumItemSelected)(YumItem *);

@end
