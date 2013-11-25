#import "NSFetchedResultsControllerFactory.h"
#import "PersistenceManager.h"
#import "ListItem.h"
#import "YumItem.h"
#import "YumSource.h"

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

+(NSFetchedResultsController *)fetchControllerForYumItemsFromSource:(YumSource *)source {
    return [self fetchControllerForYumItemsFromSource:source inContext:[PersistenceManager managedObjectContext]];
}
+(NSFetchedResultsController *)fetchControllerForYumItemsFromSource:(YumSource *)source inContext:(NSManagedObjectContext *)context {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source == %@", source];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YumItem class])];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = predicate;
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return controller;
}

+(NSFetchedResultsController *)fetchControllerForAllYumItemsInContext:(NSManagedObjectContext *)context {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YumItem class])];
    request.sortDescriptors = @[sortDescriptor];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return controller;
}

+(NSFetchedResultsController *)fetchControllerForAllYumItems {
    return [self fetchControllerForAllYumItemsInContext:[PersistenceManager managedObjectContext]];
}


+(NSFetchedResultsController *)fetchControllerForYumSources {
    return [self fetchControllerForYumSourcesInContext:[PersistenceManager managedObjectContext]];
}

+(NSFetchedResultsController *)fetchControllerForYumSourcesInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YumSource class])];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return controller;
}

@end
