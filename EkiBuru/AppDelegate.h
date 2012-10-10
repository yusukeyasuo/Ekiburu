//
//  AppDelegate.h
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIViewController *alarmsController;
    UINavigationController *navController;
}

@property (strong, nonatomic) UIWindow *window;

@end
