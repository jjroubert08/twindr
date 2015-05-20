//
//  Created by merowing on 16/05/2014.
//
//
//


#import "BeaconMonitor.h"
#import "NSArray+BlocksKit.h"

@import CoreBluetooth;
@import CoreLocation;

@interface BeaconMonitor () <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLBeaconRegion *beaconRegion;
@property(nonatomic, strong) NSUUID *uuid;
@property(nonatomic, copy) NSString *identifier;
@end

@implementation BeaconMonitor

- (instancetype)initWithIdentifier:(NSString *const)identifier uuid:(NSUUID *)uuid
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _uuid = uuid;
  _identifier = identifier;
  [self startMonitoring];

  return self;
}

- (void)startMonitoring
{
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:self.identifier];
  [self.locationManager startMonitoringForRegion:self.beaconRegion];
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];

  NSLog(@"start monitoring %@ %@", self.uuid, self.identifier);
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self alive];
  });
}

- (void) alive;
{
  NSLog(@"I am alive in %@ = %@ = %@", self, self.locationManager, self.locationManager.delegate );
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self alive];
  });
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    // If you get locationManager:rangingBeaconsDidFailForRegion:withError: kCLErrorDomain 16 on iOS 7.1
    // you might need to reboot your device in order to get rid of this problem.
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  NSLog(@"locationManager:didEnter");
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  NSLog(@"locationManager:didExit");
  [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    [beacons bk_each:^(CLBeacon *beacon) {
        // You can retrieve the beacon data from its properties
        NSString *uuid = beacon.proximityUUID.UUIDString;
        NSString *major = [NSString stringWithFormat:@"%@", beacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@", beacon.minor];
        NSLog(@"Beacons found, %@ %@ %@", uuid, major, minor);

        if (self.foundBeaconBlock) {
            self.foundBeaconBlock(major.integerValue, minor.integerValue);
        }
    }];
}

@end
