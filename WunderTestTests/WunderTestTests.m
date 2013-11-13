#import <XCTest/XCTest.h>
#import "PersistenceManager.h"

@interface WunderTestTests : XCTestCase

@end

@implementation WunderTestTests

- (void)setUp
{
    [super setUp];
    [PersistenceManager setupPersistence];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testPersistenceWasSetup {
    PersistenceManager *manager = [PersistenceManager sharedContext];
    XCTAssertFalse(manager == nil, @"PersistenceManager was not setup, is nil.");
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
