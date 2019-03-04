#import <XCTest/XCTest.h>

#import "Model/PECard.h"

@interface PECardTests : XCTestCase

@end

@implementation PECardTests

- (void)testCardFromString {
  Rank expectedRank = StdDeck_Rank_ACE;
  Suit expectedSuit = StdDeck_Suit_DIAMONDS;
  StdDeck_CardMask expectedMask = StdDeck_MASK(StdDeck_MAKE_CARD(expectedRank, expectedSuit));

  NSString *cardString = @"Ad";
  PECard *card = [PECard cardFromString:cardString];
  XCTAssertEqual(card.rank, expectedRank);
  XCTAssertEqual(card.suit, expectedSuit);
  XCTAssertTrue(StdDeck_CardMask_EQUAL(card.mask, expectedMask));

  NSString *cardStringCaps = @"aD";
  PECard *card2 = [PECard cardFromString:cardStringCaps];
  XCTAssertEqual(card2.rank, expectedRank);
  XCTAssertEqual(card2.suit, expectedSuit);
  XCTAssertTrue(StdDeck_CardMask_EQUAL(card2.mask, expectedMask));
}

@end
