#import "ListItem+ListItemHelpers.h"
#import "PersistenceManager.h"

@implementation ListItem (ListItemHelpers)


+(ListItem *)newOrderedItem {
    return [self newOrderedItemInContext:[PersistenceManager managedObjectContext]];
}

+(ListItem *)newOrderedItemInContext:(NSManagedObjectContext *)context {
    NSInteger oldCount = [[ListItem allObjectsInContext:context] count];
    ListItem *newItem = [ListItem newInContext:context];
    newItem.listOrder = [NSNumber numberWithInteger:oldCount];
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

+(ListItem *)listItemWithListOrder:(NSNumber *)order {
    return [self listItemWithListOrder:order inContext:[PersistenceManager managedObjectContext]];
}

+(ListItem *)listItemWithListOrder:(NSNumber *)order inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [ListItem baseFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listOrder == %@", order];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *itemsMatching = [context executeFetchRequest:request error:&error];
    if ([itemsMatching count] == 1) {
        return itemsMatching[0];
    } else if (error != nil) {
        //TODO: run with this or not
        [NSException raise:@"WLTFetchException" format:@"Error fetching list item with order %@ in MOC: %@ Error: %@", order, error, context];
        return nil;
    } else {
        return nil;
    }
}

+(void)insertListItemAndReorderListItems:(ListItem *)item {
    return [self insertListItemAndReorderListItems:item inContext:[PersistenceManager managedObjectContext]];
}

+(void)insertListItemAndReorderListItems:(ListItem *)item inContext:(NSManagedObjectContext *)context {
    
    NSArray *listItemSortedFilteredArray = [ListItem listItemsGreaterThanOrder:item.listOrder inContext:context];
    
    for (ListItem *incrementItem in listItemSortedFilteredArray) {
        incrementItem.listOrder = [NSNumber numberWithInteger:[incrementItem.listOrder integerValue] + 1];
    }
}

+(NSArray *)listItemsGreaterThanOrder:(NSNumber *)order {
    return [self listItemsGreaterThanOrder:order inContext:[PersistenceManager managedObjectContext]];
}

+(NSArray *)listItemsGreaterThanOrder:(NSNumber *)order inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [ListItem baseFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listOrder > %@", order];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *itemsMatching = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        [NSException raise:@"WLTFetchException" format:@"Error fetching list item with order %@ in MOC: %@ Error: %@", order, error, context];
    }
    return itemsMatching;
}

-(void)insertIntoListOrder:(NSNumber *)listOrder {
    ListItem *currentListItem = [ListItem listItemWithListOrder:listOrder inContext:self.managedObjectContext];
    if (currentListItem != nil) {
        NSComparisonResult comparison = [currentListItem.listOrder compare:listOrder];
        if (comparison == NSOrderedAscending || comparison == NSOrderedSame) {
            [self willChangeValueForKey:@"listOrder"];
            currentListItem.listOrder = [NSNumber numberWithInteger:[currentListItem.listOrder integerValue] + 1];
            [self didChangeValueForKey:@"listOrder"];
        }
    } else {
        [self willChangeValueForKey:@"listOrder"];
        [self setValue:listOrder forKey:@"listOrder"];
        [self didChangeValueForKey:@"listOrder"];
    }
}

@end
