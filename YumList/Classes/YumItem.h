//
//  YumItem.h
//  YumList
//
//  Created by Alexander Freas on 11/27/13.
//  Copyright (c) 2013 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YumPhoto, YumSource;

@interface YumItem : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * externalSiteTitle;
@property (nonatomic, retain) NSString * externalURL;
@property (nonatomic, retain) NSString * externalYumID;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * listOrder;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSDate * syncDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) YumSource *source;
@property (nonatomic, retain) NSSet *photos;
@end

@interface YumItem (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(YumPhoto *)value;
- (void)removePhotosObject:(YumPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
