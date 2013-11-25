@interface AddYumSourceView : UIView

@property (nonatomic, copy) void(^addSourceButtonTapped)(CGFloat newSize);
@property (nonatomic, copy) void(^expandAnimationCompleted)();

@end
