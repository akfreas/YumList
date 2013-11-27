#import <XCTest/XCTest.h>
#import "TFHpple.h"
#import "YumItem.h"
#import "PersistenceManager.h"
#import "YumParser.h"
#import "YumCollector.h"
#import "YumSource.h"
#import "NSManagedObject+Helpers.h"

#define StartOperation() __block BOOL waitingForBlock = YES
#define CompleteOperation() waitingForBlock = NO

#define WaitUntilDone()  while(waitingForBlock) {\
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode\
                         beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];\
}

@interface YumCollectorTests : XCTestCase

@end

@implementation YumCollectorTests {
    PersistenceManager *ourManager;
    NSData *yumData;
    NSArray *parsedArray;
}

-(void)setUp {
    [super setUp];
    ourManager = [PersistenceManager new];
    NSString *fixturePath = [[NSBundle bundleForClass:self.class] pathForResource:@"yum-collection" ofType:@"html"];
    yumData = [NSData dataWithContentsOfFile:fixturePath];
    parsedArray = [YumParser parseYumData:yumData];
}

-(void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)createDefaultYumSource {
    YumSource *source = [YumSource newInContext:ourManager.managedObjectContext];
    source.name = @"All Yums";
    source.sourceURL = @"http://www.yummly.com/profile/AlexanderFreas/collections/all-yums";
    source.order = [NSNumber numberWithInt:0];
    [source save];
}


-(void)testYumParser {
    
    NSInteger expectedYums = 40;
    XCTAssertTrue(expectedYums == [parsedArray count], @"The number of yums stored to the db should have been %i, instead it was %i", expectedYums, [parsedArray count]);
}

-(void)testYumItemPersistenceFromParser {
    [ourManager deleteAllObjectsAndSave];
    for (NSDictionary *parsedDict in parsedArray) {
        YumItem *item = [YumItem newInContext:ourManager.managedObjectContext];
        item.title = parsedDict[@"title"];
        item.externalURL = parsedDict[@"externalURL"];
        item.externalYumID = parsedDict[@"externalYumID"];
        item.imageURL = parsedDict[@"imageURL"];
        [item saveInContext:ourManager.managedObjectContext];
    }
    
    NSInteger count = 0;
    for (NSDictionary *parsedDict in parsedArray) {
        NSString *externalID = parsedDict[@"externalYumID"];
        YumItem *fetchedItem = [YumItem itemWithExternalID:externalID context:ourManager.managedObjectContext];
        XCTAssertNotNil(fetchedItem, @"Could not find item with external ID %@ in context %@", externalID, ourManager.managedObjectContext);
        count++;
    }
    NSArray *allYumItems = [YumItem allObjectsInContext:ourManager.managedObjectContext];
    NSInteger yumItemCount = [allYumItems count];
    XCTAssertTrue(count == [allYumItems count], @"Number of items found with external IDs from parser is not the same as the number found in the MOC. Expected %i, got back %i.", count, yumItemCount);
    
}

-(void)testFetchYumItemListFromServer {
    [ourManager deleteAllObjectsAndSave];
    [self createDefaultYumSource];
    YumCollector *collector = [[YumCollector alloc] init];
    StartOperation();
    [collector syncAllYums:^(NSArray *newYums) {
        XCTAssertNotNil(newYums, @"Error fetching yums from server.");
        CompleteOperation();
    } context:ourManager.managedObjectContext];
    WaitUntilDone();
}

-(void)testYumListSyncCorrectness {
    [ourManager deleteAllObjectsAndSave];
    [self createDefaultYumSource];
    YumCollector *collector = [[YumCollector alloc] init];
    StartOperation();
    __block NSString *aNewYumExternalID;
    [collector syncAllYums:^(NSArray *newYums) {
        CompleteOperation();
        YumItem *newYum = [newYums firstObject];
        aNewYumExternalID = newYum.externalYumID;
        XCTAssertNotNil(newYums, @"Error fetching yums from server.");
    } context:ourManager.managedObjectContext];
    WaitUntilDone();
    YumItem *item = [YumItem itemWithExternalID:aNewYumExternalID context:ourManager.managedObjectContext];
    [item delete];
    [ourManager save];
    [collector syncAllYums:^(NSArray *newYums) {
        CompleteOperation();
        NSInteger newYumCount = [newYums count];
        XCTAssertTrue(newYumCount == 1, @"The number of new yums retrieved from the server is not equal to the number of expected yums.  Got back %i, expected 1", newYumCount);
        YumItem *item = newYums[0];
        XCTAssertTrue([item.externalYumID isEqualToString:aNewYumExternalID], @"The external yum id from the server (%@) didn't match the one we expected (%@)", item.externalYumID, aNewYumExternalID);
        
    } context:ourManager.managedObjectContext];
    WaitUntilDone();
}

-(void)testYumItemParseCorrectness {
    [ourManager deleteAllObjectsAndSave];
    YumCollector *collector = [[YumCollector alloc] init];
    
}

@end
