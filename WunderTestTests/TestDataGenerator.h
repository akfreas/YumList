
@interface TestDataGenerator : NSObject

+(void)generateTestListItemDataWithCount:(NSInteger)count;
+(void)generateTestListItemDataWithCount:(NSInteger)count context:(NSManagedObjectContext *)context;

@end
