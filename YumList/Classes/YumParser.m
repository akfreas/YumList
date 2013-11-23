#import "YumParser.h"
#import "TFHpple.h"
@implementation YumParser

+(NSArray *)parseYumData:(NSData *)yumData {
    
    TFHpple *yumlistParser = [TFHpple hppleWithHTMLData:yumData];
    NSString *yCardNodeQueryString = @"//div[@class='y-card']";
    NSArray *yCardNodes = [yumlistParser searchWithXPathQuery:yCardNodeQueryString];
    NSMutableArray *objects = [NSMutableArray new];
    for (TFHppleElement *element in yCardNodes) {
        NSData *leafHTMLData = [element.raw dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *leafParser = [TFHpple hppleWithHTMLData:leafHTMLData];
        NSString *externalYumID = [element objectForKey:@"id"];
        
        TFHppleElement *imageElement = [[leafParser searchWithXPathQuery:@"//a[@class='y-image']/img"] firstObject];
        NSString *imageURL;
        if (imageElement != nil) {
            imageURL = [imageElement objectForKey:@"src"];
        } else {
            imageURL = @"";
        }
        
        NSString *titleXpath = [NSString stringWithFormat:@"//div[@class='y-title']/div/a[@class='y-full']"];
        
        TFHppleElement *linkElement = [[leafParser searchWithXPathQuery:titleXpath] firstObject];
        NSString *externalURL = [NSString stringWithFormat:@"http://www.yummly.com%@", [linkElement objectForKey:@"href"]];
        
        TFHppleElement *titleStringElement = [[leafParser searchWithXPathQuery:@"//h3"] firstObject];;
        NSString *title = [[[titleStringElement children] firstObject] content];
        
        
        
        NSDictionary *parsedObject = NSDictionaryOfVariableBindings(externalYumID, externalURL, title, imageURL);
        [objects addObject:parsedObject];
    }
    return objects;
}

@end
