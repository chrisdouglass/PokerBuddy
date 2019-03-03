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
    _coreLocationManager.distanceFilter = 100;  // 100 meters
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
      [self.coreLocationManager startUpdatingLocation];
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
      [self.coreLocationManager startUpdatingLocation];
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
  CLError errorCode = error.code;
  switch (errorCode) {
    case kCLErrorLocationUnknown:
      break;
    case kCLErrorDenied:
      break;
    case kCLErrorNetwork:
    default:
      NSAssert(NO, @"Manager failed with unhandled error %@, code %ld", error, error.code);
      break;
  }
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

@end

NS_ASSUME_NONNULL_END
