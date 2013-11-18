#import <XCTest/XCTest.h>
#import "ListTableView.h"
#import "TestDataGenerator.h"
#import "PersistenceManager.h"
#import "ListItem.h"
#import "NSFetchedResultsControllerFactory.h"
@interface TableViewTests : XCTestCase

@end

@implementation TableViewTests {
    
    PersistenceManager *ourManager;
    ListTableView *tableView;
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
    [ourManager deleteAllObjects];
    tableView = [[ListTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    tableView.fetchController = [NSFetchedResultsControllerFactory fetchControllerForAllListItemsInContext:ourManager.managedObjectContext];
    tableView.fetchController.delegate = tableView;
    NSError *err = nil;
    [tableView.fetchController performFetch:&err];
    if (err != nil) {
        XCTFail(@"Error performing fetch on tableview's fetch controller in %s", __PRETTY_FUNCTION__);
    }
    numRows = arc4random() % 100;
    [TestDataGenerator generateTestListItemDataWithCount:numRows context:ourManager.managedObjectContext];
    [tableView reloadData];
}

-(void)testTableViewFetchControllerLoadingCorrectness {
    
    [self reset];
    NSInteger numberOfRows = [tableView numberOfRowsInSection:0];
    XCTAssertEqual(numberOfRows, numRows, @"Number of rows in tableview are not the same as number of rows in DB.");
}


@end
