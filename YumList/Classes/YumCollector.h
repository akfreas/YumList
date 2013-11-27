@class YumSource;

@interface YumCollector : NSObject

-(void)syncAllYums:(void(^)(NSArray *newYums))completion;

-(void)syncAllYums:(void (^)(NSArray *))completion context:(NSManagedObjectContext *)context;
-(void)syncYumsForSource:(YumSource *)source completion:(void (^)(NSArray *))completion;

@end
