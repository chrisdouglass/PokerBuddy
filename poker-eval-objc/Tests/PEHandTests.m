#import <XCTest/XCTest.h>

#import "Model/PECard.h"
#import "Model/PEHand.h"

@interface PEHandTests : XCTestCase

@end

@implementation PEHandTests

- (void)testHandFromString {
  NSString *singleHandString = @"AdKh";
  PECard *expectedCard1 =
      [PECard cardWithRank:StdDeck_Rank_ACE andSuit:StdDeck_Suit_DIAMONDS];
  PECard *expectedCard2 =
      [PECard cardWithRank:StdDeck_Rank_KING andSuit:StdDeck_Suit_HEARTS];
  PEHand *expectedHand = [[PEHand alloc] init];
  expectedHand.card1 = expectedCard1;
  expectedHand.card2 = expectedCard2;
  PEHand *hand = [PEHand handFromString:singleHandString];
  XCTAssertEqualObjects(hand, expectedHand);
}

- (void)testHandCardMask {
  NSString *singleHandString = @"QsJc";
  PECard *expectedCard1 =
      [PECard cardWithRank:StdDeck_Rank_QUEEN andSuit:StdDeck_Suit_SPADES];
  PECard *expectedCard2 =
      [PECard cardWithRank:StdDeck_Rank_JACK andSuit:StdDeck_Suit_CLUBS];
  PEHand *expectedHand = [[PEHand alloc] init];
  expectedHand.card1 = expectedCard1;
  expectedHand.card2 = expectedCard2;
  PEHand *hand = [PEHand handFromString:singleHandString];
  StdDeck_CardMask expectedMask;
  StdDeck_CardMask_RESET(expectedMask);
  StdDeck_CardMask_OR(expectedMask,
                      StdDeck_MASK(StdDeck_MAKE_CARD(StdDeck_Rank_QUEEN, StdDeck_Suit_SPADES)),
                      StdDeck_MASK(StdDeck_MAKE_CARD(StdDeck_Rank_JACK, StdDeck_Suit_CLUBS))
                      );
  XCTAssertTrue(StdDeck_CardMask_EQUAL(hand.mask, expectedMask));
}

- (void)testHandContainsAtLeastOneCardFromCards {
  NSSet<PECard *> *allAces =
      [NSSet setWithObjects:[PECard cardFromString:@"Ad"], [PECard cardFromString:@"As"],
                            [PECard cardFromString:@"Ac"], [PECard cardFromString:@"Ah"],
                            nil];
  PEHand *containsAceHand = [PEHand handFromString:@"AdQc"];
  XCTAssertTrue([containsAceHand containsAtLeastOneCardFromCards:allAces]);
  PEHand *doesNotContainAceHand = [PEHand handFromString:@"KsTh"];
  XCTAssertFalse([doesNotContainAceHand containsAtLeastOneCardFromCards:allAces]);
}

@end
