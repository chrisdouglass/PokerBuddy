#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "poker-eval/include/deck_std.h"

NS_ASSUME_NONNULL_BEGIN

typedef StdDeck_RankMask Rank;
typedef uint64_t Suit;

@interface HoldemCard : NSObject

@property(nonatomic, readonly) Rank rank;
@property(nonatomic, readonly) Suit suit;
@property(nonatomic, readonly) StdDeck_CardMask mask;

+ (nullable instancetype)cardFromString:(NSString *)string;

+ (instancetype)cardWithRank:(Rank)rank andSuit:(Suit)suit;

- (BOOL)isEqualToCard:(HoldemCard *)card;

@end

@interface HoldemHand : NSObject

@property(nonatomic) HoldemCard *card1;
@property(nonatomic) HoldemCard *card2;

+ (instancetype)handFromString:(NSString *)string;

- (BOOL)isEqualToHand:(HoldemHand *)hand;

@end

@interface HandDistribution : NSObject

+ (instancetype)distributionFromString:(NSString *)string;

@property(nonatomic, readonly) NSSet<HoldemHand *> *allHands;

@end

@interface HoldemEquityCalculator : NSObject

- (void)calculate;

@end

NS_ASSUME_NONNULL_END
