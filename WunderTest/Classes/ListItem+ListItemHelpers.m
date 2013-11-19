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

+(void)removeListItemAndReorderListItems:(ListItem *)item {
    
    NSArray *listItemSortedFilteredArray = [ListItem listItemsGreaterThanOrderOfListItem:item inContext:item.managedObjectContext];
    
    for (ListItem *decrementItem in listItemSortedFilteredArray) {
        decrementItem.listOrder = [NSNumber numberWithInteger:[decrementItem.listOrder integerValue] - 1];
    }
    [item delete];
}


+(void)insertListItemAndReorderListItems:(ListItem *)item {
    return [self insertListItemAndReorderListItems:item inContext:[PersistenceManager managedObjectContext]];
}

+(void)insertListItemAndReorderListItems:(ListItem *)item inContext:(NSManagedObjectContext *)context {
    
    if (item.managedObjectContext == nil || item.managedObjectContext != context) {
        [context insertObject:item];
    }
    
    NSArray *listItemSortedFilteredArray = [ListItem listItemsGreaterThanOrderOfListItem:item inContext:context];
    int i = [item.listOrder integerValue];
    for (ListItem *incrementItem in listItemSortedFilteredArray) {
        i++;
        incrementItem.listOrder = [NSNumber numberWithInteger:i];
    }
}

+(NSArray *)listItemsGreaterThanOrderOfListItem:(ListItem *)item {
    return [self listItemsGreaterThanOrderOfListItem:item inContext:[PersistenceManager managedObjectContext]];
}

+(NSArray *)listItemsGreaterThanOrderOfListItem:(ListItem *)item inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [ListItem baseFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listOrder >= %@ && self != %@", item.listOrder, item];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"listOrder" ascending:YES];
    request.predicate = predicate;
    request.sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    NSArray *itemsMatching = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        [NSException raise:@"WLTFetchException" format:@"Error fetching list item with order %@ in MOC: %@ Error: %@", item, error, context];
    }
    return itemsMatching;
}

@end
