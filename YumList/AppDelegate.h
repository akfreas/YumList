@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(SWRevealViewController *)sharedRevealController;

@property (strong, nonatomic) UIWindow *window;


@end
