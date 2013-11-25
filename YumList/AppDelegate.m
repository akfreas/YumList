#import "AppDelegate.h"
#import "PersistenceManager.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>


@implementation AppDelegate {
    SWRevealViewController *revealController;
}

+(SWRevealViewController *)sharedRevealController {
    static SWRevealViewController *revealController;
    if (revealController == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            revealController = [[SWRevealViewController alloc] init];
        });
    }
    return revealController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController *mainController = [MainViewController new];
    LeftViewController *leftController = [[LeftViewController alloc] init];
    revealController = [AppDelegate sharedRevealController];
    revealController.rearViewController = leftController;
    revealController.frontViewController = mainController;
    self.window.rootViewController = revealController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [PersistenceManager save];
}

@end
