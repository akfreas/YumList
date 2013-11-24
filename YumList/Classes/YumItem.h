//
//  YumItem.h
//  YumList
//
//  Created by Alexander Freas on 11/23/13.
//  Copyright (c) 2013 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YumItem : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * externalURL;
@property (nonatomic, retain) NSString * externalYumID;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSDate * syncDate;
@property (nonatomic, retain) NSString * title;

@end
