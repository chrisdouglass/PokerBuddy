#import "AppDelegate.h"

#import "LocationManager/LocationManager.h"
#import "Model/Store.h"
#import "RootTabBarController/RootTabBarController.h"
#import "ToastManager/ToastManager.h"

#warning remove this
#import "GammaAPIController.h"
#import "GammaCasino.h"
#import "Calculator/PokerHoldemCalculator.h"

@interface AppDelegate () <LocationManagerDelegate>
@property(nonatomic, readonly) LocationManager *locationManager;
@end

@implementation AppDelegate {
  Store *_store;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  _store = [[Store alloc] init];
  RootTabBarController *rootTabView =
      [RootTabBarController rootTabBarControllerWithStore:_store];
  self.window.rootViewController = rootTabView;
  [self.window makeKeyAndVisible];

  _locationManager = [LocationManager locationManagerWithDelegate:self];

  dispatch_async(dispatch_get_main_queue(), ^{
    [self doTest];
  });

  return YES;
}

- (void)locationManagerDidUpdateLocation:(LocationManager *)locationManager {
  NSLog(@"location: %@", locationManager.currentLocation);

  GammaAPIController *controller = [[GammaAPIController alloc] init];
  // Using San Jose for now.
  [controller casinosByLocation:locationManager.currentLocation
                  radiusInMiles:12500  // 1/2 earth circumference
              completionHandler:
   ^(NSArray<GammaCasino *> *_Nullable casinos, NSError *_Nullable error) {
     dispatch_async(dispatch_get_main_queue(), ^{
       [self->_store updateCasinosFromGammaCasinos:casinos];
       [self->_store save:nil];
       NSLog(@"Casinos updated.");
       [[ToastManager manager] showToast:@"Casinos updated."];
     });
  }];
}

#warning remove
- (void)doTest {
  PokerHoldemCalculator *calc = [[PokerHoldemCalculator alloc] init];
  [calc calculate];
}

@end
