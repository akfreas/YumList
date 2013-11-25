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



-(void)syncYumsForSource:(YumSource *)source completion:(void (^)(NSArray *))completion {
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
        for (NSDictionary *parsedYum in parsedYums) {
            YumItem *dbItem = [YumItem itemWithExternalID:parsedYum[@"externalYumID"] context:newManager.managedObjectContext];
            if (dbItem == nil) {
                YumItem *newItem = [YumItem newItemWithDictionary:parsedYum context:newManager.managedObjectContext];
                YumSource *ourSource = [YumSource objectWithObjectID:sourceObjID inContext:newManager.managedObjectContext];
                newItem.syncDate = syncDate;
                newItem.source = ourSource;
                [newYums addObject:newItem];
            }
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
