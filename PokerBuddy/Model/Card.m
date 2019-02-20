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

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }

  if (self == object) {
    return YES;
  }

  return [self isEqualToCard:object];
}

- (BOOL)isEqualToCard:(Card *)card {
  return [self.rank isEqualToString:card.rank] && self.suit == card.suit;
}

- (NSComparisonResult)compare:(Card *)card {
  return self.cardRank > card.cardRank;
}

- (CardRank)cardRank {
  const char *cString = [self.rank UTF8String];
  return [[self class] cardRankFromCardLetter:cString[0]];
}

- (NSUInteger)hash {
  return [self.rank hash] + self.suit;
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

+ (CardRank)cardRankFromCardLetter:(char)letter {
  switch (letter) {
    case 'A':
      return CardRankA;
    case 'K':
      return CardRankK;
    case 'Q':
      return CardRankQ;
    case 'J':
      return CardRankJ;
    case 'T':
      return CardRankT;
    case '9':
      return CardRank9;
    case '8':
      return CardRank8;
    case '7':
      return CardRank7;
    case '6':
      return CardRank6;
    case '5':
      return CardRank5;
    case '4':
      return CardRank4;
    case '3':
      return CardRank3;
    case '2':
      return CardRank2;
  }
  return 0;
}

@end

NS_ASSUME_NONNULL_END
