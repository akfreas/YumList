#import "ListItem.h"

@interface ListItem (ListItemHelpers)

+(NSArray *)allObjectsSortedByListOrderInContext:(NSManagedObjectContext *)context;
+(ListItem *)newOrderedItemInContext:(NSManagedObjectContext *)context;
+(ListItem *)newOrderedItem;

@end
