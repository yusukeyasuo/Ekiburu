//
//  SphereViewController.m
//  EkiBuru
//
//  Created by yusuke_yasuo on 2012/09/30.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "SphereViewController.h"
#import "SettingsViewController.h"

@interface SphereViewController ()

@end

@implementation SphereViewController

@synthesize distanceLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"範囲";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [distance_tf becomeFirstResponder];
    NSArray *array = self.navigationController.viewControllers;
    int arrayCount = [array count];
    SettingsViewController *parent = [array objectAtIndex:arrayCount - 2];
    distance_tf.text = [NSString stringWithFormat:@"%@", [parent.editItem objectAtIndex:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string
{
    NSString *result = [distance_tf.text stringByReplacingCharactersInRange:range withString:string];
    
    NSArray *array = self.navigationController.viewControllers;
    int arrayCount = [array count];
    SettingsViewController *parent = [array objectAtIndex:arrayCount - 2];
    [parent.editItem removeObjectAtIndex:1];
    [parent.editItem insertObject:result atIndex:1];
    
    return YES;
}


@end