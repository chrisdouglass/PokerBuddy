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
