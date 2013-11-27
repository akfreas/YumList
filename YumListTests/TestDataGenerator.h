
@interface TestDataGenerator : NSObject

+(void)generateTestYumItemDataWithCount:(NSInteger)count;
+(void)generateTestYumItemDataWithCount:(NSInteger)count context:(NSManagedObjectContext *)context;
+(void)generateNumberedTestYumItemsWithCount:(NSInteger)count;
+(void)generateNumberedTestYumItemsWithCount:(NSInteger)count context:(NSManagedObjectContext *)context;
@end
