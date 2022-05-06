//
//  HomeViewController.m
//  Ace
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "HomeViewController.h"
#import "TransferListViewController.h"
#import "PopUpCustomView.h"
#import "AlertViewController.h"
#import "NSData+AES256.h"
#import "SharedSession.h"
#import "SelectFileViewController.h"
#import "UserSettingsViewController.h"
#import <StoreKit/SKStoreProductViewController.h>


//#import <iTunesLibrary/ITLibrary.h>


@interface HomeViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation HomeViewController

@synthesize transferredView,transferFailedView,awaitingTransferView,failedCountLabel,VRSDOCFilesView,VRSFilesCountLabel,VRSDocFilesArray;

#pragma mark: View Delegate And Associate methods

- (void)viewDidLoad
{
  
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
      selector:@selector(validateApntmntListResponse:) name:NOTIFICATION_GET_APNTMNT_LIST
        object:nil];
    
    NSString* dictatorName = [[NSUserDefaults standardUserDefaults] valueForKey:DICTATOR_NAME];
    if ([dictatorName isEqualToString:@""] || dictatorName == nil) {
        self.dictatorNameLabel.hidden = true;
    }else
        self.dictatorNameLabel.text = [NSString stringWithFormat:@"Welcome, %@",dictatorName];
//    app.awaitingFileTransferNamesArray=[[NSMutableArray alloc]init];
    
//    [self beginAppearanceTransition:true animated:true];

    db = [Database shareddatabase];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
    
    transferFailedView.layer.cornerRadius = 4.0f;
    
    transferredView.layer.cornerRadius = 4.0f;
    
    awaitingTransferView.layer.cornerRadius = 4.0f;
    
    _completedDocView.layer.cornerRadius = 4.0f;
    
    VRSDOCFilesView.layer.cornerRadius = 4.0f;
    // tap gesture recognisers for four title views
    transferredTodayViewTapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showList:)];
    awaitingViewTapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showList:)];
    appointmentTapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAppointmentView:)];
    vrsDocViewTapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showVRSDocFilesView:)];
    completedDocViewTapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCompletedDocFIlesView:)];
    
    [transferredView addGestureRecognizer:transferredTodayViewTapRecogniser];
    [awaitingTransferView addGestureRecognizer:awaitingViewTapRecogniser];
    [transferFailedView addGestureRecognizer:appointmentTapRecogniser];
    [VRSDOCFilesView addGestureRecognizer:vrsDocViewTapRecogniser];
    [_completedDocView addGestureRecognizer:completedDocViewTapRecogniser];
    
    // observer for transfer, awiating, failed recording counts change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCountsOfTransferredAwaitingFiles) name:NOTIFICATION_FILE_UPLOAD_API
                                               object:nil];
    
    // observer for completed doc API response
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(validateSendIdsResponse:) name:NOTIFICATION_SEND_DICTATION_IDS_API
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(validateCompletedDocResponse:) name:NOTIFICATION_COMPLETED_DOC_LIST
//                                               object:nil];
    // Do any additional setup after loading the view.
    
    [self setTabBarBackgroundImage];
}

-(void)setTabBarBackgroundImage
{
    UITabBar *tabBar = self.tabBarController.tabBar;
   
//    NSLog(@"navi height = %f", tabBar.frame.size.height);

    CGSize imgSize = CGSizeMake(tabBar.frame.size.width/tabBar.items.count,tabBar.frame.size.height+0.5);
    
    //Create Image
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0);
    UIBezierPath* p =
    [UIBezierPath bezierPathWithRect:CGRectMake(0,0,imgSize.width,imgSize.height+0.5)];
    [[UIColor colorWithRed:225/255.0 green:232/255.0 blue:246/255.0 alpha:1.0] setFill];
    [p fill];
    UIImage* finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [tabBar setSelectionIndicatorImage:finalImg];
}

