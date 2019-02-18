#import <Foundation/Foundation.h>

@class Card;

NS_ASSUME_NONNULL_BEGIN

@interface Hand : NSObject

@property(nonatomic, copy, readonly) NSSet<Card *> *cards;

// Expects the format of rank and one letter for suit. Example: AhKh, JcTd
+ (nullable instancetype)handFromString:(NSString *)string;

- (instancetype)initWithCards:(NSSet<Card *> *)cards NS_DESIGNATED_INITIALIZER;

// Returns all ranks followed by 's' for all of the same suit or 'o' for all offsuit. AKs, JTo
- (NSString *)suitedDescription;

+ (NSArray<Hand *> *)holdemHandsSortedByAlpha;
+ (NSArray<Hand *> *)holdemHandsSortedByEV;

- (BOOL)isPocketPair;

- (BOOL)isSuited;

- (BOOL)isEqualToHand:(Hand *)hand;

@end

NS_ASSUME_NONNULL_END
