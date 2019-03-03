#import "Calculator/HoldemEquityCalculator.h"

#import "hand-dist/HoldemCalculator.h"

NS_ASSUME_NONNULL_BEGIN

@interface HoldemCard ()
+ (Rank)charToRank:(const char)c;
+ (char)rankToChar:(Rank)rank;
+ (Suit)charToSuit:(const char)s;
+ (char)suitToChar:(Suit)suit;
@end

@interface HoldemEquityCalculator ()
@end

@implementation HoldemEquityCalculator

- (void)calculate {
//  double results[10];
//  int combos[10];
//  HoldemCalculator calc;
////  calc.Calculate("AhKh|Td9s|QQ+,AQs+,AQo+|JJ-88|XxXx|XxXx|XxXx", "Ks7d4d", "", 100000, combos, results);
//  calc.Calculate("Ah7d,Ah7s,Ah7c|KdKh|22", "7hJh2h", "", 100000, combos, results);
//  NSLog(@"");
}

- (NSArray<HandDistribution *> *)
    createHandDistributionsFromHandListString:(NSString *)handListString {
  NSArray<NSString *> *handStrings = [handListString componentsSeparatedByString:@"|"];
  StdDeck_CardMask staticPlayerCards;
  StdDeck_CardMask_RESET(staticPlayerCards);
  NSMutableArray<HandDistribution *> *distributions = [NSMutableArray array];
  for (NSString *handString in handStrings) {
    [distributions addObject:[HandDistribution distributionFromString:handString]];
  }
  return distributions;
}

@end

@implementation HandDistribution

+ (instancetype)distributionFromString:(NSString *)string {
  if ([string isEqualToString:@"**"]) {
    return [HandDistribution allHandsDistribution];
  } else if ([string containsString:@"-"]) {
    return [HandDistribution rangeDistributionFromString:string];
  } else if ([string containsString:@"+"]) {
    return [HandDistribution minimumHandDistributionFromString:string];
  }
  return [HandDistribution singleHandDistributionFromString:string];
}

+ (instancetype)allHandsDistribution {
  NSMutableSet<HoldemHand *> *hands = [NSMutableSet set];
  for (Rank rank1 = StdDeck_Rank_FIRST; rank1 <= StdDeck_Rank_LAST; rank1++) {
    for (Suit suit1 = StdDeck_Suit_FIRST; suit1 <= StdDeck_Suit_LAST; suit1++) {
      for (Rank rank2 = StdDeck_Rank_FIRST; rank2 <= StdDeck_Rank_LAST; rank2++) {
        for (Suit suit2 = StdDeck_Rank_FIRST; suit2 <= StdDeck_Suit_LAST; suit2++) {
          if (rank1 == rank2 && suit1 == suit2) {
            continue;
          }
          HoldemHand *hand = [[HoldemHand alloc] init];
          hand.card1 = [HoldemCard cardWithRank:rank1 andSuit:suit1];
          hand.card2 = [HoldemCard cardWithRank:rank2 andSuit:suit2];
          [hands addObject:hand];
        }
      }
    }
  }
  return [[HandDistribution alloc] initWithHandSet:hands];
}

+ (instancetype)singleHandDistributionFromString:(NSString *)string {
  NSAssert(string.length == 4, @"Invalid single hand string %@", string);
  return [[HandDistribution alloc] initWithHands:@[ [HoldemHand handFromString:string] ]];
}

+ (instancetype)rangeDistributionFromString:(NSString *)string {
  NSArray<NSString *> *strings = [string componentsSeparatedByString:@"-"];
  NSAssert(strings.count == 2, @"Too many components %@", string);
  if (strings[0].length == 2 && strings[1].length == 2) {
    return [self pocketPairRangeDistributionFromStrings:strings];
  }
  NSAssert(NO, @"Unhandled string %@", string);
  return [[HandDistribution alloc] init];
}

+ (instancetype)pocketPairRangeDistributionFromStrings:(NSArray<NSString *> *)strings {
  Rank startRank = [HoldemCard charToRank:[strings[0] characterAtIndex:0]];
  Rank endRank = [HoldemCard charToRank:[strings[1] characterAtIndex:0]];
  NSMutableSet<HoldemHand *> *hands = [NSMutableSet set];
  for (Rank r = startRank; r <= endRank; r++) {
    for (Suit firstSuit = StdDeck_Suit_FIRST; firstSuit <= StdDeck_Suit_LAST; firstSuit++) {
      for (Suit secondSuit = firstSuit + 1; secondSuit <= StdDeck_Suit_LAST;
           secondSuit++) {
        HoldemHand *hand = [[HoldemHand alloc] init];
        hand.card1 = [HoldemCard cardWithRank:r andSuit:firstSuit];
        hand.card2 = [HoldemCard cardWithRank:r andSuit:secondSuit];
        [hands addObject:hand];
      }
    }
  }
  return [[HandDistribution alloc] initWithHandSet:hands];
}

+ (instancetype)minimumHandDistributionFromString:(NSString *)string {
  return [[HandDistribution alloc] init];
}