-(void)viewDidAppear:(BOOL)animated
{
   
}
-(void)validateApntmntListResponse:(NSNotification*)dictObj
{
    NSDictionary* responseDict=dictObj.object;
       
    [self showIndicator:false];
    
    if ([[responseDict valueForKey:@"code"] isEqualToString:@"200"]) {
                      
    NSArray* aptList =  [responseDict valueForKey:@"ClinicalList"];
              
    self.completedDocCountLabel.text =  [NSString stringWithFormat:@"%ld",aptList.count];
        
    
     
//              if ([responseCodeString intValue] == 2001 || [responseCodeString intValue] == -1001)
//              {
//
//              }
    }
    else
    {
        self.completedDocCountLabel.text =  [NSString stringWithFormat:@"0"];
    }
      
      
}
-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"navi height = %@", self.navigationController.navigationBar.bounds);
   
    self.splitViewController.delegate = self;
    [AppPreferences sharedAppPreferences].selectedTabBarIndex=0;
    [AppPreferences sharedAppPreferences].isRecordView = NO;

//    [UIApplication sharedApplication].idleTimerDisabled = YES;

    self.tabBarController.tabBar.userInteractionEnabled = true;

    [self.tabBarController.tabBar setHidden:NO];
    
    // get count of Today's transferred, Awaiting transfer
    [self getCountsOfTransferredAwaitingFiles];
    
    // show count of transfer failed
    [self showTransferFailedCount];
    
    // show vrs doc files count
    [self showVRSFileCount];

    // check for complted docx file count
    //[self getAppointmentList];
    
//    [self checkForCompletedDocFiles];
    
    // check files tobe purge
    [self checkFilesToBePurge];
    
    
    [self setSplitViewController];
    
    NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
    [dfmt setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dfmt stringFromDate:[NSDate date]];
    self.appointmentDateLabel.text = [NSString stringWithFormat:@"For %@", dateString];
//    [self deleteDictation];
    NSLog(@"%@",NSHomeDirectory());

}


#pragma mark:Split VC delegate

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return true;
}

-(void)checkFilesToBePurge
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString* todaysDate = [formatter stringFromDate:[NSDate date]];
    
    //for first time to check files to be purge are available or not
    if ([[NSUserDefaults standardUserDefaults] valueForKey:PURGE_DATA_DATE]== NULL)
    {
        
        [self deleteDictation];
        //[self needsUpdate];
    }
    else
    if (!([[[NSUserDefaults standardUserDefaults] valueForKey:PURGE_DATA_DATE] isEqualToString:todaysDate]))// this wil be 2nd day after pressing later or pressing delete
    {
        [self deleteDictation];
        //  [self needsUpdate];
    }
}

-(void)showAppointmentView:(UITapGestureRecognizer*)sender
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        VideoCallViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoCallViewController"];
        
        CustomSplitViewController* splitVC = [CustomSplitViewController new];
        
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];;
        //
        [navVC.navigationBar setTintColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0]];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold],NSFontAttributeName, nil];
        
        //            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
        [navVC.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
        
        NSArray* splitVCArray = [[NSArray alloc] initWithObjects:navVC, nil];
        
        [splitVC setViewControllers:splitVCArray];
        
         splitVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:splitVC animated:NO completion:nil];
    }
    else
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"VideoCallViewController"] animated:YES];

    }
}



-(void)getAppointmentList
{
    NSString* date = [[APIManager sharedManager] getDateAndTimeString];
      [date componentsSeparatedByString:@" "];
     
    
    if ([[AppPreferences sharedAppPreferences] isReachable]) {
        
           NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
           DepartMent* deptObj = [[DepartMent alloc] init];
           deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [[APIManager sharedManager] getAppointmentList:@"407" date:@"2020-03-26"];

           [[APIManager sharedManager] getAppointmentList:[NSString stringWithFormat:@"%ld",deptObj.Id] date:date];
        
           
        [self showIndicator:true];
       }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:NO_INTERNET_TITLE_MESSAGE withMessage:NO_INTERNET_DETAIL_MESSAGE withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}

-(void) showIndicator:(BOOL)show
{
    if (show) {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidden:false];
        [self.completedDocCountLabel setHidden:true];
    }
    else
    {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:true];
        [self.completedDocCountLabel setHidden:false];
    }
}

