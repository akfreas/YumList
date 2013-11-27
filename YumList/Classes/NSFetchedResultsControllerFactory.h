@interface NSFetchedResultsControllerFactory : NSObject

+(NSFetchedResultsController *)fetchControllerForAllYumItemsInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForAllYumItems;

+(NSFetchedResultsController *)fetchControllerForYumItemsFromSource:(YumSource *)source inContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForYumItemsFromSource:(YumSource *)source;

+(NSFetchedResultsController *)fetchControllerForYumSourcesInContext:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForYumSources;

+(NSFetchedResultsController *)fetchControllerForYumPhotosAttachedToItem:(YumItem *)item context:(NSManagedObjectContext *)context;
+(NSFetchedResultsController *)fetchControllerForYumPhotosAttachedToItem:(YumItem *)item;
@end
