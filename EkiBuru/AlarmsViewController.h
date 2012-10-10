//
//  AlarmsViewController.h
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <iAd/ADBannerView_Deprecated.h>
#import <CoreLocation/CoreLocation.h>

@interface AlarmsViewController : UITableViewController <CLLocationManagerDelegate, ADBannerViewDelegate>
{
    UILabel *_distanceLabel;
    
    CLLocationManager* locationManager;
    CLLocationDegrees _longitude;
	CLLocationDegrees _latitude;
    CLLocation *present;
    CLLocation *target;
    double lon;
    double lat;
    
    NSTimer* _timer;
    
    IBOutlet ADBannerView* _adView;
    BOOL _bannerIsVisible;

}

@property (nonatomic, strong) NSMutableArray *stations;
@property (nonatomic, strong) NSMutableArray *spheresOfVibration;
@property (nonatomic, strong) NSMutableArray *distancesToStation;
@property (nonatomic, strong) NSMutableArray *alarmSwitch;

@end
