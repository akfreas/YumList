#import <UIKit/UIKit.h>

@interface NSDictionary (MXConstraint)
+ (NSDictionary *)MXTranslateAutoresizingMaskIntoConstraints:(NSDictionary *)bindings;
@end

#define MXDictionaryOfVariableBindings(...) [NSDictionary MXTranslateAutoresizingMaskIntoConstraints:NSDictionaryOfVariableBindings(__VA_ARGS__)]

@interface UIView (LayoutHelpers)
- (void)addConstraintWithVisualFormat:(NSString *)format bindings:(NSDictionary *)bindings;
@end