- (instancetype)initWithHands:(NSArray<HoldemHand *> *)hands {
  return [self initWithHandSet:[NSSet setWithArray:hands]];
}

- (instancetype)initWithHandSet:(NSSet<HoldemHand *> *)handSet {
  self = [super init];
  if (self) {
    _allHands = handSet;
  }
  return self;
}

@end

@implementation HoldemCard

+ (nullable instancetype)cardFromString:(NSString *)string {
  NSAssert(string.length == 2, @"Card string must be exactly two characters: %@", string);
  Rank rank = [[self class] charToRank:[string characterAtIndex:0]];
  Suit suit = [[self class] charToSuit:[string characterAtIndex:1]];
  return [HoldemCard cardWithRank:rank andSuit:suit];
}

// Does not validate.
+ (instancetype)cardWithRank:(Rank)rank andSuit:(Suit)suit {
  HoldemCard *card = [[HoldemCard alloc] init];
  card->_rank = rank;
  card->_suit = suit;
  card->_mask = StdDeck_MASK(StdDeck_MAKE_CARD(rank, suit));
  return card;
}

- (BOOL)isEqualToCard:(HoldemCard *)card {
  return StdDeck_CardMask_EQUAL(self.mask, card.mask);
}

+ (Rank)charToRank:(const char)c {
	switch (c) {
    case 'A': case 'a':	return StdDeck_Rank_ACE;
    case 'K': case 'k':	return StdDeck_Rank_KING;
    case 'Q': case 'q':	return StdDeck_Rank_QUEEN;
    case 'J': case 'j': return StdDeck_Rank_JACK;
    case 'T': case 't': return StdDeck_Rank_TEN;
    case '9':	          return StdDeck_Rank_9;
    case '8':	          return StdDeck_Rank_8;
    case '7':	          return StdDeck_Rank_7;
    case '6':	          return StdDeck_Rank_6;
    case '5':	          return StdDeck_Rank_5;
    case '4':	          return StdDeck_Rank_4;
    case '3':	          return StdDeck_Rank_3;
    case '2':	          return StdDeck_Rank_2;
    case 'X': case 'x': return 0;
	};

	return -1;
}

+ (char)rankToChar:(Rank)rank {
  switch (rank) {
    case StdDeck_Rank_ACE:  return 'A';
    case StdDeck_Rank_KING: return 'K';
    case StdDeck_Rank_QUEEN: return 'Q';
    case StdDeck_Rank_JACK: return 'J';
    case StdDeck_Rank_TEN: return 'T';
    case StdDeck_Rank_9: return '9';
    case StdDeck_Rank_8: return '8';
    case StdDeck_Rank_7: return '7';
    case StdDeck_Rank_6: return '6';
    case StdDeck_Rank_5: return '5';
    case StdDeck_Rank_4: return '4';
    case StdDeck_Rank_3: return '3';
    case StdDeck_Rank_2: return '2';
    case 'X': case 'x': return 0;
	};
  return NULL;
}

+ (Suit)charToSuit:(const char)s {
	switch (s) {
    case 'S': case 's':	return StdDeck_Suit_SPADES;
    case 'C': case 'c':	return StdDeck_Suit_CLUBS;
    case 'D': case 'd':	return StdDeck_Suit_DIAMONDS;
    case 'H': case 'h':	return StdDeck_Suit_HEARTS;
	};

	return -1;
}

+ (char)suitToChar:(Suit)suit {
  switch (suit) {
    case StdDeck_Suit_SPADES: return 's';
    case StdDeck_Suit_CLUBS: return 'c';
    case StdDeck_Suit_DIAMONDS: return 'd';
    case StdDeck_Suit_HEARTS: return 'h';
	};
  return NULL;
}

@end

@implementation HoldemHand

+ (instancetype)handFromString:(NSString *)string {
  HoldemHand *hand = [[HoldemHand alloc] init];
  hand.card1 = [HoldemCard cardFromString:[string substringWithRange:NSMakeRange(0, 2)]];
  hand.card2 = [HoldemCard cardFromString:[string substringWithRange:NSMakeRange(2, 2)]];
  return hand;
}

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[HoldemHand class]]) {
    return NO;
  }
  return [self isEqualToHand:object];
}

- (BOOL)isEqualToHand:(HoldemHand *)hand {
  return ([self.card1 isEqualToCard:hand.card1] && [self.card2 isEqualToCard:hand.card2]) ||
         ([self.card1 isEqualToCard:hand.card2] && [self.card2 isEqualToCard:hand.card1]);
}

- (NSUInteger)hash {
  return (self.card1.rank + self.card2.rank) * 7 + (self.card1.suit + self.card2.suit) * 13;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%c%c%c%c", [HoldemCard rankToChar:self.card1.rank],
          [HoldemCard suitToChar:self.card1.suit], [HoldemCard rankToChar:self.card2.rank],
          [HoldemCard suitToChar:self.card2.suit]];
}

@end

NS_ASSUME_NONNULL_END
