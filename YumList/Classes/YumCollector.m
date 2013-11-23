#import <AFNetworking.h>
#import "TFHpple.h"
#import "YumCollector.h"
#import "YumItem.h"
#import "PersistenceManager.h"
#import "YumParser.h"
#import "YumItem+YumItemHelpers.h"
#import "YumItem.h"

@implementation YumCollector {
    AFHTTPSessionManager *connectionManager;
}

-(void)syncYums:(void (^)(NSArray *))completion {
    if (connectionManager == nil) {
        connectionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.yummly.com"]];
        connectionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        connectionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    NSInteger chunkStart = 0;
    NSString *yumURLString = [NSString stringWithFormat:@"http://www.yummly.com/profile/AlexanderFreas/collections/all-yums/more/%i", chunkStart];
    NSDate *syncDate = [NSDate date];
    [connectionManager GET:yumURLString parameters:nil success:^(NSURLSessionDataTask *task, NSData *yumData) {
        PersistenceManager *newManager = [PersistenceManager new];
        NSArray *parsedYums = [YumParser parseYumData:yumData];
        NSMutableArray *newYums = [NSMutableArray new];
        for (NSDictionary *parsedYum in parsedYums) {
            YumItem *dbItem = [YumItem itemWithExternalID:parsedYum[@"externalYumID"] context:newManager.managedObjectContext];
            if (dbItem == nil) {
                YumItem *newItem = [YumItem newItemWithDictionary:parsedYum context:newManager.managedObjectContext];
                newItem.syncDate = syncDate;
                [newYums addObject:newItem];
            }
        }
        [newManager save];
        newManager = nil;
        completion(newYums);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failed fetching yums: %@",error);
        completion(nil);
    }];
}



@end
