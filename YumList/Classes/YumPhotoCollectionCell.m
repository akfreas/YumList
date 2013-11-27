#import "YumPhoto.h"
#import "YumPhotoCollectionCell.h"

@implementation YumPhotoCollectionCell {
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)addImageView {
    if (imageView == nil) {
        UIImage *image = [UIImage imageWithData:self.photo.image];
        imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
    }
}

-(void)addLayoutConstraints {
    NSDictionary *bindings = MXDictionaryOfVariableBindings(imageView);
    [self addConstraintWithVisualFormat:@"V:|-[imageView]-|" bindings:bindings];
    [self addConstraintWithVisualFormat:@"H:|-[imageView]-|" bindings:bindings];
}

#pragma mark Accessors

-(void)setPhoto:(YumPhoto *)photo {
    _photo = photo;
    [self addImageView];
    [self addLayoutConstraints];
}

@end
