//
//  AlarmItem.m
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "AlarmItem.h"

@implementation AlarmItem

@synthesize stations = _stations;
@synthesize spheresOfVibration = _spheresOfVibration;
@synthesize longtitude = _longitude;
@synthesize latitude = _latitude;
@synthesize alarmSwitch = _alarmSwitch;

static AlarmItem *_sharedInstance = nil;

+ (AlarmItem*)sharedManager
{
    // インスタンスをつくる
    if (!_sharedInstance) {
        _sharedInstance = [[AlarmItem alloc] init];
    }
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    return self;
}

#pragma mark -- アラームの操作 --

// アラームを追加
- (void)addStation:(NSString*)station addSphere:(NSString*)sphere addLon:(NSString*)lon addLat:(NSString*)lat
{
    // 引数を確認する
    if (!station || !sphere || !lon || !lat) {
        return;
    }
    
    // _stations を初期化する
    if (!_stations) {
        _stations = [[NSMutableArray alloc] init];
        _spheresOfVibration = [[NSMutableArray alloc] init];
        _longitude = [[NSMutableArray alloc] init];
        _latitude = [[NSMutableArray alloc] init];
        _alarmSwitch = [[NSMutableArray alloc] init];
    }
    // AlarmItemを追加する
    [_stations addObject:station];
    [_spheresOfVibration addObject:sphere];
    [_longitude addObject:lon];
    [_latitude addObject:lat];
    [_alarmSwitch addObject:[NSNumber numberWithBool:YES]];
}

// アラームを削除
- (void)removeStation:(unsigned int)index
{
    // 引数を確認する
    if (index > [_stations count] - 1) {
        return;
    }
    // AlarmItemを削除する
    [_stations removeObjectAtIndex:index];
    [_spheresOfVibration removeObjectAtIndex:index];
    [_longitude removeObjectAtIndex:index];
    [_latitude removeObjectAtIndex:index];
    [_alarmSwitch removeObjectAtIndex:index];
}

// アラームを上書き
- (void)editStation:(NSString*)station editSphere:(NSString*)sphere editLon:(NSString*)lon editLat:(NSString*)lat index:(unsigned int)index
{
    // 引数を確認する
    if (index > [_stations count] - 1) {
        return;
    }
    if (!station || !sphere || !lon || !lat) {
        return;
    }
    // AlarmItemを編集する
    [_stations replaceObjectAtIndex:index withObject:station];
    [_spheresOfVibration replaceObjectAtIndex:index withObject:sphere];
    [_longitude replaceObjectAtIndex:index withObject:lon];
    [_latitude replaceObjectAtIndex:index withObject:lat];
    [_alarmSwitch replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
}

#pragma mark -- アラームの永続化 --
- (void)save
{
    // _stations
    _stations_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _stations_directory = [_stations_paths objectAtIndex:0];
    _stations_filePath = [_stations_directory stringByAppendingPathComponent:@"stations_data.dat"];
    // _spheresOfVibration
    _spheres_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _spheres_directory = [_spheres_paths objectAtIndex:0];
    _spheres_filePath = [_spheres_directory stringByAppendingPathComponent:@"spheres_data.dat"];
    // _longtigude
    _lons_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _lons_directory = [_lons_paths objectAtIndex:0];
    _lons_filePath = [_lons_directory stringByAppendingPathComponent:@"lons_data.dat"];
    // _longtigude
    _lats_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _lats_directory = [_lats_paths objectAtIndex:0];
    _lats_filePath = [_lats_directory stringByAppendingPathComponent:@"lats_data.dat"];
    // _alarmSwitch
    _switchs_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _switchs_directory = [_switchs_paths objectAtIndex:0];
    _switchs_filePath = [_switchs_directory stringByAppendingPathComponent:@"switchs_data.dat"];
    
    // アラームの配列を保存する
    [NSKeyedArchiver archiveRootObject:_stations toFile:_stations_filePath];
    [NSKeyedArchiver archiveRootObject:_spheresOfVibration toFile:_spheres_filePath];
    [NSKeyedArchiver archiveRootObject:_longitude toFile:_lons_filePath];
    [NSKeyedArchiver archiveRootObject:_latitude toFile:_lats_filePath];
    [NSKeyedArchiver archiveRootObject:_alarmSwitch toFile:_switchs_filePath];
}

- (void)load
{    // _stations
    _stations_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _stations_directory = [_stations_paths objectAtIndex:0];
    _stations_filePath = [_stations_directory stringByAppendingPathComponent:@"stations_data.dat"];
    // _spheresOfVibration
    _spheres_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _spheres_directory = [_spheres_paths objectAtIndex:0];
    _spheres_filePath = [_spheres_directory stringByAppendingPathComponent:@"spheres_data.dat"];
    // _longtigude
    _lons_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _lons_directory = [_lons_paths objectAtIndex:0];
    _lons_filePath = [_lons_directory stringByAppendingPathComponent:@"lons_data.dat"];
    // _longtigude
    _lats_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _lats_directory = [_lats_paths objectAtIndex:0];
    _lats_filePath = [_lats_directory stringByAppendingPathComponent:@"lats_data.dat"];
    // _alarmSwitch
    _switchs_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _switchs_directory = [_switchs_paths objectAtIndex:0];
    _switchs_filePath = [_switchs_directory stringByAppendingPathComponent:@"switchs_data.dat"];
    
    // アラームの配列を読み込む
    _stations = [NSKeyedUnarchiver unarchiveObjectWithFile:_stations_filePath];
    _spheresOfVibration = [NSKeyedUnarchiver unarchiveObjectWithFile:_spheres_filePath];
    _longitude = [NSKeyedUnarchiver unarchiveObjectWithFile:_lons_filePath];
    _latitude = [NSKeyedUnarchiver unarchiveObjectWithFile:_lats_filePath];
    _alarmSwitch = [NSKeyedUnarchiver unarchiveObjectWithFile:_switchs_filePath];
}

@end
