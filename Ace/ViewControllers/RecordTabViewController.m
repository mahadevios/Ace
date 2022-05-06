//
//  RecordTabViewController.m
//  Ace
//
//  Created by mac on 12/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "RecordTabViewController.h"
#import "AppPreferences.h"
#import "Constants.h"
#import "RecordViewController.h"

@interface RecordTabViewController ()

@end

@implementation RecordTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@",self.view.window.rootViewController);
    [AppPreferences sharedAppPreferences].selectedTabBarIndex=1;
    UIViewController *alertViewController = [self.tabBarController.viewControllers objectAtIndex:ALERT_TAB_LOCATION];
    
     NSString* alertCount=[[NSUserDefaults standardUserDefaults] valueForKey:INCOMPLETE_TRANSFER_COUNT_BADGE];
    if ([alertCount isEqualToString:@"0"])
    {
        alertViewController.tabBarItem.badgeValue =nil;
    }
    else
        alertViewController.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] valueForKey:INCOMPLETE_TRANSFER_COUNT_BADGE];
   
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"dismiss"] isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"dismiss"];
        self.tabBarController.selectedIndex=0;
    }
    else
    {
        RecordViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"];
               
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
         [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
