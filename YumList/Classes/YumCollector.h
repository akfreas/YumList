@class YumSource;

@interface YumCollector : NSObject

-(void)syncAllYums:(void(^)(NSArray *newYums))completion;
-(void)syncYumsForSource:(YumSource *)source completion:(void (^)(NSArray *))completion;

@end
