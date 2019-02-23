#import <UIKit/UIKit.h>

@class Store;

NS_ASSUME_NONNULL_BEGIN

@interface CasinoListTableViewController : UITableViewController

+ (instancetype)casinoListWithStore:(Store *)store;

@end

NS_ASSUME_NONNULL_END
