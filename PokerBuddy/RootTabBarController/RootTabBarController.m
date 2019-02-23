#import "RootTabBarController.h"

#import "CasinoListTableViewController.h"
#import "RangeExplorerViewController.h"
#import "Model/Store.h"

#warning remove this
#import "GammaAPIController.h"
#import "GammaCasino.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootTabBarController ()
@property(nonatomic, readonly) CasinoListTableViewController *casinoListViewController;
@property(nonatomic) Store *store;
@end

@implementation RootTabBarController

+ (instancetype)rootTabBarController {
  RootTabBarController *rootTabBarController =
      [[RootTabBarController alloc] initWithNibName:nil bundle:nil];
  rootTabBarController.store = [[Store alloc] init];
  [rootTabBarController setupViewControllers];
  return rootTabBarController;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self gammaTest];
}

- (void)setupViewControllers {
  _casinoListViewController = [CasinoListTableViewController casinoListWithStore:self.store];
  _casinoListViewController.title = @"Poker Rooms";
  _casinoListViewController.tabBarItem.image = [UIImage imageNamed:@"ic_cards"];
  UINavigationController *casinoListNavController =
      [[UINavigationController alloc] initWithRootViewController:_casinoListViewController];

  RangeExplorerViewController *rangeExplorer =
      [[RangeExplorerViewController alloc] initWithNibName:nil bundle:nil];
  rangeExplorer.title = @"Range Explorer";
  rangeExplorer.tabBarItem.image = [UIImage imageNamed:@"ic_calculator"];
  UINavigationController *rangeExplorerNavController =
      [[UINavigationController alloc] initWithRootViewController:rangeExplorer];

  self.viewControllers = @[ casinoListNavController, rangeExplorerNavController ];
}

#warning remove
- (void)gammaTest {
  GammaAPIController *controller = [[GammaAPIController alloc] init];
  // Using San Jose for now.
  [controller casinosByLocation:[[CLLocation alloc] initWithLatitude:37.3382 longitude:-121.8863]
                  radiusInMiles:12500  // 1/2 earth circumference
              completionHandler:
   ^(NSArray<GammaCasino *> *_Nullable casinos, NSError *_Nullable error) {
     dispatch_async(dispatch_get_main_queue(), ^{
       [self.store updateCasinosFromGammaCasinos:casinos];
       [self.store save:nil];
       NSLog(@"Casinos updated.");
     });
  }];
}

@end

NS_ASSUME_NONNULL_END
