//
//  AlertViewController.m
//  Ace
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "AlertViewController.h"
#import "PopUpCustomView.h"
#import "Database.h"
#import "APIManager.h"
#import "AppPreferences.h"
#import "Constants.h"
#import "InCompleteDictationViewController.h"
#import "ImportedAudioViewController.h"
#import "VideoCallViewController.h"
#import "EditDocxViewController.h"

@interface AlertViewController ()

@end

@implementation AlertViewController
@synthesize VRSDocFilesArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    db=[Database shareddatabase];
    
    app=[APIManager sharedManager];
    
    [self beginAppearanceTransition:true animated:true];
    
    self.splitViewController.delegate = self;
    
    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHud) name:NOTIFICATION_FILE_IMPORTED object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setUpNavigationView];
    
    [self setSplitVCDetailViewSelectedRow:0];
    
    [self setFirstRowSelected];
}

-(void)setFirstRowSelected
{
    if (self.splitViewController.isCollapsed == false || self.splitViewController == nil) // for ipad reguler width reguler height
    {
        NSIndexPath *firstRowPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView selectRowAtIndexPath:firstRowPath animated:NO scrollPosition: UITableViewScrollPositionNone];
        
        [self tableView:self.tableView didSelectRowAtIndexPath:firstRowPath];
    }
    
}

-(void)setUpNavigationView
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
    
    self.navigationItem.title=@"Alert";
    
    app.incompleteFileTransferCount= [db getCountOfTransfersOfDicatationStatus:@"RecordingPause"];
    
    [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];
    
    VRSDocFilesArray = [[Database shareddatabase] getVRSDocFiles];
    
    [self.tableView reloadData];
    
    [self.tabBarController.tabBar setHidden:NO];
    
    [self showTabBadge];
}

-(void)setSplitVCDetailViewSelectedRow:(int)selectedRow
{
    if (self.splitViewController.isCollapsed == false) // if not collapsed that is reguler width hnce ipad
    {
        UINavigationController* navVC = [[UINavigationController alloc] init];

        switch (selectedRow)
        {
            case 0:
                if(app.incompleteFileTransferCount == 0) // if transferred count 0 then show empty VC  else show audio details
                {
                    InCompleteDictationViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InCompleteDictationViewController"];
                    
                    navVC = [navVC initWithRootViewController:detailVC];
                    
                    NSMutableArray* subVC = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
                    
                    if (subVC.count > 1)
                    {
                        [subVC removeObjectAtIndex:1];
                        
                        [subVC addObject:navVC];
                        
                    }
                    else
                    {
                        [subVC addObject:navVC];
                    }
                    
                    [self.splitViewController setViewControllers:subVC];
                    
                }
                else
                {
                    
                    InCompleteDictationViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InCompleteDictationViewController"];
                    
                    navVC = [navVC initWithRootViewController:detailVC];
                    
                    NSMutableArray* subVC = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
                    
                    if (subVC.count > 1)
                    {
                        [subVC removeObjectAtIndex:1];
                        
                        [subVC addObject:navVC];
                        
                    }
                    else
                    {
                        [subVC addObject:navVC];
                    }
                    
                    [self.splitViewController setViewControllers:subVC];
                   
                }
                break;
                
            case 1:
                {
                    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EmptyViewController"];
                
                    navVC = [navVC initWithRootViewController:vc];
                    
//                    navVC.navigationItem.hidesBackButton = YES;
                    
                    NSMutableArray* subVC = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
                    
                    if (subVC.count > 1)
                    {
                        [subVC removeObjectAtIndex:1];
                        
                        [subVC addObject:vc];
                        
                    }
                    else
                    {
                        [subVC addObject:navVC];
                    }
                    
                    [self.splitViewController setViewControllers:subVC];
                }
               
                break;
              
                
            case 2:
            {
                ImportedAudioViewController* detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportedAudioViewController"];
                
                navVC = [navVC initWithRootViewController:detailVC];
                
                NSMutableArray* subVC = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
                
                if (subVC.count > 1)
                {
                    [subVC removeObjectAtIndex:1];
                    
                    [subVC addObject:navVC];
                    
                }
                else
                {
                    [subVC addObject:navVC];
                }
                
                [self.splitViewController setViewControllers:subVC];
            }
                
                break;
                
            case 3:
            {
                VideoCallViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoCallViewController"];
                                   
                                   navVC = [navVC initWithRootViewController:detailVC];
                                   
                                   NSMutableArray* subVC = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
                                   
                                   if (subVC.count > 1)
                                   {
                                       [subVC removeObjectAtIndex:1];
                                       
                                       [subVC addObject:navVC];
                                       
                                   }
                                   else
                                   {
                                       [subVC addObject:navVC];
                                   }
                                   
                                   [self.splitViewController setViewControllers:subVC];
                
                break;
            }
            default:
                break;
        }
        
        
        
    }
}

