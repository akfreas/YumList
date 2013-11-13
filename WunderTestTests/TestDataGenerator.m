#import "PersistenceManager.h"
#import "ListItem.h"
#import "NSString+Random.h"
#import "TestDataGenerator.h"


@implementation TestDataGenerator


+(void)generateTestListItemDataWithCount:(NSInteger)count {
    
    for (int i=0; i < count; i++) {
        ListItem *aListItem = [self populatedTestListItem];
        aListItem.listOrder = [NSNumber numberWithInteger:i];
    }
    [PersistenceManager save];
}

+(ListItem *)populatedTestListItem {
    
    ListItem *aListItem = [ListItem new];
    
    aListItem.title = [NSString randomizedString];
    aListItem.creationDate = [self randomDateWithinReason];
    aListItem.completed = [NSNumber numberWithBool:arc4random() % 1];
    
    return aListItem;
}

+(NSDate *)randomDateWithinReason {
    
    NSDate *today = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComponents = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
    [currentComponents setDay:arc4random() % days.length];
    
    return currentComponents.date;
}


@end
