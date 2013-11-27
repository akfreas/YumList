//
//  YumSource.h
//  YumList
//
//  Created by Alexander Freas on 11/25/13.
//  Copyright (c) 2013 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YumSource : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) NSNumber * order;

@end
