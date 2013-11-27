#import "YumSource.h"

@interface YumSource (Helpers)

+(YumSource *)newOrderedSourceInContext:(NSManagedObjectContext *)context;
+(YumSource *)newOrderedSource;
+(YumSource *)topSourceInContext:(NSManagedObjectContext *)context;
+(YumSource *)topSource;

@end
