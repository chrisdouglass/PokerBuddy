#import <Foundation/Foundation.h>

#import "poker-eval/include/deck_std.h"

NS_ASSUME_NONNULL_BEGIN

typedef StdDeck_RankMask Rank;
typedef uint64_t Suit;

static const char kNoRankOrSuitChar = -1;
static const uint32_t kNoRankOrSuit = UINT32_MAX;

@interface PECard : NSObject

@property(nonatomic, readonly) Rank rank;
@property(nonatomic, readonly) Suit suit;
@property(nonatomic, readonly) StdDeck_CardMask mask;

+ (nullable instancetype)cardFromString:(NSString *)string;

+ (instancetype)cardWithRank:(Rank)rank andSuit:(Suit)suit;

- (BOOL)isEqualToCard:(PECard *)card;

/** Methods for converting to and from poker-eval ranks and suits. */
+ (Rank)charToRank:(const char)c;  // Returns kNoRankOrSuit if no rank.
+ (char)rankToChar:(Rank)rank;     // Returns kNoRankOrSuitChar if no rank.
+ (Suit)charToSuit:(const char)s;  // Returns kNoRankOrSuit if no rank.
+ (char)suitToChar:(Suit)suit;     // Returns kNoRankOrSuitChar if no suit.

@end

NS_ASSUME_NONNULL_END
