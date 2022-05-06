//
//  SelectDepartmentViewController.m
//  Ace
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "SelectDepartmentViewController.h"
#import "MainTabBarViewController.h"
#import "LoginViewController.h"
#import "DepartMent.h"
#import "RegistrationViewController.h"
#import "MainTabBarViewController.h"
#import "SharedSession.h"
#import "AppDelegate.h"

@interface SelectDepartmentViewController ()

@end

@implementation SelectDepartmentViewController
@synthesize tableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Select Department";
    self.navigationItem.hidesBackButton=YES;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Database* db=[Database shareddatabase];
    departmentNameArray= [db getDepartMentNames];
    return departmentNameArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* departmentNameLabel=[cell viewWithTag:101];
    departmentNameLabel.text=[departmentNameArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    UITableViewCell* cell=[tableview cellForRowAtIndexPath:indexPath];
    UILabel* departmentNameLabel= [cell viewWithTag:101];
  
   
    
    DepartMent* deptObj = [[DepartMent alloc] init];
    deptObj= [[Database shareddatabase] getDepartMentFromDepartmentName:departmentNameLabel.text];
    
//    NSData *dataa = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deptObj];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SELECTED_DEPARTMENT_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];

   
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoadedFirstTime"];
    
    MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    
    [[Database shareddatabase] setDepartment];//to insert default department for imported files
    
//    [self dismissViewControllerAnimated:true completion:nil];
//
//    [[self presentingViewController] dismissViewControllerAnimated:true completion:nil];
//
//    [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
    [self setRootView];
}

-(void)setRootView
{
    MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    
    [[Database shareddatabase] setDepartment];//to insert default department for imported files
    
//    self.searchController.active = NO;
//
//    self.searchController.active = NO;
//    [self searchBarSearchButtonClicked:self.searchController.searchBar];

//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

   
//    [self.searchController dismissViewControllerAnimated:true completion:nil];
//    [self.searchController removeFromParentViewController];
//    [self.serachBarBGView removeFromSuperview];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    self.definesPresentationContext = true;
    
        
    // [appDelegate.window makeKeyWindow];
    //    UIWindow* winow = [[UIApplication sharedApplication] keyWindow];
    
    
//    self.searchController.active = NO; // Add this !
    
   
    
    

//    [[self presentingViewController] dismissViewControllerAnimated:true completion:nil];

   
//    [self.searchController.searchBar resignFirstResponder];

    
    
//    [self dismissViewControllerAnimated:true completion:nil];
//
//      [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
//    id vc1 = [self presentingViewController];
    
    [[self presentingViewController] dismissViewControllerAnimated:true completion:nil];

    [self checkAndDismissViewController];
    
    
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
    
    

}
- (void) checkAndDismissViewController
{
    [self.view endEditing:YES];
    id viewController = [self topViewController];
//    if([viewController isKindOfClass:[LoginViewController class]])
//    {
//        //do something
        [viewController dismissViewControllerAnimated:NO completion:nil];
//    }
//    NSLog(@"");
}

- (UIViewController *)topViewController
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}
//- (void) checkAndDismissViewController
//{
//    [self.view endEditing:YES];
//    id viewController = [self topViewController];
//    if([viewController isKindOfClass:[LoginViewController class]])
//    {
//        //do something
//        [viewController dismissViewControllerAnimated:NO completion:nil];
//    }
//}
//
//- (UIViewController *)topViewController
//{
//    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//}
//
//- (UIViewController *)topViewController:(UIViewController *)rootViewController
//{
//    if (rootViewController.presentedViewController == nil) {
//        return rootViewController;
//    }
//
//    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
//        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
//        return [self topViewController:lastViewController];
//    }
//
//    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
//    return [self topViewController:presentedViewController];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
