#import <AFNetworking.h>
#import "TFHpple.h"
#import "YumCollector.h"
#import "YumItem.h"
#import "PersistenceManager.h"
#import "YumParser.h"
#import "YumItem+YumItemHelpers.h"
#import "YumItem.h"
#import "YumSource.h"

@implementation YumCollector {
    AFHTTPSessionManager *connectionManager;
}

-(void)syncAllYums:(void (^)(NSArray *))completion context:(NSManagedObjectContext *)context {
    NSArray *sources = [YumSource allObjectsInContext:context];
    __block NSMutableArray *newArray = [NSMutableArray array];
    __block NSInteger numberOfSources = [sources count];
    for (YumSource *source in sources) {
        [self syncYumsForSource:source completion:^(NSArray *newYums) {
            [newArray addObjectsFromArray:newYums];
            numberOfSources--;
            if (numberOfSources == 0) {
                completion(newArray);
            }
        }];
    }
}

-(void)syncYumsForSource:(YumSource *)source completion:(void (^)(NSArray *newYums))completion {
    if (connectionManager == nil) {
        connectionManager = [[AFHTTPSessionManager alloc] init];
        connectionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        connectionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    NSInteger chunkStart = 0;
    NSDate *syncDate = [NSDate date];
    NSManagedObjectID *sourceObjID = source.objectID;
    [connectionManager GET:source.sourceURL parameters:nil success:^(NSURLSessionDataTask *task, NSData *yumData) {
        PersistenceManager *newManager = [PersistenceManager new];
        NSArray *parsedYums = [YumParser parseYumData:yumData];
        NSMutableArray *newYums = [NSMutableArray new];
        NSMutableArray *allYums = [NSMutableArray arrayWithArray:[YumItem itemsWithSource:source context:newManager.managedObjectContext]];
        for (NSDictionary *parsedYum in parsedYums) {
            YumItem *dbItem = [YumItem itemWithExternalID:parsedYum[@"externalYumID"] context:newManager.managedObjectContext];
            if (dbItem == nil) {
                YumItem *newItem = [YumItem newItemWithDictionary:parsedYum context:newManager.managedObjectContext];
                YumSource *ourSource = [YumSource objectWithObjectID:sourceObjID inContext:newManager.managedObjectContext];
                newItem.syncDate = syncDate;
                newItem.source = ourSource;
                [newYums addObject:newItem];
            } else {
                [allYums removeObject:dbItem]; //remove the object fetched from our list of yums so we know what to delete later.
            }
        }
        
        for (YumItem *item in allYums) { //delete yumitems that weren't in the returned values, they must have been deleted on the server
            [item delete];
        }
        
        [newManager save];
        newManager = nil;
        if (completion != NULL) {
            completion(newYums);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failed fetching yums: %@",error);
        completion(nil);
    }];
}



@end
