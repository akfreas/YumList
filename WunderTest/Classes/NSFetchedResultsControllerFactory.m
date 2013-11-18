#import "NSFetchedResultsControllerFactory.h"
#import "PersistenceManager.h"
#import "ListItem.h"

@implementation NSFetchedResultsControllerFactory


+(NSFetchedResultsController *)fetchControllerForAllListItemsInContext:(NSManagedObjectContext *)context {
    
    NSSortDescriptor *listOrderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"listOrder" ascending:NO];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ListItem class])];
    request.sortDescriptors = @[listOrderSortDescriptor];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    return controller;
}

+(NSFetchedResultsController *)fetchControllerForAllListItems {
    return [self fetchControllerForAllListItemsInContext:[PersistenceManager managedObjectContext]];
}

@end
