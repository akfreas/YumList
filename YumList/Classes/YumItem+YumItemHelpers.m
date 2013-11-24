#import "YumItem+YumItemHelpers.h"
#import "NSManagedObject+Helpers.h"
#import "PersistenceManager.h"
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

@end
