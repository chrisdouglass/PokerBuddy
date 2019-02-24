#import <Foundation/Foundation.h>

@class CLLocation;
@class CLLocationManager;
@class LocationManager;

NS_ASSUME_NONNULL_BEGIN

@protocol LocationManagerDelegate <NSObject>
- (void)locationManagerDidUpdateLocation:(LocationManager *)locationManager;
@end

@interface LocationManager : NSObject

+ (instancetype)locationManagerWithDelegate:(nullable id<LocationManagerDelegate>)delegate;

- (instancetype)initWithCoreLocationManager:(CLLocationManager *)coreLocationManager
                                   delegate:(nullable id<LocationManagerDelegate>)delegate;

@property(nonatomic, weak) id<LocationManagerDelegate> locationManagerDelegate;

@property(nonatomic, nullable, readonly) CLLocation *currentLocation;
@property(nonatomic, readonly) double currentLatitude;
@property(nonatomic, readonly) double currentLongitude;

@end

NS_ASSUME_NONNULL_END
