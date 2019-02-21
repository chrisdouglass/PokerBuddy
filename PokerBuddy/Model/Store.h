#import <Foundation/Foundation.h>

@class Casino;
@class GammaCasino;
@class NSManagedObjectContext;

NS_ASSUME_NONNULL_BEGIN

@interface Store : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
    NS_DESIGNATED_INITIALIZER;

- (BOOL)save:(NSError **)error;

// Discards all current changes.
- (void)reset;

- (Casino *)insertCasinoFromGammaCasino:(GammaCasino *)gammaCasino;

@end

NS_ASSUME_NONNULL_END
