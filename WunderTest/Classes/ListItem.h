//
//  ListItem.h
//  WunderTest
//
//  Created by Alexander Freas on 11/12/13.
//  Copyright (c) 2013 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * listOrder;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * completed;

@end
