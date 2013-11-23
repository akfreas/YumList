

@interface YumCollector : NSObject

-(void)syncYums:(void(^)(NSArray *newYums))completion;

@end
