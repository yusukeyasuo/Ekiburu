//
//  AlarmItem.h
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmItem : NSObject
{
    NSMutableArray *_stations;
    NSMutableArray *_spheresOfVibration;
    NSMutableArray *_longitude;
    NSMutableArray *_latitude;
    NSMutableArray *_alarmSwitch;
    
    NSArray *_stations_paths;
    NSString *_stations_directory;
    NSString *_stations_filePath;
    NSArray *_spheres_paths;
    NSString *_spheres_directory;
    NSString *_spheres_filePath;
    NSArray *_lons_paths;
    NSString *_lons_directory;
    NSString *_lons_filePath;
    NSArray *_lats_paths;
    NSString *_lats_directory;
    NSString *_lats_filePath;
    NSArray *_switchs_paths;
    NSString *_switchs_directory;
    NSString *_switchs_filePath;
}

@property (nonatomic, readonly) NSArray *stations;
@property (nonatomic, readonly) NSArray *spheresOfVibration;
@property (nonatomic, readonly) NSArray *longtitude;
@property (nonatomic, readonly) NSArray *latitude;
@property (nonatomic, strong) NSMutableArray *alarmSwitch;

+ (AlarmItem*)sharedManager;

// アラームの操作
- (void)addStation:(NSString*)station addSphere:(NSString*)sphere addLon:(NSString*)log addLat:(NSString*)lat;
- (void)removeStation:(unsigned int)index;
- (void)editStation:(NSString*)station editSphere:(NSString*)sphere editLon:(NSString*)lon editLat:(NSString*)lat index:(unsigned int)index;

// アラームの永続化
- (void)save;
- (void)load;

@end