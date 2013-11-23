@interface ListTableView : UITableView <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchController;


@end
