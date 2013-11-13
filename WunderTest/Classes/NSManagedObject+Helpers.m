#import "NSManagedObject+Helpers.h"
#import "PersistenceManager.h"

@implementation NSManagedObject (Helpers)




+(instancetype)new {
    id instance = [self newInContext:[PersistenceManager managedObjectContext]];
    return instance;
}

+(instancetype)newInContext:(NSManagedObjectContext *)context {
    Class ourClass = self.class;
    id instance = [[ourClass alloc] initWithEntity:[self entityDescriptionInContext:context] insertIntoManagedObjectContext:context];
    return instance;
}

-(void)save {
    [self saveInContext:[PersistenceManager managedObjectContext]];
}

-(void)saveInContext:(NSManagedObjectContext *)context {
    
    NSError *error = nil;
    if (context.hasChanges == YES) {
        [context save:&error];
    }
    if (error != nil) {
        NSLog(@"Error encountered while saving instance of %@. Description: %@", NSStringFromClass(self.class), error.description);
    }
}

#pragma mark Inspired by http://www.cimgf.com/2011/03/13/super-happy-easy-fetching-in-core-data/

+(NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    if ([self respondsToSelector:@selector(entityForName:inManagedObjectContext:)] == YES) {
        return [self performSelector:@selector(entityForName:inManagedObjectContext:)];
    } else {
        return nil;
    }
}

+(NSArray *)allObjects {
    return [self allObjectsInContext:[PersistenceManager managedObjectContext]];
}

+(NSArray *)allObjectsInContext:(NSManagedObjectContext *)context {
    
    NSError *getterError = nil;
    NSString *entityName = NSStringFromClass(self.class);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setEntity:[self entityDescriptionInContext:context]];
    NSArray *objects = [context executeFetchRequest:request error:&getterError];
    if (getterError == nil) {
        NSLog(@"Error getting all objects for entity name %@. Description: %@", entityName, getterError.description);
    }
    return objects;
}



@end