-(void) showCompletedDocIndicator:(BOOL)show
{
    if (show) {
        [self.completedDocActivityIndicator startAnimating];
        [self.completedDocActivityIndicator setHidden:false];
        [self.completedDocCountNewLabel setHidden:true];
    }
    else
    {
        [self.completedDocActivityIndicator stopAnimating];
        [self.completedDocActivityIndicator setHidden:true];
        [self.completedDocCountNewLabel setHidden:false];
    }
}
-(void)showActivityIndicator
{
    // remove spinner if already exist
    if ([transferFailedView viewWithTag:12] != nil)
    {
        [[transferFailedView viewWithTag:12] removeFromSuperview];
    }
    
    //creating a spinner
    UIActivityIndicatorView * completedDocSpinner = [[UIActivityIndicatorView alloc]init];
    //changing color of completed document spinner
    
    // setting position of spinner on ui
    completedDocSpinner.frame = CGRectMake(_completedDocCountLabel.frame.origin.x,_completedDocCountLabel.frame.origin.y-20 ,30 ,30 );
    
    //making spinner height and weight bigger than the default size of spinner.
    completedDocSpinner.transform = CGAffineTransformMakeScale(1.75, 1.75);
    
    completedDocSpinner.tag = 12;
    
    //Adding spinner to Completed Doc view
    [transferFailedView addSubview:completedDocSpinner];
    
    // starting the spinner.
    [completedDocSpinner startAnimating];
    
    //hide completed document count label if spinner is visible
    self.completedDocCountLabel.hidden = YES;
}

// showing 1 Failed view depending on transfer failed count.
-(void) showTransferFailedCount
{
    // getting array of transfered failed
    NSArray * transferFailedCountArray = [db getListOfFileTransfersOfStatus:@"TransferFailed"];
    
    // getting count for transfer failed array
    int transferFailedCount = [transferFailedCountArray count];
    
    // if transferFailedCount is 0, don't show tansfer failed count view
    if(transferFailedCount==0)
    {
        self.transferFailedCountView.hidden = YES;
        
        self.transferFailedCountLabel.hidden = YES;
    }
    else
    {
        self.transferFailedCountView.hidden = NO;
        
        self.transferFailedCountLabel.hidden = NO;
        
        if (transferFailedCount > 9)
        {
            self.transferFailedCountLabel.text = [NSString stringWithFormat:@"9+ Failed"];

        }
        else
        {
            self.transferFailedCountLabel.text = [NSString stringWithFormat:@"%d Failed", transferFailedCount];

        }
    }
}

-(void)showVRSFileCount
{
    VRSDocFilesArray = [[Database shareddatabase] getVRSDocFiles];
    
    VRSFilesCountLabel.text = [NSString stringWithFormat:@"%ld",VRSDocFilesArray.count];

}

//-(void)validateSendIdsResponse:(NSNotification*)obj
//{
//    long completedDocCount = 0;
//
//    NSDictionary* response = obj.object;
//
//    [self showCompletedDocIndicator:false];
//
//    if ([[response valueForKey:@"code"]  isEqual: @"200"])
//    {
//        // getting completed files count.
//        NSArray* completedFilesResponseArray = [response valueForKey:@"CompletedList"];
//
//        completedDocCount = [completedFilesResponseArray count];
//        //converting integer value of completed doc count to string.
//        NSString* completedDocCountStrValue = [NSString stringWithFormat:@"%ld",completedDocCount];
//
//        self.completedDocCountNewLabel.text = completedDocCountStrValue;
//    }
//
//
//}

