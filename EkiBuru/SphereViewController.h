//
//  SphereViewController.h
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SphereViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *distance_tf;
}

@property (nonatomic, strong) NSString *distanceLabel;

@end