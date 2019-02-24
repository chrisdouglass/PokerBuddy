#import "AppDelegate.h"

#import "LocationManager/LocationManager.h"
#import "RootTabBarController/RootTabBarController.h"

@interface AppDelegate () <LocationManagerDelegate>
@property(nonatomic, readonly) LocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  RootTabBarController *rootTabView = [RootTabBarController rootTabBarController];
  self.window.rootViewController = rootTabView;
  [self.window makeKeyAndVisible];

  _locationManager = [LocationManager locationManagerWithDelegate:self];
  return YES;
}

- (void)locationManagerDidUpdateLocation:(LocationManager *)locationManager {
  NSLog(@"location: %@", locationManager.currentLocation);
}

@end
