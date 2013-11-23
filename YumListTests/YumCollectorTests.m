#import <XCTest/XCTest.h>
#import "TFHpple.h"
#import "YumItem.h"
#import "PersistenceManager.h"
#import "YumParser.h"

@interface YumCollectorTests : XCTestCase

@end

@implementation YumCollectorTests {
    PersistenceManager *ourManager;
    NSData *yumData;
    NSArray *parsedArray;
}

- (void)setUp
{
    [super setUp];
    ourManager = [PersistenceManager new];
    
    NSString *fixturePath = [[NSBundle bundleForClass:self.class] pathForResource:@"yum-collection" ofType:@"html"];
    yumData = [NSData dataWithContentsOfFile:fixturePath];
    parsedArray = [YumParser parseYumData:yumData];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


-(void)testYumParser {
    
    NSInteger expectedYums = 40;
    XCTAssertTrue(expectedYums == [parsedArray count], @"The number of yums stored to the db should have been %i, instead it was %i", expectedYums, [parsedArray count]);
}

-(void)testYumItemPersistenceFromParser {
    
    for (NSDictionary *parsedDict in parsedArray) {
        YumItem *item = [YumItem newInContext:ourManager.managedObjectContext];
        item.title = parsedDict[@"title"];
        item.externalURL = parsedDict[@"externalURL"];
        item.externalYumID = parsedDict[@"externalYumID"];
        item.imageURL = parsedDict[@"imageURL"];
        [item save];
    }
    
    NSInteger count = 0;
    for (NSDictionary *parsedDict in parsedArray) {
        NSString *externalID = parsedDict[@"externalYumID"];
        YumItem *fetchedItem = [YumItem itemWithExternalID:externalID];
        XCTAssertNotNil(fetchedItem, @"Could not find item with external ID %@ in context %@", externalID, ourManager.managedObjectContext);
        count++;
    }
    NSArray *allYumItems = [YumItem allObjectsInContext:ourManager.managedObjectContext];
    NSInteger yumItemCount = [allYumItems count];
    XCTAssertTrue(count == [allYumItems count], @"Number of items found with external IDs from parser is not the same as the number found in the MOC. Expected %i, got back %i.", count, yumItemCount);
    
}

@end