-(void)validateCompletedDocResponse:(NSNotification*)obj
{
    NSDictionary* response = obj.object;
    
    long completedDocCount = 0;
    
    [self showCompletedDocIndicator:false];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];

    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.completedDocDeptLabel.text = [NSString stringWithFormat:@"(%@)", deptObj.departmentName];
    
    if ([[response valueForKey:@"code"] intValue]  == 200)
    {
        // getting completed files count.
        NSArray* completedFilesResponseArray = [response valueForKey:@"ApprovalList"];
        
        completedDocCount = [completedFilesResponseArray count];
        //converting integer value of completed doc count to string.
        NSString* completedDocCountStrValue = [NSString stringWithFormat:@"%ld",completedDocCount];
     
        self.completedDocCountNewLabel.text = completedDocCountStrValue;
    }
        
}
-(BOOL) needsUpdate
{
    
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@", appID]];
    
    NSURLSession         *  session = [NSURLSession sharedSession];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* todaysDate = [formatter stringFromDate:[NSDate date]];
    
    NSURLSessionDataTask *  theTask = [session dataTaskWithRequest: [NSURLRequest requestWithURL: url] completionHandler:
                                       ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                       {
        if (data != nil) {
            
            
             NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                       
                                                       if ([lookup[@"resultCount"] integerValue] == 1)
                                                       {
                                                           
                                                           NSString* appStoreVersion = lookup[@"results"][0][@"version"];
                                                          
                                                           NSInteger kAppITunesItemIdentifier = [lookup[@"results"][0][@"trackId"] integerValue];

                                                           NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
                                                          
            //                                                       if ([appStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)
                                                           if (![appStoreVersion isEqualToString:currentVersion])

                                                           {
                                                               
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                                   
                                                                   NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
                                                                   //
                                                                   alertController = [UIAlertController alertControllerWithTitle:@"Update available for Ace"
                                                                                                                         message:nil
                                                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                                                   
                                                                   actionDelete = [UIAlertAction actionWithTitle:@"Update"
                                                                                                           style:UIAlertActionStyleDefault
                                                                                                         handler:^(UIAlertAction * action)
                                                                                   {
                                                                                       [self openStoreProductViewControllerWithITunesItemIdentifier:kAppITunesItemIdentifier];
                                                                                       //                                                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.com/apps/CubeDictate"]];
                                                                                       
                                                                                       [[NSUserDefaults standardUserDefaults] setValue:todaysDate forKey:PURGE_DATA_DATE];//to avoid multiple popuops on same day
                                                                                       //
                                                                                   }]; //You can use a block here to handle a press on this button
                                                                   [alertController addAction:actionDelete];
                                                                   
                                                                   
                                                                   actionCancel = [UIAlertAction actionWithTitle:@"Later"
                                                                                                           style:UIAlertActionStyleCancel
                                                                                                         handler:^(UIAlertAction * action)
                                                                                   {
                                                                                       
                                                                                       
                                                                                       [[NSUserDefaults standardUserDefaults] setValue:todaysDate forKey:PURGE_DATA_DATE];//to avoid multiple popuops on same day
                                                                                       
                                                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                                       //
                                                                                   }]; //You can use a block here to handle a press on this button
                                                                   [alertController addAction:actionCancel];
                                                                   
                                                                   
                                                                   [[[[UIApplication sharedApplication] keyWindow] rootViewController]  presentViewController:alertController animated:YES completion:nil];
                                                                   
                                                               });
                                                               
                                                           }
                                                           else
                                                           {
                                                               [[NSUserDefaults standardUserDefaults] setValue:todaysDate forKey:PURGE_DATA_DATE];

                                                           }
                                                               //return YES;
                                                           }
                                                       
        }
                                          
                                       }];
    
    [theTask resume];
    
    return NO;
}


- (void)openStoreProductViewControllerWithITunesItemIdentifier:(NSInteger)iTunesItemIdentifier {
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSNumber *identifier = [NSNumber numberWithInteger:iTunesItemIdentifier];
    
    NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:identifier };
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [viewController presentViewController:storeViewController
                                                                        animated:YES
                                                                      completion:nil];
                                       else NSLog(@"SKStoreProductViewController: %@", error);
                                   }];
    
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)deleteDictation
{
//    [[Database shareddatabase] updateDateFormat];
    NSString* purgeDeleteDataKey =  [[NSUserDefaults standardUserDefaults] valueForKey:PURGE_DELETED_DATA];

    if (![purgeDeleteDataKey isEqualToString:@"Do not purge"])
    {
 
        NSArray* filesToBePurgedArray = [[Database shareddatabase] getFilesToBePurged];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyy-MM-dd";
        
        NSString* todaysDate = [formatter stringFromDate:[NSDate date]];
    
        if (filesToBePurgedArray.count > 0)
        {
            alertController = [UIAlertController alertControllerWithTitle:@"Purge Old Dictations?"
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
            actionDelete = [UIAlertAction actionWithTitle:@"Purge"
                                                style:UIAlertActionStyleDestructive
                                              handler:^(UIAlertAction * action)
                        {
                            hud.minSize = CGSizeMake(150.f, 100.f);
                            
                            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                            
                            hud.mode = MBProgressHUDModeIndeterminate;
                            
                            hud.label.text = @"Deleting...";
                            
                            hud.detailsLabel.text = @"Please wait";
                            
                            for (int i=0; i< filesToBePurgedArray.count; i++)
                            {
                          
                                NSString* fileName = [filesToBePurgedArray objectAtIndex:i];
                                
                                [db deleteFileRecordFromDatabase:fileName];
                                
                                [app deleteFile:[NSString stringWithFormat:@"%@backup",fileName]];
                                
                                [[APIManager sharedManager] deleteFile:fileName];
                                
                            }
                            
                            [hud removeFromSuperview];
                            
                            [[NSUserDefaults standardUserDefaults] setValue:todaysDate forKey:PURGE_DATA_DATE];//to avoid multiple popuops on same day
                            
                            if ([AppPreferences sharedAppPreferences].isReachable)
                            {
                                [self needsUpdate];
                            }
                            

                            [self dismissViewControllerAnimated:YES completion:nil];

                        }]; //You can use a block here to handle a press on this button
        
            [alertController addAction:actionDelete];
        
        
        
            actionCancel = [UIAlertAction actionWithTitle:@"Later"
                                                style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction * action)
                        {
                           
                            if ([AppPreferences sharedAppPreferences].isReachable)
                            {
                                [self needsUpdate];
                            }
                            
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                            
                            [[NSUserDefaults standardUserDefaults] setValue:todaysDate forKey:PURGE_DATA_DATE];
                            
                        }]; //You can use a block here to handle a press on this button
            
            [alertController addAction:actionCancel];
        
            [self presentViewController:alertController animated:YES completion:nil];
    
        }
        else
        {
            if ([AppPreferences sharedAppPreferences].isReachable)
            {
                [self needsUpdate];
            }
        }
    }
    else
    {
        if ([AppPreferences sharedAppPreferences].isReachable)
        {
            [self needsUpdate];
        }
    }
}

