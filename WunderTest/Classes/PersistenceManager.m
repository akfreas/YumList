#import "PersistenceManager.h"

@implementation PersistenceManager {
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
}

+(instancetype)sharedInstance {
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
    [[self sharedInstance] setupPersistence];
}

+(NSManagedObjectContext *)managedObjectContext {
    return [[self sharedInstance] managedObjectContext];
}

+(void)deletePersistentStore {
    [[self sharedInstance] deletePersistentStore];
}

+(void)resetManagedObjectContext {
    [[self sharedInstance] resetManagedObjectContext];
}

-(void)setupPersistence {
    [self managedObjectContext];
}

#pragma mark Boilerplate CoreData

-(NSManagedObjectModel *)managedObjectModel {
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
    return mom;
}

- (NSURL *)persistentStoreURL {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSURL *url = [NSURL fileURLWithPath:[basePath stringByAppendingPathComponent:@"WunderTest"]];
    return url;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    NSError *error;
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    } else {
        NSURL *dbPath = [self persistentStoreURL];
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

-(void)resetManagedObjectContext {
    managedObjectContext = nil;
}

-(void)deletePersistentStore {
    NSURL *persistentStoreURL = self.persistentStoreURL;
    if ([[NSFileManager defaultManager] fileExistsAtPath:persistentStoreURL.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:persistentStoreURL error:NULL];
    }
    persistentStoreCoordinator = nil;
    [self resetManagedObjectContext];
}

@end
