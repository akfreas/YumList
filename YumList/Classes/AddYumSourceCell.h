//
//  AddYumSourceCell.h
//  YumList
//
//  Created by Alexander Freas on 11/24/13.
//  Copyright (c) 2013 Sashimiblade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddYumSourceCell : UITableViewCell

@property (nonatomic, copy) void(^addSourceButtonTapped)(CGFloat newSize);
@property (nonatomic, copy) void(^expandAnimationCompleted)();

@end
