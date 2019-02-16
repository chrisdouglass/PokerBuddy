#import <UIKit/UIKit.h>

@class Hand;

NS_ASSUME_NONNULL_BEGIN

@interface HandChartViewController : UICollectionViewController

@property(nonatomic, copy, readonly) NSArray<Hand *> *hands;
@property(nonatomic, copy) NSSet<Hand *> *selectedHands;

+ (instancetype)handChartViewControllerFromHands:(NSArray<Hand *> *)hands;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
