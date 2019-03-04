#import <Foundation/Foundation.h>

@class PECard;

NS_ASSUME_NONNULL_BEGIN

@interface PEHand : NSObject

@property(nonatomic) PECard *card1;
@property(nonatomic) PECard *card2;

/** Expected format: RankSuitRankSuitRankSuit... Ex: AdKdQdJdTd. */
+ (instancetype)handFromString:(NSString *)string;

/** Used to determine if a hand is blocked. */
- (BOOL)containsAtLeastOneCardFromCards:(NSSet<PECard *> *)cards;

- (BOOL)isEqualToHand:(PEHand *)hand;

@end

NS_ASSUME_NONNULL_END
