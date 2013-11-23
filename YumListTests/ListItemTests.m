#import <XCTest/XCTest.h>
#import "ListItem.h"
#import "PersistenceManager.h"
#import "TestDataGenerator.h"

@interface ListItemTests : XCTestCase {
    PersistenceManager *ourManager;
    NSInteger numRowsGenerated;
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
    [ourManager deleteAllObjectsAndSave];
}

-(void)generateRandomDummyData {
    numRowsGenerated = arc4random_uniform(100);
    [TestDataGenerator generateTestListItemDataWithCount:numRowsGenerated context:ourManager.managedObjectContext];
}

-(void)generateOrderedDummyData {
    numRowsGenerated = arc4random_uniform(100);
    [TestDataGenerator generateNumberedTestListItemsWithCount:numRowsGenerated context:ourManager.managedObjectContext];
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
    [self generateRandomDummyData];
    NSArray *allObjects = [ListItem allObjectsInContext:ourManager.managedObjectContext];
    NSInteger countRows = [allObjects count];
    ListItem *ourListItem = [allObjects lastObject];
    [ourManager deleteObject:ourListItem];
    
    NSInteger newCount = [[ListItem allObjectsInContext:ourManager.managedObjectContext] count];
    XCTAssertEqual(newCount, countRows - 1, @"The item was not successfully deleted in the db.");
}

-(void)testListOrderCorrectnessAfterCreatingNewObject {
    [self resetPersistenceLayer];
    [self generateOrderedDummyData];
    ListItem *newListItem = [ListItem newOrderedItemInContext:ourManager.managedObjectContext];
    [newListItem save];
    NSNumber *expectedNumber = [NSNumber numberWithInt:numRowsGenerated]; //We are checking against numRows because listOrder is 0 based.
    XCTAssertTrue([expectedNumber isEqualToNumber:newListItem.listOrder], @"List order should be %@, got back %@", expectedNumber, newListItem.listOrder);
}

-(void)testReorderingOfListItems {
    [self resetPersistenceLayer];
    [self generateOrderedDummyData];
    NSInteger orderInt = arc4random_uniform(numRowsGenerated - 1);
    NSNumber *order = [NSNumber numberWithInteger:orderInt];
    
    
    ListItem *newListItem = [ListItem newInContext:ourManager.managedObjectContext];
    NSString *newItemTitle = [NSString stringWithFormat:@"I should be in the %@th place!", order];
    newListItem.title = newItemTitle;
    newListItem.creationDate = [NSDate date];
    newListItem.completed = [NSNumber numberWithBool:NO];
    newListItem.listOrder = order;
    
    [ListItem insertListItemAndReorderListItems:newListItem inContext:ourManager.managedObjectContext];
    
    [PersistenceManager saveContext:ourManager.managedObjectContext];
    
    NSArray *allListItemsSorted = [ListItem allObjectsSortedByListOrderInContext:ourManager.managedObjectContext];
    
    for (ListItem *item in allListItemsSorted) {
        NSNumber *itemOrder = item.listOrder;
        NSNumber *previousListOrderFromTitle = [NSNumber numberWithInt:[item.title integerValue]];
        if ([itemOrder compare:previousListOrderFromTitle] == NSOrderedSame) {
            XCTAssertTrue([previousListOrderFromTitle integerValue] == [item.listOrder integerValue], @"Item with list order #%@ should have the same order as contained in its title.  Title is %@.", item.listOrder, item.title);
        } else if ([itemOrder compare:order] == NSOrderedSame) {
            XCTAssertTrue([item.title isEqualToString:newItemTitle], @"Item with list order #%@ should have title '%@'. It doesn't. Reordering failed!", order, newItemTitle);
        } else if ([itemOrder compare:previousListOrderFromTitle] == NSOrderedDescending) {
            
            NSInteger orderIntFromTitle = [previousListOrderFromTitle integerValue];
            NSInteger expectedListOrder = [item.listOrder integerValue] - 1;
            XCTAssertTrue(orderIntFromTitle == expectedListOrder, @"Item with list order #%@ should have had %@ set as its title, instead it's %@. Reordering failed!", item.listOrder, previousListOrderFromTitle, item.title);
        } else {
            XCTFail(@"Comparison didn't happen. Something is wrong.");
        }
    }
}

@end
