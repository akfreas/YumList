#import "PersistenceManager.h"
#import "YumItem.h"
#import "NSString+Random.h"
#import "TestDataGenerator.h"


@implementation TestDataGenerator



+(void)generateTestYumItemDataWithCount:(NSInteger)count {
    [self generateTestYumItemDataWithCount:count context:[PersistenceManager managedObjectContext]];
}

+(void)generateTestYumItemDataWithCount:(NSInteger)count context:(NSManagedObjectContext *)context {
    
    for (int i=0; i < count; i++) {
        YumItem *aYumItem = [self populatedTestYumItemInContext:context];
        aYumItem.listOrder = [NSNumber numberWithInteger:i];
        aYumItem.imageURL = @"http://lh4.ggpht.com/265hqVltrJ9V4B1Iemqeyi8Yv0L8Q0hv9iAK9MbwMUHTyrzhpO2FKOVc1AM2-UMRxCJLRyNBOMr4NUHgRC4q=s100";
    }
    [PersistenceManager saveContext:context];
}

+(void)generateNumberedTestYumItemsWithCount:(NSInteger)count {
    [self generateNumberedTestYumItemsWithCount:count context:[PersistenceManager managedObjectContext]];
}

+(void)generateNumberedTestYumItemsWithCount:(NSInteger)count context:(NSManagedObjectContext *)context {
    for (int i=0; i < count; i++) {
        YumItem *aYumItem = [self populatedTestYumItemInContext:context ];
        aYumItem.listOrder = [NSNumber numberWithInt:i];
        aYumItem.title = [aYumItem.listOrder stringValue];
    }
    [PersistenceManager saveContext:context];
}

+(YumItem *)populatedTestYumItemInContext:(NSManagedObjectContext *)context {
    
    YumItem *aYumItem = [YumItem newInContext:context];
    
    aYumItem.title = [NSString randomizedString];
    aYumItem.syncDate = [self randomDateWithinReason];
    aYumItem.completed = [NSNumber numberWithBool:arc4random_uniform(1)];
    
    return aYumItem;
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
