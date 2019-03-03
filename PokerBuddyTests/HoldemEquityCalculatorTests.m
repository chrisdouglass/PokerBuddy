#import <XCTest/XCTest.h>

#import "Calculator/HoldemEquityCalculator.h"

@interface HoldemEquityCalculatorTests : XCTestCase

@end

@implementation HoldemEquityCalculatorTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testCardFromString {
  Rank expectedRank = StdDeck_Rank_ACE;
  Suit expectedSuit = StdDeck_Suit_DIAMONDS;
  StdDeck_CardMask expectedMask = StdDeck_MASK(StdDeck_MAKE_CARD(expectedRank, expectedSuit));

  NSString *cardString = @"Ad";
  HoldemCard *card = [HoldemCard cardFromString:cardString];
  XCTAssertEqual(card.rank, expectedRank);
  XCTAssertEqual(card.suit, expectedSuit);
  XCTAssertTrue(StdDeck_CardMask_EQUAL(card.mask, expectedMask));

  NSString *cardStringCaps = @"aD";
  HoldemCard *card2 = [HoldemCard cardFromString:cardStringCaps];
  XCTAssertEqual(card2.rank, expectedRank);
  XCTAssertEqual(card2.suit, expectedSuit);
  XCTAssertTrue(StdDeck_CardMask_EQUAL(card2.mask, expectedMask));
}

- (void)testHandFromString {
  NSString *singleHandString = @"AdKh";
  HoldemCard *expectedCard1 =
      [HoldemCard cardWithRank:StdDeck_Rank_ACE andSuit:StdDeck_Suit_DIAMONDS];
  HoldemCard *expectedCard2 =
      [HoldemCard cardWithRank:StdDeck_Rank_KING andSuit:StdDeck_Suit_HEARTS];
  HoldemHand *expectedHand = [[HoldemHand alloc] init];
  expectedHand.card1 = expectedCard1;
  expectedHand.card2 = expectedCard2;
  HoldemHand *hand = [HoldemHand handFromString:singleHandString];
  XCTAssertEqualObjects(hand, expectedHand);
}

- (void)testCreateSingleHandDistribution {
  HoldemCard *expectedCard1 = [HoldemCard cardWithRank:StdDeck_Rank_7 andSuit:StdDeck_Suit_SPADES];
  HoldemCard *expectedCard2 = [HoldemCard cardWithRank:StdDeck_Rank_8 andSuit:StdDeck_Suit_CLUBS];
  HoldemHand *expectedHand = [[HoldemHand alloc] init];
  expectedHand.card1 = expectedCard1;
  expectedHand.card2 = expectedCard2;
  HandDistribution *dist = [HandDistribution distributionFromString:@"7s8c"];
  XCTAssertEqual(dist.allHands.count, 1);
  XCTAssertEqualObjects([dist.allHands anyObject], expectedHand);
}

- (void)testCreatePocketPairRangeHandDistribution {
  NSMutableSet<HoldemHand *> *expectedHands = [NSMutableSet set];
  for (Rank r = StdDeck_Rank_2; r <= StdDeck_Rank_5; r++) {
    for (Suit firstSuit = StdDeck_Suit_FIRST; firstSuit <= StdDeck_Suit_LAST; firstSuit++) {
      for (Suit secondSuit = firstSuit + 1; secondSuit <= StdDeck_Suit_LAST;
           secondSuit++) {
        HoldemHand *hand = [[HoldemHand alloc] init];
        hand.card1 = [HoldemCard cardWithRank:r andSuit:firstSuit];
        hand.card2 = [HoldemCard cardWithRank:r andSuit:secondSuit];
        [expectedHands addObject:hand];
      }
    }
  }
  XCTAssertEqual(expectedHands.count, 24, @"Did not correctly generate expected hands.");
  HandDistribution *dist = [HandDistribution distributionFromString:@"22-55"];
  XCTAssertEqualObjects(dist.allHands, expectedHands);
}

- (void)testAllHandsDistribution {
  HandDistribution *dist = [HandDistribution distributionFromString:@"**"];
  NSError *loadHandsError = nil;
  NSString *allHandsTxtPath =
      [[NSBundle bundleForClass:[self class]] pathForResource:@"all_hands" ofType:@"txt"];
  NSString *handStringsList = [NSString stringWithContentsOfFile:allHandsTxtPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:&loadHandsError];
  NSArray<NSString *> *handStrings =
      [handStringsList componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  XCTAssertNil(loadHandsError);
  NSMutableSet<HoldemHand *> *expectedHands = [NSMutableSet set];
  [handStrings enumerateObjectsUsingBlock:^(NSString *handString, NSUInteger idx, BOOL *stop) {
    [expectedHands addObject:[HoldemHand handFromString:handString]];
  }];
  XCTAssertEqual(expectedHands.count, 1326);
  XCTAssertEqualObjects(dist.allHands, expectedHands);
}

- (void)testHoldemHandContainsAtLeastOneCardFromCards {
  NSSet<HoldemCard *> *allAces =
      [NSSet setWithObjects:[HoldemCard cardFromString:@"Ad"], [HoldemCard cardFromString:@"As"],
                            [HoldemCard cardFromString:@"Ac"], [HoldemCard cardFromString:@"Ah"],
                            nil];
  HoldemHand *containsAceHand = [HoldemHand handFromString:@"AdQc"];
  XCTAssertTrue([containsAceHand containsAtLeastOneCardFromCards:allAces]);
  HoldemHand *doesNotContainAceHand = [HoldemHand handFromString:@"KsTh"];
  XCTAssertFalse([doesNotContainAceHand containsAtLeastOneCardFromCards:allAces]);
}

@end
