#import "Model/PERange.h"

#import "Model/PECard.h"
#import "Model/PEHand.h"
#import "poker-eval/include/deck_std.h"

NS_ASSUME_NONNULL_BEGIN

@interface PERange ()
@end

@implementation PERange

+ (NSArray<PERange *> *)rangesFromString:(NSString *)string {
  NSArray<NSString *> *components = [string componentsSeparatedByString:@"|"];
  NSMutableArray<PERange *> *ranges = [NSMutableArray array];
  for (NSString *component in components) {
    NSArray<NSString *> *groups = [component componentsSeparatedByString:@","];
    PERange *mergedRange = [PERange emptyRange];
    for (NSString *group in groups) {
      PERange *range = [self rangeFromString:group];
      if (range) {
        mergedRange = [mergedRange rangeByAddingRange:range];
      } else {
        NSAssert(NO, @"Unable to create range from string %@", component);
      }
    }
    [ranges addObject:mergedRange];
  }
  return ranges;
}

+ (instancetype)rangeFromString:(NSString *)string {
  if ([string isEqualToString:@"**"] || [string isEqualToString:@"XxXx"]) {
    return [PERange allHandsRange];
  } else if ([string containsString:@"-"]) {
    return [PERange cappedRangeFromString:string];
  } else if ([string containsString:@"+"] || [string localizedCaseInsensitiveContainsString:@"X"]) {
    return [PERange uncappedRangeFromString:string];
  }
  return [PERange singleHandRangeFromString:string];
}

+ (instancetype)emptyRange {
  return [[PERange alloc] initWithHands:@[]];
}

// This is "expensive", so cache it.
+ (instancetype)allHandsRange {
  NSMutableSet<PEHand *> *mutableHands = [NSMutableSet set];
  for (Rank rank1 = StdDeck_Rank_FIRST; rank1 <= StdDeck_Rank_LAST; rank1++) {
    for (Suit suit1 = StdDeck_Suit_FIRST; suit1 <= StdDeck_Suit_LAST; suit1++) {
      for (Rank rank2 = StdDeck_Rank_FIRST; rank2 <= StdDeck_Rank_LAST; rank2++) {
        for (Suit suit2 = StdDeck_Rank_FIRST; suit2 <= StdDeck_Suit_LAST; suit2++) {
          if (rank1 == rank2 && suit1 == suit2) {
            continue;
          }
          PEHand *hand = [[PEHand alloc] init];
          hand.card1 = [PECard cardWithRank:rank1 andSuit:suit1];
          hand.card2 = [PECard cardWithRank:rank2 andSuit:suit2];
          [mutableHands addObject:hand];
        }
      }
    }
  }
  return [[PERange alloc] initWithHandSet:mutableHands];
}

+ (instancetype)singleHandRangeFromString:(NSString *)string {
  NSAssert(string.length == 4, @"Invalid single hand string %@", string);
  return [[PERange alloc] initWithHands:@[ [PEHand handFromString:string] ]];
}

+ (instancetype)cappedRangeFromString:(NSString *)string {
  NSArray<NSString *> *strings = [string componentsSeparatedByString:@"-"];
  NSAssert(strings.count == 2, @"Too many components %@", string);
  if (strings[0].length == 2 && strings[1].length == 2) {
    return [self pocketPairRangeFromStrings:strings];
  }
  NSAssert(NO, @"Unhandled string %@", string);
  return [[PERange alloc] init];
}

+ (instancetype)pocketPairRangeFromStrings:(NSArray<NSString *> *)strings {
  Rank startRank = [PECard charToRank:[strings[0] characterAtIndex:0]];
  Rank endRank = [PECard charToRank:[strings[1] characterAtIndex:0]];
  NSMutableSet<PEHand *> *hands = [NSMutableSet set];
  for (Rank r = startRank; r <= endRank; r++) {
    for (Suit firstSuit = StdDeck_Suit_FIRST; firstSuit <= StdDeck_Suit_LAST; firstSuit++) {
      for (Suit secondSuit = firstSuit + 1; secondSuit <= StdDeck_Suit_LAST;
           secondSuit++) {
        PEHand *hand = [[PEHand alloc] init];
        hand.card1 = [PECard cardWithRank:r andSuit:firstSuit];
        hand.card2 = [PECard cardWithRank:r andSuit:secondSuit];
        [hands addObject:hand];
      }
    }
  }
  return [[PERange alloc] initWithHandSet:hands];
}

+ (instancetype)uncappedRangeFromString:(NSString *)string {
  return [[PERange alloc] init];
}

- (instancetype)initWithHands:(NSArray<PEHand *> *)hands {
  return [self initWithHandSet:[NSSet setWithArray:hands]];
}

- (instancetype)initWithHandSet:(NSSet<PEHand *> *)handSet {
  self = [super init];
  if (self) {
    _allHands = handSet;
  }
  return self;
}

- (NSUInteger)count {
  return self.allHands.count;
}

- (PERange *)rangeByAddingRange:(PERange *)range {
  NSSet<PEHand *> *mergedHands = [self.allHands setByAddingObjectsFromSet:range.allHands];
  return [[PERange alloc] initWithHandSet:mergedHands];
}

@end

NS_ASSUME_NONNULL_END
