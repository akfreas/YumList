#import "NSFetchedResultsControllerFactory.h"
#import "PersistenceManager.h"
#import "ListItem.h"

@implementation NSFetchedResultsControllerFactory

+(NSFetchedResultsController *)fetchControllerForAllListItems {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ListItem class])];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[PersistenceManager managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    return controller;
}

@end
