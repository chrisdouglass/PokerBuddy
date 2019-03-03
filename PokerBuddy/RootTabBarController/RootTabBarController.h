#import <UIKit/UIKit.h>

@class Store;

NS_ASSUME_NONNULL_BEGIN

@interface RootTabBarController : UITabBarController

+ (instancetype)rootTabBarControllerWithStore:(Store *)store;

@end

NS_ASSUME_NONNULL_END
