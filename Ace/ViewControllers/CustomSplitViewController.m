//
//  CustomSplitViewController.m
//  Ace
//
//  Created by mac on 25/03/20.
//  Copyright © 2020 Xanadutec. All rights reserved.
//

#import "CustomSplitViewController.h"

@interface CustomSplitViewController ()

@end

@implementation CustomSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    // Do any additional setup after loading the view.
}

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
