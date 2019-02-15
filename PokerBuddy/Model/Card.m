#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card ()
@end

@implementation Card

+ (Card *)cardFromString:(NSString *)cardString {
  // TODO: Proper checking.
  CardSuit suit = cardString.length > 1 ?
      [self suitFromString:[cardString substringFromIndex:1]] : CardSuitUndefined;
  return [[[self class] alloc] initWithRank:[cardString substringToIndex:1] suit:suit];
}

- (instancetype)initWithRank:(NSString *)rank suit:(CardSuit)suit {
  self = [super init];
  if (self) {
    _rank = [rank copy];
    _suit = suit;
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@%@", self.rank, [[self class] suitIconForSuit:self.suit]];
}

+ (CardSuit)suitFromString:(NSString *)suitString {
  if ([suitString isEqualToString:@"c"]) {
    return CardSuitClubs;
  } else if ([suitString isEqualToString:@"d"]) {
    return CardSuitDiamonds;
  } else if ([suitString isEqualToString:@"h"]) {
    return CardSuitHearts;
  } else if ([suitString isEqualToString:@"s"]) {
    return CardSuitSpades;
  }
  return CardSuitUndefined;
}

+ (NSString *)suitIconForSuit:(CardSuit)suit {
  switch (suit) {
    case CardSuitHearts:
      return @"♥";
    case CardSuitDiamonds:
      return @"♦";
    case CardSuitClubs:
      return @"♣";
    case CardSuitSpades:
      return @"♠";
    case CardSuitUndefined:
      return @"";
  }
}

@end

NS_ASSUME_NONNULL_END
