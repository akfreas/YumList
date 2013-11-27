#import <XCTest/XCTest.h>
#import "YumListTableView.h"
#import "TestDataGenerator.h"
#import "PersistenceManager.h"
#import "NSFetchedResultsControllerFactory.h"
@interface TableViewTests : XCTestCase

@end

@implementation TableViewTests {
    
    PersistenceManager *ourManager;
    YumListTableView *tableView;
    NSInteger numRows;
}

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

-(void)reset {
    tableView = nil;
    [ourManager deleteAllObjectsAndSave];
    tableView = [[YumListTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    tableView.fetchController = [NSFetchedResultsControllerFactory fetchControllerForAllYumItemsInContext:ourManager.managedObjectContext];
    tableView.fetchController.delegate = tableView;
    NSError *err = nil;
    [tableView.fetchController performFetch:&err];
    if (err != nil) {
        XCTFail(@"Error performing fetch on tableview's fetch controller in %s", __PRETTY_FUNCTION__);
    }
}

-(void)generateOrderedYumItems {
    numRows = arc4random_uniform(100);
    [TestDataGenerator generateTestYumItemDataWithCount:numRows context:ourManager.managedObjectContext];

}

-(void)testTableViewFetchControllerLoadingCorrectness {
    
    [self reset];
    [self generateOrderedYumItems];
    [tableView reloadData];
    
    NSInteger numberOfRows = [tableView numberOfRowsInSection:0];
    XCTAssertEqual(numberOfRows, numRows, @"Number of rows in tableview are not the same as number of rows in DB.");
}

-(void)testTableViewListOrderCorrectnessAfterInsertion {
    
    [self reset];
    [self generateOrderedYumItems];
    [tableView reloadData];
    
    NSIndexPath *currentIndexPath;
    for (int i=0; i<numRows; i++) {
        currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        YumItem *currentItem = [tableView.fetchController objectAtIndexPath:currentIndexPath];
        XCTAssertEqual(i, [currentItem.listOrder integerValue], @"Ordering for '%@' should be %i, is %@", currentItem.title, i, currentItem.listOrder);
    }
}

-(void)testTableViewReorderCorrectnessAfterMove {
    [self reset];
    [self generateOrderedYumItems];
    [tableView reloadData];
    arc4random_stir();
    NSInteger currentRow = arc4random_uniform(numRows);
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
    NSInteger newRow = arc4random_uniform(numRows);
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    
    YumItem *currentIndexPathItem = [tableView.fetchController objectAtIndexPath:currentIndexPath];
    XCTAssertTrue([currentIndexPathItem.listOrder isEqualToNumber:[NSNumber numberWithInteger:currentRow]], @"The list item currently in row %i does not have a listOrder value equal to the row. Instead, it's %@", currentRow, currentIndexPathItem.listOrder);
    tableView.editing = YES;
    [tableView moveRowAtIndexPath:currentIndexPath toIndexPath:newIndexPath];
    tableView.editing = NO;
    NSError *err = nil;
    [tableView.fetchController performFetch:&err];
    XCTAssertNil(err, @"Error fetching items with fetch controller. Error: %@", err);
    YumItem *newIndexPathItem = [tableView.fetchController objectAtIndexPath:newIndexPath];
    
    XCTAssertTrue(newIndexPathItem.objectID == currentIndexPathItem.objectID, @"The list item currently in row %i is not the same as the one we attempted to move. \nWhat's there now: %@\nWhat should be there:%@\n", newIndexPath.row, newIndexPathItem, currentIndexPathItem);
}


@end
