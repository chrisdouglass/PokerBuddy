#import "LocationManager/LocationManager.h"

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager () <CLLocationManagerDelegate>
@property(nonatomic, readonly) CLLocationManager *coreLocationManager;
@end

@implementation LocationManager

+ (instancetype)locationManagerWithDelegate:(nullable id<LocationManagerDelegate>)delegate {
  return [[[self class] alloc] initWithCoreLocationManager:[[CLLocationManager alloc] init]
                                                  delegate:delegate];
}

- (instancetype)initWithCoreLocationManager:(CLLocationManager *)coreLocationMonitor
                                   delegate:(nullable id<LocationManagerDelegate>)delegate {
  if (self = [super init]) {
    _coreLocationManager = coreLocationMonitor;
    _coreLocationManager.delegate = self;
    _locationManagerDelegate = delegate;

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, kNilOptions), ^{
      [self enableLocationServices];
    });
  }
  return self;
}

- (void)enableLocationServices {
  if (![CLLocationManager locationServicesEnabled]) {
    return;
  }

  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  switch (status) {
    case kCLAuthorizationStatusNotDetermined:
      [self.coreLocationManager requestWhenInUseAuthorization];
      break;
    case kCLAuthorizationStatusRestricted:
    case kCLAuthorizationStatusDenied:
      break;
    case kCLAuthorizationStatusAuthorizedAlways:
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self updateLocation];
      break;
  }
}

- (void)disableLocationServices {
  [self.coreLocationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  switch (status) {
    case kCLAuthorizationStatusRestricted:
    case kCLAuthorizationStatusDenied:
      break;
    case kCLAuthorizationStatusAuthorizedAlways:
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self updateLocation];
      break;
    case kCLAuthorizationStatusNotDetermined:
      break;
  }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
  [self.locationManagerDelegate locationManagerDidUpdateLocation:self];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSAssert(NO, @"Manager failed with error %@", error);
}

- (nullable CLLocation *)currentLocation {
  return self.coreLocationManager.location;
}

- (double)currentLatitude {
  return self.currentLocation.coordinate.latitude;
}

- (double)currentLongitude {
  return self.currentLocation.coordinate.longitude;
}

- (void)updateLocation {
  [self.coreLocationManager requestLocation];
}

@end

NS_ASSUME_NONNULL_END
