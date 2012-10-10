//
//  AlarmItemCell.m
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "AlarmItemCell.h"
#import "AlarmItem.h"

@implementation AlarmItemCell

@synthesize stationLabel = _stationLabel;
@synthesize sphereLabel = _sphereLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize alarmSwitch = _alarmSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // 親クラスの初期化メソッドを呼び出す
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    // stationラベルの作成
    _stationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _stationLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    _stationLabel.textColor = [UIColor blackColor];
    _stationLabel.highlightedTextColor = [UIColor whiteColor];
    _stationLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_stationLabel];
    
    // sphereラベルの作成
    _sphereLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sphereLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _sphereLabel.textColor = [UIColor darkGrayColor];
    _sphereLabel.highlightedTextColor = [UIColor whiteColor];
    _sphereLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_sphereLabel];
    
    // distanceラベルの作成
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _distanceLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _distanceLabel.textColor = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:1];
    _distanceLabel.highlightedTextColor = [UIColor whiteColor];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_distanceLabel];
    
    // alarmSwitchの作成
    _alarmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
    [_alarmSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = _alarmSwitch;
    
    return self;
}

- (void)updateSwitchAtIndexPath:(UISwitch *)switchview
{
    // スーパークラスをたどり、このセルを保持するテーブルビューを探す
    id tableView = [switchview superview];
	while ([tableView isKindOfClass:[UITableView class]] == NO) {
		tableView = [tableView superview];
	}
    
    // NSIndexPathを得る
    NSIndexPath* indexPath = [((UITableView*)tableView) indexPathForCell:self];
    
    if ([switchview isOn]) {
        [[AlarmItem sharedManager].alarmSwitch replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    } else {
        [[AlarmItem sharedManager].alarmSwitch replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    }
    
    [(UITableView*)tableView reloadData];
}

- (void)layoutSubviews
{
    CGRect  rect;
    
    // 親クラスのメソッドを呼び出す
    [super layoutSubviews];
    
    // contentViewの大きさを取得する
    CGRect  bounds;
    bounds = self.contentView.bounds;
    
    // staionLabelのレイアウト
    rect.origin.x = CGRectGetMinX(bounds) + 4.0f;
    rect.origin.y = CGRectGetMinY(bounds) + 12.0f;
    rect.size.width = CGRectGetWidth(bounds) - CGRectGetMinX(rect);
    rect.size.height = 35.0f;
    _stationLabel.frame = rect;
    
    // sphereのレイアウト
    rect.origin.x = CGRectGetMinX(_stationLabel.frame);
    rect.origin.y = CGRectGetMinY(_stationLabel.frame) + 32.0f;
    rect.size.width = 80.0f;
    rect.size.height = 20.0f;
    _sphereLabel.frame = rect;
    
    // distanceのレイアウト
    rect.origin.x = CGRectGetMinX(_stationLabel.frame) + 80.0f;
    rect.origin.y = CGRectGetMinY(_stationLabel.frame) + 32.0f;
    rect.size.width = 120.0f;
    rect.size.height = 20.0f;
    _distanceLabel.frame = rect;
    
    // alarmSwitchのレイアウト
    rect.origin.x = CGRectGetMinX(_stationLabel.frame);
    rect.origin.y = CGRectGetMaxY(_stationLabel.frame) + 24.0f;
    rect.size.width = 80.0f;
    rect.size.height = 14.0f;
    
}

- (void)drawRect:(CGRect)rect
{
    // CGContextを用意する
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // CGGradientを生成する
    // 生成するためにCGColorSpaceと色データの配列が必要になるので
    // 適当に用意する
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 1.0,  // Start color
        // 0.79, 0.79, 0.79, 1.0 }; // End color
        0.502, 0.502, 0.502, 1.0 }; // End color
    //0.33, 0.33, 0.33, 1.0 }; // End color
    colorSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                   locations, num_locations);
    
    // 生成したCGGradientを描画する
    // 始点と終点を指定してやると、その間に直線的なグラデーションが描画される。
    // （横幅は無限大）
    CGPoint startPoint = CGPointMake(self.frame.size.width/2, 0.0);
    CGPoint endPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // GradientとColorSpaceを開放する
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
