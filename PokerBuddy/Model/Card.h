#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardSuit) {
  CardSuitUndefined = 0,
  CardSuitHearts,
  CardSuitDiamonds,
  CardSuitClubs,
  CardSuitSpades,
};

@interface Card : NSObject

@property(nonatomic, copy) NSString *rank;
@property(nonatomic) CardSuit suit;

+ (Card *)cardFromString:(NSString *)cardString;

- (instancetype)initWithRank:(NSString *)rank suit:(CardSuit)suit;

@end

NS_ASSUME_NONNULL_END
