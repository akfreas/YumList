#import "YumItem+YumItemHelpers.h"
#import "NSManagedObject+Helpers.h"
#import "PersistenceManager.h"

@implementation YumItem (YumItemHelpers)

+(YumItem *)itemWithExternalID:(NSString *)externalID {
    return [self itemWithExternalID:externalID context:[PersistenceManager managedObjectContext]];
}

+(YumItem *)itemWithExternalID:(NSString *)externalID context:(NSManagedObjectContext *)context {
    NSFetchRequest *request;
    if (request == nil) {
        request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self.class)];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"externalYumID == %@", externalID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"syncDate" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = predicate;
    NSError *err = nil;
    NSArray *itemObjects = [context executeFetchRequest:request error:&err];
    YumItem *retItem;
    NSInteger itemCount = [itemObjects count];
    if (itemCount == 1) {
        retItem = itemObjects[0];
    } else if (itemCount > 1) {
        [NSException raise:YLInconsistencyException format:@"More than one item was found with external id %@.", externalID];
        retItem = [itemObjects firstObject];
    } else {
        retItem = nil;
    }
    return retItem;
}

+(YumItem *)newItemWithDictionary:(NSDictionary *)dict {
    return [self newItemWithDictionary:dict context:[PersistenceManager managedObjectContext]];
}

+(YumItem *)newItemWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context {
    YumItem *newItem = [YumItem newInContext:context];
    [newItem setValuesForKeysWithDictionary:dict];
    return newItem;
}

@end
