#import "NSFetchedResultsController+ErrorHandling.h"

@implementation NSFetchedResultsController (ErrorHandling)

-(BOOL)performFetch {
    NSError *fetchError = nil;
    BOOL retVal = [self performFetch:&fetchError];
    if (fetchError != nil) {
        [NSException raise:YLCoreDataException format:@"Could not perform fetch on %@. Error: %@", self, fetchError];
    }
    return retVal;
}

@end
