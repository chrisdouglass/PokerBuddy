#import "RootTabBarController.h"

#import "CasinoListTableViewController.h"
#import "RangeExplorerViewController.h"
#import "Model/Store.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootTabBarController ()
@property(nonatomic, readonly) CasinoListTableViewController *casinoListViewController;
@property(nonatomic) Store *store;
@end

@implementation RootTabBarController

+ (instancetype)rootTabBarControllerWithStore:(Store *)store {
  RootTabBarController *rootTabBarController =
      [[RootTabBarController alloc] initWithNibName:nil bundle:nil];
  rootTabBarController.store = store;
  [rootTabBarController setupViewControllers];
  return rootTabBarController;
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

@end

NS_ASSUME_NONNULL_END
