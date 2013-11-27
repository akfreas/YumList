#import <XCTest/XCTest.h>
#import "PersistenceManager.h"
#import "TestDataGenerator.h"

@interface YumItemTests : XCTestCase {
    PersistenceManager *ourManager;
    NSInteger numRowsGenerated;
}

@end

@implementation YumItemTests

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
    [TestDataGenerator generateTestYumItemDataWithCount:numRowsGenerated context:ourManager.managedObjectContext];
}

-(void)generateOrderedDummyData {
    numRowsGenerated = arc4random_uniform(100);
    [TestDataGenerator generateNumberedTestYumItemsWithCount:numRowsGenerated context:ourManager.managedObjectContext];
}

-(void)testCreateAndSaveYumItem {
    YumItem *ourYumItem = [YumItem newInContext:ourManager.managedObjectContext];
    [ourYumItem saveInContext:ourManager.managedObjectContext];
}

-(void)testPersistYumItemSavesToDisk {
    
    NSString *title = @"Get some fresh air.";
    NSDate *creationDate = [NSDate date];
    NSNumber *listOrder = [NSNumber numberWithInteger:1];
    NSNumber *completed = [NSNumber numberWithBool:NO];
    
    YumItem *ourYumItem = [YumItem newInContext:ourManager.managedObjectContext];
    ourYumItem.title = title;
    ourYumItem.syncDate = creationDate;
    ourYumItem.listOrder = listOrder;
    ourYumItem.completed = completed;
    [ourYumItem saveInContext:ourManager.managedObjectContext];
    [ourManager resetManagedObjectContext];
    NSArray *allItems = [YumItem allObjectsInContext:ourManager.managedObjectContext];
    NSUInteger itemIndex = [allItems indexOfObjectPassingTest:^BOOL(YumItem *item, NSUInteger index, BOOL *stop) {
        if ([item.title isEqualToString:title] && [item.syncDate isEqualToDate:creationDate]) {
            return YES;
        } else {
            return NO;
        };
    }];
    YumItem *savedObject = allItems[itemIndex];
    XCTAssertTrue([savedObject.title isEqualToString:title], @"Title was not saved correctly.");
    XCTAssertTrue([savedObject.syncDate isEqualToDate:creationDate], @"Date was not saved correctly.");
    XCTAssertTrue([savedObject.listOrder isEqualToNumber:listOrder], @"List order was not saved correctly.");
    XCTAssertTrue([savedObject.completed isEqualToNumber:completed], @"Completed value was not saved correctly.");    
}


-(void)testCoreDataDeletionCorrectness {
    
    [self resetPersistenceLayer];
    [self generateRandomDummyData];
    NSArray *allObjects = [YumItem allObjectsInContext:ourManager.managedObjectContext];
    NSInteger countRows = [allObjects count];
    YumItem *ourYumItem = [allObjects lastObject];
    [ourManager deleteObject:ourYumItem];
    
    NSInteger newCount = [[YumItem allObjectsInContext:ourManager.managedObjectContext] count];
    XCTAssertEqual(newCount, countRows - 1, @"The item was not successfully deleted in the db.");
}

-(void)testListOrderCorrectnessAfterCreatingNewObject {
    [self resetPersistenceLayer];
    [self generateOrderedDummyData];
    YumItem *newYumItem = [YumItem newInContext:ourManager.managedObjectContext];
    [newYumItem save];
    NSNumber *expectedNumber = [NSNumber numberWithInt:numRowsGenerated]; //We are checking against numRows because listOrder is 0 based.
    XCTAssertTrue([expectedNumber isEqualToNumber:newYumItem.listOrder], @"List order should be %@, got back %@", expectedNumber, newYumItem.listOrder);
}

-(void)testReorderingOfYumItems {
    [self resetPersistenceLayer];
    [self generateOrderedDummyData];
    NSInteger orderInt = arc4random_uniform(numRowsGenerated - 1);
    NSNumber *order = [NSNumber numberWithInteger:orderInt];
    
    
    YumItem *newYumItem = [YumItem newInContext:ourManager.managedObjectContext];
    NSString *newItemTitle = [NSString stringWithFormat:@"I should be in the %@th place!", order];
    newYumItem.title = newItemTitle;
    newYumItem.syncDate = [NSDate date];
    newYumItem.completed = [NSNumber numberWithBool:NO];
    newYumItem.listOrder = order;
    
    [YumItem insertYumItemAndReorderYumItems:newYumItem inContext:ourManager.managedObjectContext];
    
    [ourManager save];
    
    NSArray *allYumItemsSorted = [YumItem allObjectsSortedByListOrderInContext:ourManager.managedObjectContext];
    
    for (YumItem *item in allYumItemsSorted) {
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
