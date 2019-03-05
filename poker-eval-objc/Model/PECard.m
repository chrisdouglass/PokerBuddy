#import "Model/PECard.h"

NS_ASSUME_NONNULL_BEGIN

@interface PECard ()
@end

@implementation PECard

+ (nullable instancetype)cardFromString:(NSString *)string {
  NSAssert(string.length == 2, @"Card string must be exactly two characters: %@", string);
  Rank rank = [[self class] charToRank:[string characterAtIndex:0]];
  Suit suit = [[self class] charToSuit:[string characterAtIndex:1]];
  return [PECard cardWithRank:rank andSuit:suit];
}

// Does not validate.
+ (instancetype)cardWithRank:(Rank)rank andSuit:(Suit)suit {
  PECard *card = [[PECard alloc] init];
  card->_rank = rank;
  card->_suit = suit;
  card->_mask = StdDeck_MASK(StdDeck_MAKE_CARD(rank, suit));
  return card;
}

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[PECard class]]) {
    return NO;
  }
  return [self isEqualToCard:object];
}

- (BOOL)isEqualToCard:(PECard *)card {
  return StdDeck_CardMask_EQUAL(self.mask, card.mask);
}

- (NSUInteger)hash {
  return self.rank * 7 + self.suit * 9;
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

	return kNoRankOrSuit;
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
  return kNoRankOrSuitChar;
}

+ (Suit)charToSuit:(const char)s {
	switch (s) {
    case 'S': case 's':	return StdDeck_Suit_SPADES;
    case 'C': case 'c':	return StdDeck_Suit_CLUBS;
    case 'D': case 'd':	return StdDeck_Suit_DIAMONDS;
    case 'H': case 'h':	return StdDeck_Suit_HEARTS;
	};

	return kNoRankOrSuit;
}

+ (char)suitToChar:(Suit)suit {
  switch (suit) {
    case StdDeck_Suit_SPADES: return 's';
    case StdDeck_Suit_CLUBS: return 'c';
    case StdDeck_Suit_DIAMONDS: return 'd';
    case StdDeck_Suit_HEARTS: return 'h';
	};
  return kNoRankOrSuitChar;
}

@end

NS_ASSUME_NONNULL_END
