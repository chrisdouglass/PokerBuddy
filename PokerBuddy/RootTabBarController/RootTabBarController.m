#import "RootTabBarController.h"

#import "CasinoListTableViewController.h"
#import "RangeExplorerViewController.h"

#warning remove this
#import "GammaAPIController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootTabBarController ()
@property(nonatomic, readonly) CasinoListTableViewController *casinoListViewController;
@end

@implementation RootTabBarController

+ (instancetype)rootTabBarController {
  RootTabBarController *rootTabBarController =
      [[RootTabBarController alloc] initWithNibName:nil bundle:nil];
  [rootTabBarController setupViewControllers];
  return rootTabBarController;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self gammaTest];
}

- (void)setupViewControllers {
  _casinoListViewController = [CasinoListTableViewController casinoListWithCasinos:nil];
  _casinoListViewController.title = @"Casino List";
  UINavigationController *casinoListNavController =
      [[UINavigationController alloc] initWithRootViewController:_casinoListViewController];

  RangeExplorerViewController *rangeExplorer =
      [[RangeExplorerViewController alloc] initWithNibName:nil bundle:nil];
  rangeExplorer.title = @"Range Explorer";
  UINavigationController *rangeExplorerNavController =
      [[UINavigationController alloc] initWithRootViewController:rangeExplorer];

  self.viewControllers = @[ rangeExplorerNavController, casinoListNavController ];
}

#warning remove
- (void)gammaTest {
  GammaAPIController *controller = [[GammaAPIController alloc] init];
  [controller casinosByLocation:nil
                  radiusInMiles:10000
              completionHandler:
   ^(NSArray<GammaCasino *> *_Nullable casinos, NSError *_Nullable error) {
     dispatch_async(dispatch_get_main_queue(), ^{
       self.casinoListViewController.casinos = casinos;
     });
  }];
}

@end

NS_ASSUME_NONNULL_END
