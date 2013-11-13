@class ListItem;
@interface PersistenceManager : NSObject

+(instancetype)sharedInstance;

+(void)setupPersistence;

+(NSManagedObjectContext *)managedObjectContext;

+(void)deletePersistentStore;
+(void)resetManagedObjectContext;

@end
