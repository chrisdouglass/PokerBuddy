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
    PERange *mergedRange = [PERange range];
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

+ (instancetype)range {
  return [[PERange alloc] initWithHands:@[]];
}

// This is "expensive", so cache it.
+ (instancetype)allHandsRange {
  return [self rangeWithFirstRank:StdDeck_Rank_FIRST
                       secondRank:StdDeck_Rank_FIRST
                      ignorePairs:NO
                        onlyPairs:NO
                           suited:NO
                          offsuit:NO];
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
  Rank startRank = [PECard charToRank:[strings.firstObject characterAtIndex:0]];
  Rank endRank = [PECard charToRank:[strings.lastObject characterAtIndex:0]];
  PERange *mergedRange = [PERange range];
  for (Rank r = startRank; r <= endRank; r++) {
    mergedRange = [mergedRange rangeByAddingRange:[self pocketPairRangeForRank:r]];
  }
  return mergedRange;
}

+ (instancetype)pocketPairRangeForRank:(Rank)rank {
  NSMutableSet<PEHand *> *hands = [NSMutableSet set];
  for (Suit firstSuit = StdDeck_Suit_FIRST; firstSuit <= StdDeck_Suit_LAST; firstSuit++) {
    for (Suit secondSuit = firstSuit + 1; secondSuit <= StdDeck_Suit_LAST; secondSuit++) {
      PEHand *hand = [[PEHand alloc] init];
      hand.card1 = [PECard cardWithRank:rank andSuit:firstSuit];
      hand.card2 = [PECard cardWithRank:rank andSuit:secondSuit];
      [hands addObject:hand];
    }
  }
  return [[PERange alloc] initWithHandSet:hands];
}

+ (instancetype)uncappedRangeFromString:(NSString *)string {
  NSUInteger length = string.length;
  BOOL suited = NO;
  BOOL offsuit = NO;
  Rank cardOneRank = kNoRankOrSuit;
  Rank cardTwoRank = kNoRankOrSuit;
  for (NSUInteger charIndex = 0; charIndex < length; charIndex++) {
    unichar character = [string characterAtIndex:charIndex];
    Rank rank = [PECard charToRank:character];
    if (rank != kNoRankOrSuit) {
      if (charIndex == 0) {
        cardOneRank = rank;
      } else if (charIndex == 1/* || charIndex == 2*/) {
        cardTwoRank = rank;
      }
      continue;
    }
    // Not a rank character. Check for +, s, and o.
    switch (character) {
      case 'X': case 'x':
        cardTwoRank = kNoRankOrSuit;
        break;
      case 'S': case 's':
        suited = YES;
        break;
      case 'O': case 'o':
        offsuit = YES;
        break;
    }
  }
  return [self rangeWithFirstRank:cardOneRank
                       secondRank:cardTwoRank
                      ignorePairs:(cardOneRank != cardTwoRank)
                        onlyPairs:(cardOneRank == cardTwoRank)
                           suited:suited
                          offsuit:offsuit];
}

+ (instancetype)rangeWithFirstRank:(Rank)firstRank
                        secondRank:(Rank)secondRank
                       ignorePairs:(BOOL)ignorePairs  // TODO: Replace this and onlyPairs with enum.
                         onlyPairs:(BOOL)onlyPairs
                            suited:(BOOL)isSuited
                           offsuit:(BOOL)isOffsuit {
  NSMutableSet<PEHand *> *mutableHands = [NSMutableSet set];
  for (Rank rank1 = firstRank; rank1 <= StdDeck_Rank_LAST; rank1++) {
    for (Suit suit1 = StdDeck_Suit_FIRST; suit1 <= StdDeck_Suit_LAST; suit1++) {
      for (Rank rank2 = secondRank; rank2 <= StdDeck_Rank_LAST; rank2++) {
        BOOL identicalRanks = (rank1 == rank2);
        if (ignorePairs && identicalRanks) {
          continue;
        }
        if (isSuited) {
          PEHand *hand = [[PEHand alloc] init];
          hand.card1 = [PECard cardWithRank:rank1 andSuit:suit1];
          hand.card2 = [PECard cardWithRank:rank2 andSuit:suit1];
          [mutableHands addObject:hand];
          continue;
        }
        for (Suit suit2 = StdDeck_Rank_FIRST; suit2 <= StdDeck_Suit_LAST; suit2++) {
          BOOL identicalSuits = (suit1 == suit2);
          if ((isOffsuit && identicalSuits) || (identicalRanks && identicalSuits)
              || (!identicalRanks && onlyPairs)) {
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
