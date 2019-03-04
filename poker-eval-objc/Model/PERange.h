#import <Foundation/Foundation.h>

@class PEHand;

NS_ASSUME_NONNULL_BEGIN

@interface PERange : NSObject

/** Creates a range from a string. Supported formats:
 *  Every hand: ** or XxXx
 *  Range of pocket pairs: 22-55
 *  Capped range of hands: 78s-AKs
 *  Uncapped range of hands: A2s+ or KTo+ or AQ+ or AXs or AXo or AX or 22+
 *  Single hand range: AcJc
 *  Multiple ranges (seperated by commas): 22+, A2s+, KTs+
 */
+ (instancetype)rangeFromString:(NSString *)string;

+ (instancetype)emptyRange;

/** Splits a string by '|' and creates a range for each component. */
+ (NSArray<PERange *> *)rangesFromString:(NSString *)string;

@property(nonatomic, readonly) NSSet<PEHand *> *allHands;
@property(nonatomic, readonly) NSUInteger count;

- (PERange *)rangeByAddingRange:(PERange *)range;

@end

NS_ASSUME_NONNULL_END
