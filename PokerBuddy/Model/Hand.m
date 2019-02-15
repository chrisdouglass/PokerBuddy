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
//  Card *card1 = [Card cardFromString:[string substringToIndex:2]];
//  Card *card2 = [Card cardFromString:[string substringFromIndex:2]];
  return [[[self class] alloc] initWithCards:@[ card1, card2 ]];
}

- (instancetype)init {
  return [self initWithCards:@[]];
}

- (instancetype)initWithCards:(NSArray<Card *> *)cards {
  self = [super init];
  if (self) {
    _cards = [cards copy];
  }
  return self;
}

- (BOOL)isPocketPair {
  return [self.cards[0].rank isEqualToString:self.cards[1].rank];
}

- (BOOL)isSuited {
  CardSuit suit = [self.cards firstObject].suit;
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
  NSString *rankString = [[self.cards valueForKey:@"rank"] componentsJoinedByString:@""];
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

@end

NS_ASSUME_NONNULL_END
