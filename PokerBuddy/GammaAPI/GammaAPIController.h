#import <Foundation/Foundation.h>

#import <CoreLocation/CLLocation.h>

@class GammaCasino;
@class GammaGame;
@class GammaGameLimit;
@class GammaTournament;

NS_ASSUME_NONNULL_BEGIN

@interface GammaAPIController : NSObject

- (void)casinoForID:(NSString *)casinoID
    completionHandler:(void(^)(GammaCasino *_Nullable, NSError *_Nullable))completionHandler;

- (void)tournamentsForCasinoWithID:(NSString *)casinoID
    completionHandler:(void(^)(NSArray<GammaTournament *> *_Nullable,
                               NSError *_Nullable))completionHandler;

- (void)clocksForCasinoWithID:(NSString *)casinoID
            completionHandler:(void(^)(id _Nullable, NSError *_Nullable))completionHandler;

- (void)casinosByLocation:(nullable CLLocation *)location
            radiusInMiles:(NSUInteger)radiusInMiles
        completionHandler:(void(^)(NSArray<GammaCasino *> *_Nullable,
                                   NSError *_Nullable))completionHandler;

- (void)listGamesWithCompletionHandler:
    (void(^)(NSArray<GammaGame *> *_Nullable, NSError *_Nullable))completionHandler;

- (void)listGameLimitsWithCompletionHandler:
    (void(^)(NSArray<GammaGameLimit *> *_Nullable, NSError *_Nullable))completionHandler;

- (void)searchCasinosForGame:(nullable GammaGame *)game
                       limit:(nullable GammaGameLimit *)limit
       withCompletionHandler:(void(^)(NSArray<GammaCasino *> *_Nullable,
                                      NSError *_Nullable))completionHandler;

@end

NS_ASSUME_NONNULL_END
