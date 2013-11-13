@class ListItem;
@interface PersistenceManager : NSObject

+(instancetype)sharedContext;

+(void)setupPersistence;

+(NSManagedObjectContext *)managedObjectContext;

@end
