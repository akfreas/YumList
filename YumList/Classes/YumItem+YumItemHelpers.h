#import "YumItem.h"
#import "YumSource.h"

@interface YumItem (YumItemHelpers)

+(YumItem *)itemWithExternalID:(NSString *)externalID;
+(YumItem *)itemWithExternalID:(NSString *)externalID context:(NSManagedObjectContext *)context;
+(YumItem *)newItemWithDictionary:(NSDictionary *)dict;
+(YumItem *)newItemWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
+(NSArray *)itemsWithSource:(YumSource *)source;
+(NSArray *)itemsWithSource:(YumSource *)source context:(NSManagedObjectContext *)context;

+(void)removeYumItemAndReorderYumItems:(YumItem *)item;
+(void)insertYumItemAndReorderYumItems:(YumItem *)item inContext:(NSManagedObjectContext *)context;
+(void)insertYumItemAndReorderYumItems:(YumItem *)item;

+(NSArray *)allObjectsSortedByListOrderInContext:(NSManagedObjectContext *)context;

-(void)fetchImageAndSave:(void (^)(UIImage *))completion;
-(void)populatePropertiesFromExternalService:(void(^)(YumItem *))completion;

@end
