@interface NSFetchedResultsControllerFactory : NSObject


+(NSFetchedResultsController *)fetchControllerForAllListItemsInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForAllListItems;

@end
