#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "Model/Objects/Casino.h"

@class Casino;
@class GammaCasino;

NS_ASSUME_NONNULL_BEGIN

@interface Store : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
    NS_DESIGNATED_INITIALIZER;

- (BOOL)save:(NSError **)error;

// Discards all current changes.
- (void)reset;

// Update or inserts casinos from a list of gamma casinos.
- (void)updateCasinosFromGammaCasinos:(NSArray<GammaCasino *> *)gammaCasinos;

// Inserts a single casino from a gamma casino.
- (Casino *)insertCasinoFromGammaCasino:(GammaCasino *)gammaCasino;

// Returns a fetch request which returns all Casinos sorted by the last known distance.
- (NSFetchRequest<Casino *> *)casinoFetchRequest;

// Uses Store's context to return a results controller.
- (NSFetchedResultsController *)resultsControllerWithRequest:(NSFetchRequest *)request;

@end

NS_ASSUME_NONNULL_END
