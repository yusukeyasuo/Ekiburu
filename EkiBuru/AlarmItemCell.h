//
//  AlarmItemCell.h
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AlarmItemCell : UITableViewCell
{
    UILabel *_stationLabel;
    UILabel *_sphereLabel;
    UILabel *_distanceLabel;
    UISwitch *_alarmSwitch;
}

@property (nonatomic, strong) UILabel *stationLabel;
@property (nonatomic, strong) UILabel *sphereLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UISwitch *alarmSwitch;

- (void)updateSwitchAtIndexPath:(UISwitch *)switchview;

@end
