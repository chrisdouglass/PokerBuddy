#import "AppDelegate.h"

#import "RootTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  RootTabBarController *rootTabView = [RootTabBarController rootTabBarController];
  self.window.rootViewController = rootTabView;
  [self.window makeKeyAndVisible];

  return YES;
}

@end
