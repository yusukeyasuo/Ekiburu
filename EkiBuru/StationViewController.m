//
//  StationViewController.m
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "StationViewController.h"
#import "SettingsViewController.h"

@interface StationViewController ()

@end

@implementation StationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    stations = [[NSMutableArray alloc] init];
    lines = [[NSMutableArray alloc] init];
    lon = [[NSMutableArray alloc] init];
    lat = [[NSMutableArray alloc] init];
    
    searchStation = [[UISearchBar alloc] init];
    searchStation.delegate = self;
    self.navigationItem.titleView = searchStation;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 320, 44);
    searchStation.placeholder = @"駅名を入力してください";
    [searchStation becomeFirstResponder];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict{
    currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"name"]) {
        inElement = YES;
    } else if ([elementName isEqualToString:@"line"]) {
        inElement = YES;
    } else if ([elementName isEqualToString:@"x"]) {
        inElement = YES;
    } else if ([elementName isEqualToString:@"y"]) {
        inElement = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([currentElement isEqualToString:@"name"] && inElement == YES) {
        [stations addObject:string];
    } else if ([currentElement isEqualToString:@"line"] && inElement == YES) {
        if (line == nil) {
            line = string;
        } else {
            line = [NSString stringWithFormat:@"%@%@",line,string];
        }
    } else if ([currentElement isEqualToString:@"x"] && inElement == YES) {
        [lon addObject:string];
    } else if ([currentElement isEqualToString:@"y"] && inElement == YES) {
        [lat addObject:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"name"]) {
        inElement = NO;
    } else if ([elementName isEqualToString:@"line"]) {
        inElement = NO;
        [lines addObject:line];
        line = nil;
    } else if ([elementName isEqualToString:@"x"]) {
        inElement = NO;
    } else if ([elementName isEqualToString:@"y"]) {
        inElement = NO;
    }
    
    [stationList reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [searchStation resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// サーチバーの検索ボタン押下時
-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [searchStation resignFirstResponder];
    [self searchStation:searchStation.text];
}

- (void)searchStation:(NSString*)searchBar
{
    [stations removeAllObjects];
    [lines removeAllObjects];
    stationName = searchBar;
    encodedStationName = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      kCFAllocatorDefault,
                                                                                      (__bridge CFStringRef)stationName,
                                                                                      NULL,
                                                                                      (__bridge CFStringRef)@"!*'();:@&amp;=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
    url = [NSString stringWithFormat:@"http://express.heartrails.com/api/xml?method=getStations&name=%@", encodedStationName];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// 非同期通信 ヘッダーが返ってきた
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // データを初期化
    _xmlData = [[NSMutableData alloc] initWithData:0];
    // インジケーターの表示
}

// 非同期通信 ダウンロード中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // データを追加する
    [_xmlData appendData:data];
}

// 非同期通信 エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// 非同期通信 ダウンロード完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    xmlParser = [[NSXMLParser alloc] initWithData:_xmlData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [stations objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [lines objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.navigationController.viewControllers;
    int arrayCount = [array count];
    SettingsViewController *parent = [array objectAtIndex:arrayCount - 2];
    NSString *station =[NSString stringWithFormat:@"%@", [stations objectAtIndex:indexPath.row]];
    [parent.editItem removeObjectAtIndex:0];
    [parent.editItem insertObject:station atIndex:0];
    [parent.target_location removeAllObjects];
    [parent.target_location addObject:[lon objectAtIndex:indexPath.row]];
    [parent.target_location addObject:[lat objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
