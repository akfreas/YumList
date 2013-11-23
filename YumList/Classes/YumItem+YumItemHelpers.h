#import "YumItem.h"

@interface YumItem (YumItemHelpers)

+(YumItem *)itemWithExternalID:(NSString *)externalID;
+(YumItem *)itemWithExternalID:(NSString *)externalID context:(NSManagedObjectContext *)context;
+(YumItem *)newItemWithDictionary:(NSDictionary *)dict;
+(YumItem *)newItemWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
@end
