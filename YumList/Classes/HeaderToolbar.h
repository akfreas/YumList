@interface HeaderToolbar : UIToolbar

@property (copy, nonatomic) void(^leftNavigationButtonTappedAction)();
@property (copy, nonatomic) void(^rightNavigationButtonTappedAction)();
@end
