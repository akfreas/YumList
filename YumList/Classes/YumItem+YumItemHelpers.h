#import "YumItem.h"

@interface YumItem (YumItemHelpers)

+(YumItem *)itemWithExternalID:(NSString *)externalID;
+(YumItem *)itemWithExternalID:(NSString *)externalID context:(NSManagedObjectContext *)context;

@end
