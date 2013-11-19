#import <XCTest/XCTest.h>
#import "ListItem.h"
#import "PersistenceManager.h"
#import "TestDataGenerator.h"

@interface ListItemTests : XCTestCase {
    PersistenceManager *ourManager;
}

@end

@implementation ListItemTests

- (void)setUp
{
    [super setUp];
    ourManager = [PersistenceManager new];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)resetPersistenceLayer {
    [ourManager deleteAllObjects];
}

-(void)generateDummyData {
    NSInteger numRows = arc4random() % 100;
    [TestDataGenerator generateTestListItemDataWithCount:numRows context:ourManager.managedObjectContext];
}

-(void)testCreateAndSaveListItem {
    ListItem *ourListItem = [ListItem newInContext:ourManager.managedObjectContext];
    [ourListItem saveInContext:ourManager.managedObjectContext];
}

-(void)testPersistListItemSavesToDisk {
    
    NSString *title = @"Get some fresh air.";
    NSDate *creationDate = [NSDate date];
    NSNumber *listOrder = [NSNumber numberWithInteger:1];
    NSNumber *completed = [NSNumber numberWithBool:NO];
    
    ListItem *ourListItem = [ListItem newInContext:ourManager.managedObjectContext];
    ourListItem.title = title;
    ourListItem.creationDate = creationDate;
    ourListItem.listOrder = listOrder;
    ourListItem.completed = completed;
    [ourListItem saveInContext:ourManager.managedObjectContext];
    [ourManager resetManagedObjectContext];
    NSArray *allItems = [ListItem allObjectsInContext:ourManager.managedObjectContext];
    NSUInteger itemIndex = [allItems indexOfObjectPassingTest:^BOOL(ListItem *item, NSUInteger index, BOOL *stop) {
        if ([item.title isEqualToString:title] && [item.creationDate isEqualToDate:creationDate]) {
            return YES;
        } else {
            return NO;
        };
    }];
    ListItem *savedObject = allItems[itemIndex];
    XCTAssertTrue([savedObject.title isEqualToString:title], @"Title was not saved correctly.");
    XCTAssertTrue([savedObject.creationDate isEqualToDate:creationDate], @"Date was not saved correctly.");
    XCTAssertTrue([savedObject.listOrder isEqualToNumber:listOrder], @"List order was not saved correctly.");
    XCTAssertTrue([savedObject.completed isEqualToNumber:completed], @"Completed value was not saved correctly.");    
}


-(void)testCoreDataDeletionCorrectness {
    
    [self resetPersistenceLayer];
    [self generateDummyData];
    NSArray *allObjects = [ListItem allObjectsInContext:ourManager.managedObjectContext];
    NSInteger numRows = [allObjects count];
    ListItem *ourListItem = [allObjects lastObject];
    [ourManager deleteObject:ourListItem];
    
    NSInteger newCount = [[ListItem allObjectsInContext:ourManager.managedObjectContext] count];
    XCTAssertEqual(newCount, numRows - 1, @"The item was not successfully deleted in the db.");
}

-(void)testListOrderCorrectnessAfterCreatingNewObject {
    [self resetPersistenceLayer];
    NSInteger numRows = arc4random() % 100;
    [TestDataGenerator generateNumberedTestListItemsWithCount:numRows];
    
    ListItem *newListItem = [ListItem newOrderedItemInContext:ourManager.managedObjectContext];
    [newListItem save];
    NSNumber *expectedNumber = [NSNumber numberWithInt:numRows]; //We are checking against numRows because listOrder is 0 based.
    XCTAssertTrue([expectedNumber isEqualToNumber:newListItem.listOrder], @"List order should be %@, got back %@", expectedNumber, newListItem.listOrder);
}


@end
