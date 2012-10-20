//
//  StationViewController.h
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationViewController : UIViewController <NSXMLParserDelegate, UISearchBarDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UISearchBar *searchStation;
    NSXMLParser *xmlParser;
    NSString *currentElement;
    NSString *stationName;
    NSString *encodedStationName;
    NSString *url;
    NSMutableArray *stations;
    NSMutableArray *lines;
    NSMutableArray *lon;
    NSMutableArray *lat;
    NSString *line;
    BOOL inElement;
    IBOutlet UITableView *stationList;
    NSURLConnection *_connection;
    NSMutableData *_xmlData;
}

@property (nonatomic, strong) NSMutableArray *test;

@end