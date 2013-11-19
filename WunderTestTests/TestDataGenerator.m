#import "PersistenceManager.h"
#import "ListItem.h"
#import "NSString+Random.h"
#import "TestDataGenerator.h"


@implementation TestDataGenerator



+(void)generateTestListItemDataWithCount:(NSInteger)count {
    [self generateTestListItemDataWithCount:count context:[PersistenceManager managedObjectContext]];
}

+(void)generateTestListItemDataWithCount:(NSInteger)count context:(NSManagedObjectContext *)context {
    
    for (int i=0; i < count; i++) {
        ListItem *aListItem = [self populatedTestListItemInContext:context];
        aListItem.listOrder = [NSNumber numberWithInteger:i];
    }
    [PersistenceManager saveContext:context];
}

+(void)generateNumberedTestListItemsWithCount:(NSInteger)count {
    [self generateNumberedTestListItemsWithCount:count context:[PersistenceManager managedObjectContext]];
}

+(void)generateNumberedTestListItemsWithCount:(NSInteger)count context:(NSManagedObjectContext *)context {
    for (int i=0; i < count; i++) {
        ListItem *aListItem = [self populatedTestListItemInContext:context ];
        aListItem.listOrder = [NSNumber numberWithInt:i];
        aListItem.title = [aListItem.listOrder stringValue];
    }
    [PersistenceManager saveContext:context];
}

+(ListItem *)populatedTestListItemInContext:(NSManagedObjectContext *)context {
    
    ListItem *aListItem = [ListItem newInContext:context];
    
    aListItem.title = [NSString randomizedString];
    aListItem.creationDate = [self randomDateWithinReason];
    aListItem.completed = [NSNumber numberWithBool:arc4random_uniform(1)];
    
    return aListItem;
}

+(NSDate *)randomDateWithinReason {
    
    NSDate *today = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComponents = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
    [currentComponents setDay:arc4random() % days.length];
    
    return [cal dateFromComponents:currentComponents];
}


@end
