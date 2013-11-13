@class ListItem;
@interface PersistenceManager : NSObject

+(instancetype)sharedInstance;

+(void)setupPersistence;

+(NSManagedObjectContext *)managedObjectContext;

+(void)deletePersistentStore;
+(void)resetManagedObjectContext;
+(void)save;
+(void)saveContext:(NSManagedObjectContext *)context;

@end
