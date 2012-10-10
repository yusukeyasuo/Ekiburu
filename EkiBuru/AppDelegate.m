//
//  AppDelegate.m
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "AppDelegate.h"
#import "AlarmsViewController.h"
#import "AlarmItem.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    alarmsController = [[AlarmsViewController alloc] initWithNibName:@"AlarmsViewController" bundle:nil];
    navController = [[UINavigationController alloc] initWithRootViewController:alarmsController];
    // navController.navigationBar.tintColor = [UIColor lightGrayColor];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[AlarmItem sharedManager] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AlarmItem sharedManager] load];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[AlarmItem sharedManager] save];
}

@end