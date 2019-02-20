#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardSuit) {
  CardSuitUndefined = 0,
  CardSuitHearts,
  CardSuitDiamonds,
  CardSuitClubs,
  CardSuitSpades,
};

typedef NS_ENUM(NSUInteger, CardRank) {
  CardRank2 = 2,
  CardRank3,
  CardRank4,
  CardRank5,
  CardRank6,
  CardRank7,
  CardRank8,
  CardRank9,
  CardRankT,
  CardRankJ,
  CardRankQ,
  CardRankK,
  CardRankA,
};

@interface Card : NSObject

@property(nonatomic, copy) NSString *rank;
@property(nonatomic) CardRank cardRank;
@property(nonatomic) CardSuit suit;

+ (Card *)cardFromString:(NSString *)cardString;

- (instancetype)initWithRank:(NSString *)rank suit:(CardSuit)suit;

- (NSComparisonResult)compare:(Card *)card;

@end

NS_ASSUME_NONNULL_END