-(void)getCountsOfTransferredAwaitingFiles
{
  
    app = [APIManager sharedManager];
    
    app.awaitingFileTransferCount = [db getCountOfTransfersOfDicatationStatus:@"RecordingComplete"];
    
    app.todaysFileTransferCount = [db getCountOfTodaysTransfer:[app getDateAndTimeString]];
    
//    app.transferFailedCount = [db getCountOfTransferFailed];
    
    // show awaitng and todays file count
    UITextField* awaitingFileTransferCountTextFiled=[self.view viewWithTag:502];
    
    UITextField* todaysFileTransferCountTextFiled=[self.view viewWithTag:501];

    awaitingFileTransferCountTextFiled.text=[NSString stringWithFormat:@"%d",app.awaitingFileTransferCount];
    
    todaysFileTransferCountTextFiled.text=[NSString stringWithFormat:@"%d",app.todaysFileTransferCount];
    
//    UITextField* transferFailedCountTextFiled=[self.view viewWithTag:503];
//    transferFailedCountTextFiled.text=[NSString stringWithFormat:@"%d",app.transferFailedCount];
    
    // get incomplete and imported files count to show on alert tab
    int count= [db getCountOfTransfersOfDicatationStatus:@"RecordingPause"];
    
    [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];//get count of imported non transferred files

    long importedFileCount = [AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",count+importedFileCount] forKey:INCOMPLETE_TRANSFER_COUNT_BADGE];
    
    NSString* alertCount=[[NSUserDefaults standardUserDefaults] valueForKey:INCOMPLETE_TRANSFER_COUNT_BADGE];
    
    UIViewController *alertViewController = [self.tabBarController.viewControllers objectAtIndex:ALERT_TAB_LOCATION];

    if ([alertCount isEqualToString:@"0"])
    {
        alertViewController.tabBarItem.badgeValue =nil;
    }
    else
    alertViewController.tabBarItem.badgeValue = [[NSUserDefaults standardUserDefaults] valueForKey:INCOMPLETE_TRANSFER_COUNT_BADGE];

}

-(void)showUserSettings:(id)sender
{
    [self addPopViewForMoreOptions];
}

-(void)addPopViewForMoreOptions
{
    NSArray* subViewArray = [NSArray arrayWithObjects:@"User Settings",@"Logout", nil];
    
    UIView* pop = [[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, 40, 160, 84) andSubViews:subViewArray :self];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:pop];
}

-(void)UserSettings
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
      UserSettingsViewController *vc = [self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"];
     
     vc.modalPresentationStyle = UIModalPresentationFullScreen;
     
     [self.tabBarController presentViewController:vc animated:YES completion:nil];
}

-(void)Logout
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
    [AppPreferences sharedAppPreferences].userObj = nil;
    
   UIViewController* vc= [self.storyboard  instantiateViewControllerWithIdentifier:@"LoginViewController"];
       
       vc.modalPresentationStyle = UIModalPresentationFullScreen;
       
       [self presentViewController:vc animated:true completion:nil];


