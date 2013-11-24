@interface NSFetchedResultsControllerFactory : NSObject


+(NSFetchedResultsController *)fetchControllerForAllListItemsInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForAllListItems;
+(NSFetchedResultsController *)fetchControllerForAllYumItemsInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForAllYumItems;

@end
