//
//  AppDelegate.m
//  twindr
//
//  Created by Krzysztof Zabłocki on 16/05/2014.
//  Copyright (c) 2014 webdevotion. All rights reserved.
//

#import <HockeySDK/HockeySDK.h>

#import "AppDelegate.h"
#import "BeaconManager.h"
#import "TwitterAccountViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"ab6a142066e911994d7fa42bf491deeb"];
  [[BITHockeyManager sharedHockeyManager] startManager];
  [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[TwitterAccountViewController alloc] init];
  [self.window addSubview:self.window.rootViewController.view];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  [self setupBeacons];
  return YES;
}

- (void)setupBeacons
{
  [[BeaconManager sharedInstance] startMonitoring];
  [[BeaconManager sharedInstance] startTransmittingWithMajorVersion:1 minorVersion:arc4random_uniform(200)];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
