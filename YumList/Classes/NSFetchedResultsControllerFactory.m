#import "NSFetchedResultsControllerFactory.h"
#import "PersistenceManager.h"
#import "YumItem.h"
#import "YumSource.h"
#import "YumPhoto.h"

@implementation NSFetchedResultsControllerFactory


+(NSFetchedResultsController *)fetchControllerForYumItemsFromSource:(YumSource *)source {
    return [self fetchControllerForYumItemsFromSource:source inContext:[PersistenceManager managedObjectContext]];
}
+(NSFetchedResultsController *)fetchControllerForYumItemsFromSource:(YumSource *)source inContext:(NSManagedObjectContext *)context {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSSortDescriptor *completedSort = [NSSortDescriptor sortDescriptorWithKey:@"completed" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source == %@", source];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YumItem class])];
    request.sortDescriptors = @[sortDescriptor, completedSort];
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

+(NSFetchedResultsController *)fetchControllerForYumPhotosAttachedToItem:(YumItem *)item {
    return [self fetchControllerForYumPhotosAttachedToItem:item context:[PersistenceManager managedObjectContext]];
}

+(NSFetchedResultsController *)fetchControllerForYumPhotosAttachedToItem:(YumItem *)item context:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [YumPhoto baseFetchRequest];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"dateTaken" ascending:YES];
    request.sortDescriptors = @[sorter];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return controller;
}

@end
