#import "NSFetchedResultsControllerFactory.h"
#import "PersistenceManager.h"
#import "ListItem.h"

@implementation NSFetchedResultsControllerFactory

+(NSFetchedResultsController *)fetchControllerForAllListItems {
    
    NSSortDescriptor *listOrderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"listOrder" ascending:NO];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ListItem class])];
    request.sortDescriptors = @[listOrderSortDescriptor];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[PersistenceManager managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    return controller;
}

@end
