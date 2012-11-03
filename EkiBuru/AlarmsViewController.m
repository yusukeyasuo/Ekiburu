//
//  AlarmsViewController.m
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "AlarmsViewController.h"
#import "SettingsViewController.h"
#import "AlarmItem.h"
#import "AlarmItemCell.h"

@interface AlarmsViewController ()

@end

@implementation AlarmsViewController

@synthesize stations;
@synthesize spheresOfVibration;
@synthesize distancesToStation;
@synthesize alarmSwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"アラーム一覧";
    // 編集ボタンの表示
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // 追加ボタンの表示
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addRow:)];
    [self.navigationItem setRightBarButtonItem:addButton animated:YES];
    
    // 背景画像の表示
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    // 位置情報の取得
    _longitude = 0.0;
    _latitude = 0.0;
    present = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    BOOL locationServicesEnabled;
	locationManager = [[CLLocationManager alloc] init];
    locationServicesEnabled = [CLLocationManager locationServicesEnabled];
    
    if (locationServicesEnabled) {
		locationManager.delegate = self;
		[locationManager startUpdatingLocation];
	}

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    if (self.tableView.editing) {
        [self setEditing:NO animated:YES];
    }
}

// 追加ボタン押下時の処理
- (void)addRow:(id)sender
{
    UIViewController *settingController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingController];
    [self presentViewController:navController animated:YES completion:nil];
}

// 位置情報が取得成功した場合にコールされる
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"load");
	// 位置情報更新
	_longitude = newLocation.coordinate.longitude;
	_latitude = newLocation.coordinate.latitude;
    
    present = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground) {
        if (!self.tableView.editing) {
            [self.tableView reloadData];
        }
    } else {
        int i;
        for (i=0; i<[[AlarmItem sharedManager].stations count]; i++) {
            if ([[[AlarmItem sharedManager].alarmSwitch objectAtIndex:i] boolValue]) {
                NSString *str_sphere = [[AlarmItem sharedManager].spheresOfVibration objectAtIndex:i];
                double double_sphere = [str_sphere doubleValue];
                double distance = [self distance:present index:i];
                if ([self compareDistance:distance withSphere:double_sphere]) {
                    [[AlarmItem sharedManager].alarmSwitch replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
                    [[AlarmItem sharedManager] save];
                    [self fireLocalNotificationNow:@"目的地エリアに到着しました"];
                    [self.tableView reloadData];
                }
            }
        }
    }
}

// 位置情報が取得失敗した場合にコールされる
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (error) {
		NSString* message = nil;
		switch ([error code]) {
                // アプリでの位置情報サービスが許可されていない場合
			case kCLErrorDenied:
				// 位置情報取得停止
				[locationManager stopUpdatingLocation];
				message = [NSString stringWithFormat:@"このアプリは位置情報サービスが許可されていません。"];
				break;
			default:
				// message = [NSString stringWithFormat:@"位置情報の取得に失敗しました。"];
				break;
		}
		if (message) {
			// アラートを表示
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
}

// 距離を求める
- (double)distance:(CLLocation*)pre_location index:(int)index
{
    lon = [[[AlarmItem sharedManager].longtitude objectAtIndex:index] doubleValue];
    lat = [[[AlarmItem sharedManager].latitude objectAtIndex:index] doubleValue];
    target = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    CLLocationDistance _dis = [pre_location distanceFromLocation:target];
    
    return _dis;
}

// 距離とアラート範囲を比較
- (BOOL)compareDistance:(double)distance withSphere:(double)sphere
{
    if (distance < sphere) {
        return YES;
    } else {
        return NO;
    }
}

// バイブレート関数の呼び出し
- (void)callVibrate
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                              target:self
                                            selector:@selector(vibrate)
                                            userInfo:nil
                                             repeats:YES
              ];
}

// バイブレート関数
- (void)vibrate
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

// バイブレート関数（バックグラウンド用）
- (void)vibrate_bg
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    } else {
        [_timer invalidate];
    }
}

// バックグラウンドからのアラート
- (void)fireLocalNotificationNow:(NSString *)alertBody
{
    UILocalNotification *lc = [[UILocalNotification alloc] init];
    lc.alertBody = alertBody;
    lc.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:lc];
    //アラート後数回バイブレーション発生処理
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                              target:self
                                            selector:@selector(vibrate_bg)
                                            userInfo:nil
                                             repeats:YES
              ];
}

// アラートビューのボタン押下時に呼び出される
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndexf
{
    [_timer invalidate];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// 広告取得に失敗すると呼び出される
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_bannerIsVisible)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             banner.frame = CGRectOffset(banner.frame, 0, 0);
                         }];
        _bannerIsVisible = YES;
    }
}

// 広告表示時に呼び出される
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             banner.frame = CGRectOffset(banner.frame, 0, 0);
         }];
        _bannerIsVisible = YES;
    }
}

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AlarmItem sharedManager].stations count];
}

// セルの設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmItemCell *cell = (AlarmItemCell*)[tableView dequeueReusableCellWithIdentifier:@"AlarmItemCell"];
    
    if (!cell)
    {
        cell = [[AlarmItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlarmItemCell"];
    }
    
    if (self.tableView.editing) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 各ラベルの編集
    cell.stationLabel.text = [[AlarmItem sharedManager].stations objectAtIndex:indexPath.row];
    NSString *str_sphere = [[AlarmItem sharedManager].spheresOfVibration objectAtIndex:indexPath.row];
    double double_sphere = [str_sphere doubleValue];
    cell.sphereLabel.text = [NSString stringWithFormat:@"%@m", str_sphere];
    cell.alarmSwitch.on = [[[AlarmItem sharedManager].alarmSwitch objectAtIndex:indexPath.row] boolValue];
    if (cell.alarmSwitch.on) {
        double distance = [self distance:present index:indexPath.row];
        if (distance < 1000) {
            cell.distanceLabel.text = [NSString stringWithFormat:@"距離: %dm", (int)distance];
        } else {
            cell.distanceLabel.text = [NSString stringWithFormat:@"距離: %.2fkm", distance/1000];
        }
        BOOL call_alarm = [self compareDistance:distance withSphere:double_sphere];
        if (call_alarm) {
            [[AlarmItem sharedManager].alarmSwitch replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
            cell.alarmSwitch.on = NO;
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"お知らせ" message:@"目的地エリアに到着しました"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.tableView reloadData];
            [self callVibrate];
        }
    } else {
        cell.distanceLabel.text = @"停止";
    }
    
    [self updatingLocation];
    
    return cell;
}

// 位置情報取得するかどうか判定
- (void)updatingLocation
{
    int i;
    _numberOfOn = 0;
    for (i = 0; i < [[AlarmItem sharedManager].stations count]; i++) {
        if ([[[AlarmItem sharedManager].alarmSwitch objectAtIndex:i] boolValue]) {
            _numberOfOn++;
        }
    }
    if (_numberOfOn) {
        [locationManager startUpdatingLocation];
    } else {
        [locationManager stopUpdatingLocation];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[locationManager stopUpdatingLocation];
        [[AlarmItem sharedManager] removeStation:indexPath.row];
		[locationManager startUpdatingLocation];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableView.editing) {
        SettingsViewController *settingController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        settingController.before_edit = [[AlarmItem sharedManager].stations objectAtIndex:indexPath.row];
        settingController.add_edit = [NSNumber numberWithInt:indexPath.row];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

@end
