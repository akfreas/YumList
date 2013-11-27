//
//  YumPhoto.h
//  YumList
//
//  Created by Alexander Freas on 11/27/13.
//  Copyright (c) 2013 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YumItem;

@interface YumPhoto : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * dateTaken;
@property (nonatomic, retain) YumItem *yumItem;

@end
