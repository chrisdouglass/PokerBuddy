#import "AppDelegate.h"

#import "Hand.h"

#import "HandChartViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  NSArray<Hand *> *hands = [Hand holdemHandsSortedByAlpha];
  NSLog(@"%@", [hands valueForKey:@"suitedDescription"]);
  self.window.rootViewController = [HandChartViewController handChartViewControllerFromHands:hands];
  [self.window makeKeyAndVisible];
  return YES;
}


@end
