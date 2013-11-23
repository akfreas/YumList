#import "FormatUtils.h"

@implementation FormatUtils

#pragma mark Public Methods

+(NSString *)stringFromDate:(NSDate *)date {
    return [[self simpleDateFormatter] stringFromDate:date];
}

#pragma mark Private Methods

+(NSDateFormatter *)simpleDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    return dateFormatter;
}

@end
