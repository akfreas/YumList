#import "ListItem+ListItemHelpers.h"
#import "PersistenceManager.h"

@implementation ListItem (ListItemHelpers)


+(ListItem *)newOrderedItem {
    return [self newOrderedItemInContext:[PersistenceManager managedObjectContext]];
}

+(ListItem *)newOrderedItemInContext:(NSManagedObjectContext *)context {
    ListItem *newItem = [ListItem newInContext:context];
    newItem.listOrder = [NSNumber numberWithInteger:[[ListItem allObjects] count]];
    return newItem;
}

+(NSArray *)allObjectsSortedByListOrderInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self.class)];
    NSSortDescriptor *listOrderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"listOrder" ascending:YES];
    request.sortDescriptors = @[listOrderSortDescriptor];
    NSError *error = nil;
    NSArray *sortedObjects = [context executeFetchRequest:request error:&error];
    NSAssert(error == nil, @"Error when fetching %@. Error: %@", NSStringFromClass(self.class), error);
    return sortedObjects;
}

+(NSArray *)allObjectsSortedByListOrder {
    return [self allObjectsSortedByListOrderInContext:[PersistenceManager managedObjectContext]];
}

-(void)setListOrderHelper:(NSNumber *)listOrder {
    
}

-(void)deleteInContext:(NSManagedObjectContext *)context {
    
    NSArray *sortedObjects = [ListItem allObjectsSortedByListOrderInContext:context];
    
    
}


@end