//    [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
}

// dismiss popview ForMoreOptions
-(void)dismissPopView:(id)sender
{
    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }
}

// show awaiting or todays view after tapped
-(void)showList:(UITapGestureRecognizer*)sender
{
   
    TransferListViewController* vc=[self.storyboard instantiateViewControllerWithIdentifier:@"TransferListViewController"];
    if (sender == transferredTodayViewTapRecogniser)
    {
        vc.currentViewName=@"Transferred Today";
    }
    if (sender==awaitingViewTapRecogniser)
    {
        vc.currentViewName=@"Awaiting Transfer";
        
    }
//    if (sender==tapRecogniser2)
//    {
//        vc.currentViewName=@"Transfer Failed";
//    }
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CustomSplitViewController* splitVC = [CustomSplitViewController new];
        
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];;
        //
        [navVC.navigationBar setTintColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0]];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold],NSFontAttributeName, nil];
        
        
        [navVC.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
        
        NSArray* splitVCArray = [[NSArray alloc] initWithObjects:navVC, nil];

        [splitVC setViewControllers:splitVCArray];
        
        splitVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:splitVC animated:NO completion:nil];
    }
    else
    {
        [self.navigationController pushViewController:vc animated:true];
    }
 
    
}

-(void)setSplitViewController
{
//    UISplitViewController* splitVC = [UISplitViewController new];
//    
//    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];;
//    
//    UIViewController* emptyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmptyViewController"];
//    
//    NSArray* splitVCArray = [[NSArray alloc] initWithObjects:navVC, nil];
//    
//    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAutomatic];
//    
//    NSArray* arr = self.splitViewController.viewControllers;
//    
//    [self.splitViewController splitViewController:self.splitViewController collapseSecondaryViewController:emptyVC ontoPrimaryViewController:self];
//    [splitVC setViewControllers:splitVCArray];
//    
//    [[UIApplication sharedApplication].keyWindow setRootViewController:splitVC];
//    UIViewController* vc = [arr objectAtIndex:1];
//    [self.splitViewController collapseSecondaryViewController:vc forSplitViewController:self.splitViewController];
}


// show completed docx view after tapped
-(void)showCompletedDocFIlesView:(UITapGestureRecognizer*)sender
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        SelectFileViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DocFilesViewController"];
        
        UISplitViewController* splitVC = [UISplitViewController new];
        
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];;
        //
        [navVC.navigationBar setTintColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0]];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold],NSFontAttributeName, nil];
        
        //            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
        [navVC.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
        
        NSArray* splitVCArray = [[NSArray alloc] initWithObjects:navVC, nil];
        
        [splitVC setViewControllers:splitVCArray];
        
         splitVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:splitVC animated:NO completion:nil];
    }
    else
    {
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DocFilesViewController"] animated:YES];

    }
    
}

// show vrs doc file view after tapped
-(void)showVRSDocFilesView:(UITapGestureRecognizer*)sender
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        SelectFileViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileViewController"];

        UISplitViewController* splitVC = [UISplitViewController new];
        
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];;
        //
        [navVC.navigationBar setTintColor:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0]];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold],NSFontAttributeName, nil];
        
        //            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
        [navVC.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
        
        NSArray* splitVCArray = [[NSArray alloc] initWithObjects:navVC, nil];
        
        [splitVC setViewControllers:splitVCArray];
        
         splitVC.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:splitVC animated:NO completion:nil];
    }
    else
    {
         [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileViewController"] animated:YES];
    }
   

}

-(void)checkForCompletedDocFiles
{
    // get mobiledicataionid to send it to the server
//    NSArray* uploadedFilesDictationIdArray = [[Database shareddatabase] getUploadedFilesDictationIdList:false filterDate:@"5"];
//
//    NSString* uploadedFilesDictationIdString = [uploadedFilesDictationIdArray componentsJoinedByString:@","];
    
    // send dictation ids to server to get list of completed doc
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
//        [[APIManager sharedManager] sendDictationIds:uploadedFilesDictationIdString];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];

        DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [[APIManager sharedManager] getCompletedDoc:[NSString stringWithFormat:@"%ld", deptObj.Id]];
        
        [self showCompletedDocIndicator:true];
    }
    else
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
