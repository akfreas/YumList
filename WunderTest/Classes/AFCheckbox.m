//
//  AFCheckbox.m
//  WunderTest
//
//  Created by Alexander Freas on 11/19/13.
//  Copyright (c) 2013 Sashimiblade. All rights reserved.
//

#import "AFCheckbox.h"

@implementation AFCheckbox {
    UILabel *checkedLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        checkedLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 22, 25)];
        [self addSubview:checkedLabel];
    }
    return self;
}

-(void)setButtonChecked:(void (^)(BOOL checked))buttonChecked {

    if (buttonChecked != NULL) {
        _buttonChecked = buttonChecked;
        [self addEventHandler:[self checkedAction]
             forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void(^)(AFCheckbox *))checkedAction {
    return ^(AFCheckbox *sender) {
        self.checked = !self.checked;
        _buttonChecked(sender.checked);
    };
}

-(void)setChecked:(BOOL)checked {
    _checked = checked;
    if (checked == YES) {
        checkedLabel.text = @"✔";
    } else {
        checkedLabel.text = @"";
    }
}
@end
