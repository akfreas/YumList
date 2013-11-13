#import "PersistenceManager.h"

@implementation PersistenceManager {
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
}

+(instancetype)sharedContext {
    static id sharedInstance;
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

+(void)setupPersistence {
    [[self sharedContext] setupPersistence];
}

+(NSManagedObjectContext *)managedObjectContext {
    return [[self sharedContext] managedObjectContext];
}

-(void)setupPersistence {
    [self managedObjectContext];
}

#pragma mark Boilerplate CoreData

-(NSManagedObjectModel *)managedObjectModel {
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
    return mom;
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    NSError *error;
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    } else {
        NSURL *dbPath = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"WunderTest"]];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbPath options:nil error:&error];
    }
    
    if (error == nil) {
        return persistentStoreCoordinator;
    } else {
        NSLog(@"Error loading persistent store coordinator: %@", error);
        return nil;
    }
    
}

-(NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext == nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        managedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    return managedObjectContext;
}

-(void)save {
    NSError *error;
    if (managedObjectContext.hasChanges == YES) {
        [managedObjectContext save:&error];
    }
    
    if (error != nil) {
        NSLog(@"Error saving into managedObjectContext. Message: %@", error.description);
    }
}

@end
