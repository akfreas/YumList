#import <XCTest/XCTest.h>
#import "ListItem.h"
#import "PersistenceManager.h"

@interface ListItemTests : XCTestCase

@end

@implementation ListItemTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)testCreateAndSaveListItem {
    ListItem *ourListItem = [ListItem new];
    [ourListItem save];
}

-(void)testPersistListItemSavesToDisk {
    
    
    [PersistenceManager deletePersistentStore];
    NSString *title = @"Get some fresh air.";
    NSDate *creationDate = [NSDate date];
    NSNumber *listOrder = [NSNumber numberWithInteger:1];
    NSNumber *completed = [NSNumber numberWithBool:NO];
    
    ListItem *ourListItem = [ListItem new];
    ourListItem.title = title;
    ourListItem.creationDate = creationDate;
    ourListItem.listOrder = listOrder;
    ourListItem.completed = completed;
    [ourListItem save];
    [PersistenceManager resetManagedObjectContext];
    NSArray *allItems = [ListItem allObjects];
    
    if ([allItems count] == 1) {
        ListItem *savedObject = allItems[0];
        XCTAssertTrue([savedObject.title isEqualToString:title], @"Title was not saved correctly.");
        XCTAssertTrue([savedObject.creationDate isEqualToDate:creationDate], @"Date was not saved correctly.");
        XCTAssertTrue([savedObject.listOrder isEqualToNumber:listOrder], @"List order was not saved correctly.");
        XCTAssertTrue([savedObject.completed isEqualToNumber:completed], @"Completed value was not saved correctly.");
    } else {
        XCTFail(@"More than one listitem was encountered. %s failed.", __PRETTY_FUNCTION__);
    }
    
}

@end
