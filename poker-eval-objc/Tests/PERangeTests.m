#import <XCTest/XCTest.h>

#import "Model/PECard.h"
#import "Model/PEHand.h"
#import "Model/PERange.h"

@interface PERangeTests : XCTestCase

@end

@implementation PERangeTests

- (void)testCreateSingleHandRange {
  PECard *expectedCard1 = [PECard cardWithRank:StdDeck_Rank_7 andSuit:StdDeck_Suit_SPADES];
  PECard *expectedCard2 = [PECard cardWithRank:StdDeck_Rank_8 andSuit:StdDeck_Suit_CLUBS];
  PEHand *expectedHand = [[PEHand alloc] init];
  expectedHand.card1 = expectedCard1;
  expectedHand.card2 = expectedCard2;
  PERange *dist = [PERange rangeFromString:@"7s8c"];
  XCTAssertEqual(dist.allHands.count, 1);
  XCTAssertEqualObjects([dist.allHands anyObject], expectedHand);
}

- (void)testCreatePocketPairStartToEndRange {
  NSMutableSet<PEHand *> *expectedHands = [NSMutableSet set];
  for (Rank r = StdDeck_Rank_2; r <= StdDeck_Rank_5; r++) {
    for (Suit firstSuit = StdDeck_Suit_FIRST; firstSuit <= StdDeck_Suit_LAST; firstSuit++) {
      for (Suit secondSuit = firstSuit + 1; secondSuit <= StdDeck_Suit_LAST;
           secondSuit++) {
        PEHand *hand = [[PEHand alloc] init];
        hand.card1 = [PECard cardWithRank:r andSuit:firstSuit];
        hand.card2 = [PECard cardWithRank:r andSuit:secondSuit];
        [expectedHands addObject:hand];
      }
    }
  }
  XCTAssertEqual(expectedHands.count, 24, @"Did not correctly generate expected hands.");
  PERange *dist = [PERange rangeFromString:@"22-55"];
  XCTAssertEqualObjects(dist.allHands, expectedHands);
}

- (void)testAllHandsRange {
  NSError *loadHandsError = nil;
  NSString *allHandsTxtPath =
      [[NSBundle bundleForClass:[self class]] pathForResource:@"all_hands" ofType:@"txt"];
  NSString *handStringsList = [NSString stringWithContentsOfFile:allHandsTxtPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:&loadHandsError];
  NSArray<NSString *> *handStrings =
      [handStringsList componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  XCTAssertNil(loadHandsError);
  NSMutableSet<PEHand *> *expectedHands = [NSMutableSet set];
  [handStrings enumerateObjectsUsingBlock:^(NSString *handString, NSUInteger idx, BOOL *stop) {
    [expectedHands addObject:[PEHand handFromString:handString]];
  }];
  XCTAssertEqual(expectedHands.count, 1326);

  PERange *starRange = [PERange rangeFromString:@"**"];
  XCTAssertEqualObjects(starRange.allHands, expectedHands);

  PERange *xRange = [PERange rangeFromString:@"XxXx"];
  XCTAssertEqualObjects(xRange.allHands, expectedHands);
}

- (void)testRangeByAddingRange {
  PERange *pocketPairsRange = [PERange rangeFromString:@"22-55"];
  PERange *singleRange = [PERange rangeFromString:@"AcJd"];
  NSMutableSet<PEHand *> *expectedHands = [pocketPairsRange.allHands mutableCopy];
  [expectedHands addObject:singleRange.allHands.anyObject];
  XCTAssertEqualObjects([pocketPairsRange rangeByAddingRange:singleRange].allHands, expectedHands);
}

- (void)testEmptyRange {
  XCTAssertEqual([PERange emptyRange].allHands.count, 0);
}

- (void)testUpcappedRangeWithPlus {
  PERange *anySuitedAceRange = [PERange rangeFromString:@"A2s+"];
  XCTAssertEqual(anySuitedAceRange.count, 48);

  PERange *anyOffsuitAceRange = [PERange rangeFromString:@"A2o+"];
  XCTAssertEqual(anyOffsuitAceRange.count, 144);

  PERange *anyAceRange = [PERange rangeFromString:@"A2+"];
  XCTAssertEqual(anyAceRange.count, 192);
}

- (void)testUpcappedRangeWithX {
  PERange *anySuitedAceRange = [PERange rangeFromString:@"AXs"];
  XCTAssertEqual(anySuitedAceRange.count, 48);

  PERange *anyOffsuitAceRange = [PERange rangeFromString:@"AXo"];
  XCTAssertEqual(anyOffsuitAceRange.count, 144);

  PERange *anyAceRange = [PERange rangeFromString:@"AX"];
  XCTAssertEqual(anyAceRange.count, 192);
}

- (void)testMultipleRangesFromSingleString {
  NSString *multiRangeString = @"TsTc|AXs|QQ+,AQ+";
  NSArray<PERange *> *ranges = [PERange rangesFromString:multiRangeString];
  XCTAssertEqual(ranges.count, 3, @"Expected three ranges.");

  PERange *singleCardRange = ranges[0];
  XCTAssertEqual(singleCardRange.count, 1);
  PERange *allSuitedAcesRange = ranges[1];
  XCTAssertEqual(allSuitedAcesRange.count, 48);
  PERange *queensOrBetterAndAnyAceQueenOrBetterRange = ranges[2];
  XCTAssertEqual(queensOrBetterAndAnyAceQueenOrBetterRange.count, 48);
}

@end
