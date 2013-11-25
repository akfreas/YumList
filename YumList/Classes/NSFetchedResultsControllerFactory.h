@interface NSFetchedResultsControllerFactory : NSObject


+(NSFetchedResultsController *)fetchControllerForAllListItemsInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForAllListItems;
+(NSFetchedResultsController *)fetchControllerForAllYumItemsInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForAllYumItems;

+(NSFetchedResultsController *)fetchControllerForYumSourcesInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForYumSources;

@end
