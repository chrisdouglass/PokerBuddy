#import "Model/PEHand.h"

#import "Model/PECard.h"

NS_ASSUME_NONNULL_BEGIN

@interface PEHand ()
@end

@implementation PEHand

+ (instancetype)handFromString:(NSString *)string {
  PEHand *hand = [[PEHand alloc] init];
  hand.card1 = [PECard cardFromString:[string substringWithRange:NSMakeRange(0, 2)]];
  hand.card2 = [PECard cardFromString:[string substringWithRange:NSMakeRange(2, 2)]];
  return hand;
}

- (BOOL)containsAtLeastOneCardFromCards:(NSSet<PECard *> *)cards {
  NSSet<PECard *> *handCards = [NSSet setWithObjects:self.card1, self.card2, nil];
  return [cards intersectsSet:handCards];
}

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[PEHand class]]) {
    return NO;
  }
  return [self isEqualToHand:object];
}

- (BOOL)isEqualToHand:(PEHand *)hand {
  // TODO: Do with a set operation instead if it's faster.
  return ([self.card1 isEqualToCard:hand.card1] && [self.card2 isEqualToCard:hand.card2]) ||
         ([self.card1 isEqualToCard:hand.card2] && [self.card2 isEqualToCard:hand.card1]);
}

- (NSUInteger)hash {
  return (self.card1.rank + self.card2.rank) * 7 + (self.card1.suit + self.card2.suit) * 13;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%c%c%c%c", [PECard rankToChar:self.card1.rank],
          [PECard suitToChar:self.card1.suit], [PECard rankToChar:self.card2.rank],
          [PECard suitToChar:self.card2.suit]];
}

@end

NS_ASSUME_NONNULL_END
