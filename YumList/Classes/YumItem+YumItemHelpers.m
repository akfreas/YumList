#import "YumItem+YumItemHelpers.h"
#import "NSManagedObject+Helpers.h"
#import "PersistenceManager.h"
#import "YumSource.h"
#import <AFNetworking.h>

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

+(void)removeYumItemAndReorderYumItems:(YumItem *)item {
    
    NSArray *YumItemSortedFilteredArray = [YumItem YumItemsGreaterThanOrderOfYumItem:item inContext:item.managedObjectContext];
    
    for (YumItem *decrementItem in YumItemSortedFilteredArray) {
        decrementItem.listOrder = [NSNumber numberWithInteger:[decrementItem.listOrder integerValue] - 1];
    }
    [item delete];
}


+(void)insertYumItemAndReorderYumItems:(YumItem *)item {
    return [self insertYumItemAndReorderYumItems:item inContext:[PersistenceManager managedObjectContext]];
}

+(void)insertYumItemAndReorderYumItems:(YumItem *)item inContext:(NSManagedObjectContext *)context {
    
    if (item.managedObjectContext == nil || item.managedObjectContext != context) {
        [context insertObject:item];
    }
    
    NSArray *YumItemSortedFilteredArray = [YumItem YumItemsGreaterThanOrderOfYumItem:item inContext:context];
    int i = [item.listOrder integerValue];
    for (YumItem *incrementItem in YumItemSortedFilteredArray) {
        i++;
        incrementItem.listOrder = [NSNumber numberWithInteger:i];
    }
}


+(NSArray *)YumItemsGreaterThanOrderOfYumItem:(YumItem *)item {
    return [self YumItemsGreaterThanOrderOfYumItem:item inContext:[PersistenceManager managedObjectContext]];
}

+(NSArray *)YumItemsGreaterThanOrderOfYumItem:(YumItem *)item inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [YumItem baseFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listOrder >= %@ && self != %@", item.listOrder, item];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"listOrder" ascending:YES];
    request.predicate = predicate;
    request.sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    NSArray *itemsMatching = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        [NSException raise:YLCoreDataException format:@"Error fetching list item with order %@ in MOC: %@ Error: %@", item, error, context];
    }
    return itemsMatching;
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

-(void)populatePropertiesFromExternalService:(void(^)(YumItem *))completion {
    NSURL *requestURL = [NSURL URLWithString:self.externalYumID relativeToURL:[NSURL URLWithString:@"http://api.yummly.com/v1/api/recipe/"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setValue:@"d3632000" forHTTPHeaderField:@"X-Yummly-App-ID"];
    [request setValue:@"bac160d28227bda4f6effe7048209270" forHTTPHeaderField:@"X-Yummly-App-Key"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    NSManagedObjectID *ourID = self.objectID;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseJSON) {
        PersistenceManager *newManager = [PersistenceManager new];
        YumItem *ourItem = [YumItem objectWithObjectID:ourID inContext:newManager.managedObjectContext];
        NSDictionary *source = [responseJSON objectForKey:@"source"];
        ourItem.externalSiteTitle = source[@"sourceDisplayName"];
        ourItem.externalURL = source[@"sourceRecipeUrl"];
        ourItem.title = responseJSON[@"name"];
        [ourItem save];
        NSManagedObjectID *objID = ourItem.objectID;
        dispatch_async(dispatch_get_main_queue(), ^{
            YumItem *mainQueueItem = [YumItem objectWithObjectID:objID];
            completion(mainQueueItem);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

-(void)fetchImageAndSave:(void (^)(UIImage *))completion {
    
    if (self.image == nil && [self.imageURL isEqualToString:@""] == NO) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/jpeg"];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        NSManagedObjectID *ourID = self.objectID;
        NSArray *formattedURLFragments = [self.imageURL componentsSeparatedByString:@"="];
        NSString *baseURL;
        NSDictionary *paramDict = nil;
        if ([formattedURLFragments count] > 1) {
            paramDict = @{@"": formattedURLFragments[1]};
            baseURL = formattedURLFragments[0];
        } else {
            baseURL = self.imageURL;
        }
        [manager GET:baseURL parameters:paramDict success:^(NSURLSessionDataTask *task, UIImage *imageData) {
            PersistenceManager *ourManager = [PersistenceManager new];
            YumItem *item = [YumItem objectWithObjectID:ourID inContext:ourManager.managedObjectContext];
            item.image = UIImageJPEGRepresentation(imageData, 4);
            [item saveInContext:ourManager.managedObjectContext];
            completion(imageData);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error fetching image data for %@. Error: %@", self, error);
            completion(nil);
        }];
    } else if ([self.imageURL isEqualToString:@""] == YES) {
        self.image = [NSData data];
        [self save];
    }
}

+(NSArray *)itemsWithSource:(YumSource *)source {
    return [self itemsWithSource:source context:[PersistenceManager managedObjectContext]];
}

+(NSArray *)itemsWithSource:(YumSource *)source context:(NSManagedObjectContext *)context {
    NSManagedObjectID *sourceID = source.objectID;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self.class)];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"source == %@", source];
    request.predicate = pred;
    NSError *err = nil;
    NSArray *filteredYums = [context executeFetchRequest:request error:&err];
    if (err != nil) {
        [NSException raise:YLCoreDataException format:@"Problem executing fetch request for %@. Error: %@", [self class], request];
    }
    return filteredYums;
}

@end
