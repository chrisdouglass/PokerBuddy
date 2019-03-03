#import "Calculator/PokerHoldemCalculator.h"

#import "HoldemCalculator.h"

NS_ASSUME_NONNULL_BEGIN

@interface PokerHoldemCalculator ()
@end

@implementation PokerHoldemCalculator

- (void)calculate {
  double results[10];
  int combos[10];
  HoldemCalculator calc;
  calc.Calculate("AhKh|Td9s|QQ+,AQs+,AQo+|JJ-88|XxXx|XxXx|XxXx", "Ks7d4d", "", 100000, combos, results);
  NSLog(@"");
}

@end

NS_ASSUME_NONNULL_END
