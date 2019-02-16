#import "Hand.h"

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Hand ()
@end

@implementation Hand

+ (nullable instancetype)handFromString:(NSString *)string {
  // TODO: Proper checking here.
  Card *card1 = nil;
  Card *card2 = nil;
  if (string.length == 2) {
    // Pocket pair, no suits.
    card1 = [Card cardFromString:[string substringToIndex:1]];
    card1.suit = CardSuitHearts;
    card2.suit = CardSuitSpades;
    card2 = [Card cardFromString:[string substringFromIndex:1]];
  } else if (string.length == 3) {
    // Suited/offsuit hand
    unichar suitedChar = [string characterAtIndex:2];
    NSString *card1String = [string substringToIndex:1];
    card1 = [Card cardFromString:card1String];
    card1.suit = CardSuitHearts;
    NSString *card2String = [[string substringFromIndex:1] substringToIndex:1];
    card2 = [Card cardFromString:card2String];
    card2.suit = suitedChar == 's' ? CardSuitHearts : CardSuitClubs;
  }
  return [[[self class] alloc] initWithCards:[NSSet setWithArray:@[ card1, card2 ]]];
}

- (instancetype)init {
  return [self initWithCards:[NSSet set]];
}

- (instancetype)initWithCards:(NSSet<Card *> *)cards {
  self = [super init];
  if (self) {
    _cards = [cards copy];
  }
  return self;
}

- (BOOL)isPocketPair {
  NSArray<Card *> *cards = [self.cards allObjects];
  return [cards[0].rank isEqualToString:cards[1].rank];
}

- (BOOL)isSuited {
  CardSuit suit = [self.cards anyObject].suit;
  for (Card *card in self.cards) {
    if (suit != card.suit || suit == CardSuitUndefined) {
      return NO;
    }
  }
  return YES;
}

- (NSString *)suitedDescription {
  if (!self.cards.count) {
    return @"empty";
  }
  NSArray<Card *> *cards = [self.cards allObjects];
  NSString *rankString = [[cards valueForKey:@"rank"] componentsJoinedByString:@""];
  if ([self isPocketPair]) {
    return rankString;
  }
  return [rankString stringByAppendingString:[self isSuited] ? @"s" : @"o"];
}

- (NSString *)description {
  if (!self.cards.count) {
    return @"empty";
  }

  return [[self.cards valueForKey:@"description"] componentsJoinedByString:@""];
}

+ (NSArray<Hand *> *)holdemHandsSortedByAlpha {
  NSString *filePath =
      [[NSBundle mainBundle] pathForResource:@"holdem_hands_sorted_alpha" ofType:@"txt"];
  return [self loadHandsFromFileAtPath:filePath];
}

+ (NSArray<Hand *> *)holdemHandsSortedByEV {
  NSString *filePath =
      [[NSBundle mainBundle] pathForResource:@"holdem_hands_sorted_ev" ofType:@"txt"];
  return [self loadHandsFromFileAtPath:filePath];
}

+ (NSArray<Hand *> *)loadHandsFromFileAtPath:(NSString *)filePath {
  NSString *contents =
      [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
  NSArray<NSString *> *lines =
      [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  NSMutableArray<Hand *> *hands = [NSMutableArray array];
  for (NSString *line in lines) {
    [hands addObject:[Hand handFromString:line]];
  }
  return hands;
}

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }

  if (self == object) {
    return YES;
  }

  return [self isEqualToHand:object];
}

- (BOOL)isEqualToHand:(Hand *)hand {
  return [self.cards isEqual:hand.cards];
}

- (NSUInteger)hash {
  return [self.cards hash];
}

@end

NS_ASSUME_NONNULL_END
