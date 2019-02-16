#import "AppDelegate.h"

#import "RangeExplorerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  RangeExplorerViewController *rangeExplorer =
      [[RangeExplorerViewController alloc] initWithNibName:nil bundle:nil];
  rangeExplorer.title = @"Holdem Range Explorer";
  UINavigationController *navController =
      [[UINavigationController alloc] initWithRootViewController:rangeExplorer];
  self.window.rootViewController = navController;
  [self.window makeKeyAndVisible];
  return YES;
}


@end
