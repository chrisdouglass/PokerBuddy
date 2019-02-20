#import <UIKit/UIKit.h>

@class GammaCasino;

NS_ASSUME_NONNULL_BEGIN

@interface CasinoListTableViewController : UITableViewController

@property(nonatomic, nullable, copy) NSArray<GammaCasino *> *casinos;

+ (instancetype)casinoListWithCasinos:(nullable NSArray<GammaCasino *> *)casinos;

@end

NS_ASSUME_NONNULL_END
