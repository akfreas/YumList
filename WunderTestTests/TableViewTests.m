#import <XCTest/XCTest.h>
#import "ListTableView.h"
#import "TestDataGenerator.h"
#import "PersistenceManager.h"
#import "ListItem.h"
@interface TableViewTests : XCTestCase

@end

@implementation TableViewTests {
    ListTableView *tableView;
}

- (void)setUp
{
    [super setUp];
    [PersistenceManager deletePersistentStore];
    tableView = [[ListTableView alloc] initWithFrame:CGRectZero];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    [PersistenceManager deletePersistentStore];
}


-(void)testTableView {
    
    NSInteger numRows = arc4random() % 100;

    [TestDataGenerator generateTestListItemDataWithCount:numRows];
    [tableView reloadData];
    NSInteger numberOfRows = [tableView numberOfRowsInSection:0];
    XCTAssertEqual(numberOfRows, numRows, @"Number of rows in tableview are not the same as number of rows in DB.");
}

@end
