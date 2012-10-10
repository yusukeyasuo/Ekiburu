//
//  SettingsViewController.h
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <iAd/iAd.h>
#import <iAd/ADBannerView_Deprecated.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,CLLocationManagerDelegate, ADBannerViewDelegate>
{
    UIViewController *stationController;
    UIViewController *sphereController;
    IBOutlet UITableView *editAlarm;
    NSArray *editTitle;
    NSMutableArray *editItem;
    CLLocationManager* locationManager;
    CLLocationDegrees _longitude;
	CLLocationDegrees _latitude;
    CLLocationDegrees target_longitude;
	CLLocationDegrees target_latitude;
    NSString *present_longitude;
    NSString *present_latitude;
}

@property (nonatomic, strong) NSMutableArray *editItem;
@property (nonatomic, strong) NSMutableArray *target_location;
@property (nonatomic, strong) NSNumber *add_edit;

@end
