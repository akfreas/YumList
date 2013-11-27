#import "YumSource+Helpers.h"
#import "PersistenceManager.h"

@implementation YumSource (Helpers)

+(YumSource *)newOrderedSourceInContext:(NSManagedObjectContext *)context {
    
    NSInteger oldCount = [[YumSource allObjectsInContext:context] count];
    YumSource *newSource = [YumSource newInContext:context];
    newSource.order = [NSNumber numberWithInteger:oldCount];
    return newSource;
}

+(YumSource *)newOrderedSource {
    return [self newOrderedSourceInContext:[PersistenceManager managedObjectContext]];
}

+(YumSource *)topSource {
    return [self topSourceInContext:[PersistenceManager managedObjectContext]];
}

+(YumSource *)topSourceInContext:(NSManagedObjectContext *)context {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"order == 0"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self.class)];
    request.predicate = pred;
    NSError *err = nil;
    NSArray *sources = [context executeFetchRequest:request error:&err];
    YumSource *source;
    if (err != nil) {
        [NSException raise:YLCoreDataException format:@"Error fetching top source in context: %@", err];
    }
    if ([sources count] > 1) {
        [NSException raise:YLInconsistencyException format:@"More than one source found with order 1."];
    }
    if ([sources count] < 1) {
        source = nil;
    } else {
        source = [sources firstObject];
    }
    return source;
}

@end
