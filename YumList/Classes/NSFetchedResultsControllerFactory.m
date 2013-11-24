#import "NSFetchedResultsControllerFactory.h"
#import "PersistenceManager.h"
#import "ListItem.h"
#import "YumItem.h"

@implementation NSFetchedResultsControllerFactory


+(NSFetchedResultsController *)fetchControllerForAllListItemsInContext:(NSManagedObjectContext *)context {
    
    NSSortDescriptor *listOrderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"listOrder" ascending:YES];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ListItem class])];
    request.sortDescriptors = @[listOrderSortDescriptor];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    return controller;
}

+(NSFetchedResultsController *)fetchControllerForAllListItems {
    return [self fetchControllerForAllListItemsInContext:[PersistenceManager managedObjectContext]];
}

+(NSFetchedResultsController *)fetchControllerForAllYumItemsInContext:(NSManagedObjectContext *)context {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YumItem class])];
    request.sortDescriptors = @[sortDescriptor];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return controller;
}

+(NSFetchedResultsController *)fetchControllerForAllYumItems {
    return [self fetchControllerForAllYumItemsInContext:[PersistenceManager managedObjectContext]];
}

@end
