#import <Foundation/Foundation.h>

#import "poker-eval/include/deck_std.h"

NS_ASSUME_NONNULL_BEGIN

typedef StdDeck_RankMask Rank;
typedef uint64_t Suit;

@interface PECard : NSObject

@property(nonatomic, readonly) Rank rank;
@property(nonatomic, readonly) Suit suit;
@property(nonatomic, readonly) StdDeck_CardMask mask;

+ (nullable instancetype)cardFromString:(NSString *)string;

+ (instancetype)cardWithRank:(Rank)rank andSuit:(Suit)suit;

- (BOOL)isEqualToCard:(PECard *)card;

/** Methods for converting to and from poker-eval ranks and suits. */
+ (Rank)charToRank:(const char)c;
+ (char)rankToChar:(Rank)rank;
+ (Suit)charToSuit:(const char)s;
+ (char)suitToChar:(Suit)suit;

@end

NS_ASSUME_NONNULL_END
