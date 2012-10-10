//
//  SettingsViewController.m
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "SettingsViewController.h"
#import "AlarmsViewController.h"
#import "StationViewController.h"
#import "SphereViewController.h"
#import "AlarmItem.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize editItem;
@synthesize target_location;
@synthesize add_edit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"アラームを編集";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Back"
                                       style:UIBarButtonItemStyleBordered
                                       target:nil
                                       action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    editTitle = [[NSArray alloc] initWithObjects:@"目的地", @"範囲", nil];
    
    // 初期値の設定
    if (add_edit == nil) {
        // 追加ボタンが押された場合
        editItem = [[NSMutableArray alloc] initWithObjects:@"東京", @"1000", nil];
        target_location = [[NSMutableArray alloc] initWithObjects:@"139.766103", @"35.681391", nil];
    } else {
        // 編集ボタンが押された場合
        NSString *station = [NSString stringWithFormat:@"%@", [[AlarmItem sharedManager].stations objectAtIndex:[add_edit intValue]]];
        NSString *sphere = [NSString stringWithFormat:@"%@", [[AlarmItem sharedManager].spheresOfVibration objectAtIndex:[add_edit intValue]]];
        NSString *lon = [NSString stringWithFormat:@"%@", [[AlarmItem sharedManager].longtitude objectAtIndex:[add_edit intValue]]];
        NSString *lat = [NSString stringWithFormat:@"%@", [[AlarmItem sharedManager].latitude objectAtIndex:[add_edit intValue]]];
        editItem = [[NSMutableArray alloc] initWithObjects:station, sphere, nil];
        target_location = [[NSMutableArray alloc] initWithObjects:lon, lat, nil];
    }
    
    // 完了ボタンの表示
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneRow:)];
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
    
    // キャンセルボタンの表示
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelRow:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
}

// 完了ボタンを押したときの処理
- (void)doneRow:(id)selector
{
    if (add_edit == nil) {
        [[AlarmItem sharedManager] addStation:[editItem objectAtIndex:0] addSphere:[editItem objectAtIndex:1] addLon:[target_location objectAtIndex:0] addLat:[target_location objectAtIndex:1]];
    } else {
        [[AlarmItem sharedManager] editStation:[editItem objectAtIndex:0] editSphere:[editItem objectAtIndex:1] editLon:[target_location objectAtIndex:0] editLat:[target_location objectAtIndex:1] index:[add_edit intValue]];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// キャンセルボタンを押したときの処理
- (void)cancelRow:(id)selector
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [editAlarm reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [editTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [editTitle objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [editItem objectAtIndex:indexPath.row];
    } else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",[editItem objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

// cellタップ時に呼び出される
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        stationController = [[StationViewController alloc] initWithNibName:@"StationViewController" bundle:nil];
        [self.navigationController pushViewController:stationController animated:YES];
    } else if (indexPath.row == 1) {
        sphereController = [[SphereViewController alloc] initWithNibName:@"SphereViewController" bundle:nil];
        [self.navigationController pushViewController:sphereController animated:YES];
    }
}

@end