#pragma mark:Split VC delegate

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return true;
}


-(void)showTabBadge
{
    int count= [[Database shareddatabase] getCountOfTransfersOfDicatationStatus:@"RecordingPause"];
    
    int importedFileCount=[AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",count+importedFileCount] forKey:INCOMPLETE_TRANSFER_COUNT_BADGE];
    
    NSString* alertCount=[[NSUserDefaults standardUserDefaults] valueForKey:INCOMPLETE_TRANSFER_COUNT_BADGE];
    
    UIViewController *alertViewController = [self.tabBarController.viewControllers objectAtIndex:ALERT_TAB_LOCATION];
    
    if ([alertCount isEqualToString:@"0"])
    {
        alertViewController.tabBarItem.badgeValue =nil;
    }
    else
        alertViewController.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] valueForKey:INCOMPLETE_TRANSFER_COUNT_BADGE];


}

//-(void)showhud
//{
//    hud.minSize = CGSizeMake(150.f, 100.f);
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.label.text = @"Importing Files..";
//    hud.detailsLabel.text = @"Please wait";
//
//}

-(void)hideHud
{
    [hud removeFromSuperview];
    
    [AppPreferences sharedAppPreferences].isImporting = NO;
    
    [self showTabBadge];
    
    [self.tableView reloadData];



}
-(void)showUserSettings:(id)sender
{
    
    NSArray* subViewArray=[NSArray arrayWithObjects:@"User Settings", nil];
    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, 40, 160, 40) andSubViews:subViewArray :self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:pop];
    
}

-(void)UserSettings
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
     UIViewController* vc = [self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"];
        
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(void)dismissPopView:(id)sender
{
    
    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* inCompleteDictationLabel=[cell viewWithTag:101];
    UILabel* noDictationLabel=[cell viewWithTag:102];
    
    
    switch (indexPath.row)
    {
        case 0:inCompleteDictationLabel.text=@"Incomplete Dictations";
            noDictationLabel.text=[NSString stringWithFormat:@"%d",app.incompleteFileTransferCount];
            break;
            
        case 1:inCompleteDictationLabel.text=@"No Dictation";
            noDictationLabel.text=@"0";
            break;
            
        case 2:inCompleteDictationLabel.text=@"Imported Dictations";
            noDictationLabel.text=[NSString stringWithFormat:@"%ld",[AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count];
            break;
            
//        case 3:inCompleteDictationLabel.text=@"Appointments";
////            noDictationLabel.text=[NSString stringWithFormat:@"%ld",[AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count];
//            break;
            
//        case 3:inCompleteDictationLabel.text=@"Completed Doc Files";
//            noDictationLabel.text = @"";
//            break;
//
//        case 4:inCompleteDictationLabel.text = @"Speech Transcription";
//            noDictationLabel.text = @"";
//            break;
//
//        case 5:inCompleteDictationLabel.text=@"VRS Doc Files";
//            noDictationLabel.text=[NSString stringWithFormat:@"%d",VRSDocFilesArray.count];
//            break;
        
        case 3:inCompleteDictationLabel.text = @"Custom Docx Editor";
            noDictationLabel.text = @"";
            break;
        
        case 4:inCompleteDictationLabel.text = @"Custom Docx Editor Copy";
            noDictationLabel.text = @"";
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditDocxViewController * vc;

    //MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    switch (indexPath.row)
    {
        case 0:
            if (self.splitViewController.isCollapsed)
            {
               [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"InCompleteDictationViewController"] animated:YES];
            }
            else
            {
                [self setSplitVCDetailViewSelectedRow:0];
            }
            
            break;
            
        case 1:
            if (self.splitViewController.isCollapsed)
            {
                
            }
            else
            {
                [self setSplitVCDetailViewSelectedRow:1];
            }
            break;
        
        case 2:
            if (self.splitViewController.isCollapsed)
            {

                [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ImportedAudioViewController"] animated:YES];
            }
            else
            {
                [self setSplitVCDetailViewSelectedRow:2];
            }
            
            break;
         
//        case 3:
//            if (self.splitViewController.isCollapsed)
//            {
//                [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"VideoCallViewController"] animated:YES];
//            }
//            else
//            {
//                [self setSplitVCDetailViewSelectedRow:3];
//            }
//
//            break;
        case 3:
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DocFilesViewController"] animated:YES];
            break;
//
//        case 4:
//            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SpeechRecognitionViewController"] animated:YES];
//            break;
//
//        case 5:
//            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileViewController"] animated:YES];
//            break;
        
        
        case 4:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDocxViewController"];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController presentViewController:vc animated:true completion:nil];
            break;
//        case 4:
//            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDocxTextKitViewController"];
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self.navigationController presentViewController:vc animated:true completion:nil];
//            break;
            
            
        default:
            break;
    }
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
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
