#import "ListItem.h"

@interface ListItem (ListItemHelpers)

+(NSArray *)allObjectsSortedByListOrderInContext:(NSManagedObjectContext *)context;
+(ListItem *)newOrderedItemInContext:(NSManagedObjectContext *)context;
+(ListItem *)newOrderedItem;
+(ListItem *)listItemWithListOrder:(NSNumber *)order;
+(ListItem *)listItemWithListOrder:(NSNumber *)order inContext:(NSManagedObjectContext *)context;

+(void)removeListItemAndReorderListItems:(ListItem *)item;
+(void)insertListItemAndReorderListItems:(ListItem *)item inContext:(NSManagedObjectContext *)context;
+(void)insertListItemAndReorderListItems:(ListItem *)item;

@end
