//
//  InCompleteDictationViewController.m
//  Ace
//
//  Created by mac on 04/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "InCompleteDictationViewController.h"
#import "InCompleteRecordViewController.h"
#import "RecordViewController.h"


@interface InCompleteDictationViewController ()

@end

@implementation InCompleteDictationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    app=[APIManager sharedManager];
    db=[Database shareddatabase];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([AppPreferences sharedAppPreferences].recordNew)
    {
        RecordViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"];
        //recordingNew=YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"dismiss"];
        [AppPreferences sharedAppPreferences].recordNew=NO;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"dismiss"];

        if (self.splitViewController.isCollapsed)
        {
            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
            
            [self.tabBarController.tabBar setHidden:YES];


        }
        else // for ipad
        {
             self.navigationItem.leftBarButtonItem = nil;
            
            [self.tabBarController.tabBar setHidden:NO];
            
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold],NSFontAttributeName, nil];
            
//            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];

            [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
        }
    
    self.navigationItem.title=@"Incomplete Dictations";
       
    [APIManager sharedManager].inCompleteFileTransferNamesArray = [db getListOfFileTransfersOfStatus:@"RecordingPause"];
    [self.tableView reloadData];
   // NSLog(@"%lu",(unsigned long)app.inCompleteFileTransferNamesArray.count);
    
        int count= [db getCountOfTransfersOfDicatationStatus:@"RecordingPause"];
        
        [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];//get count of imported non transferred files
        
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
    

}
-(void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return app.inCompleteFileTransferNamesArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary* awaitingFileTransferDict= [app.inCompleteFileTransferNamesArray objectAtIndex:indexPath.row];
    
    UILabel* recordItemName=[cell viewWithTag:101];
    recordItemName.text=[awaitingFileTransferDict valueForKey:@"RecordItemName"];
    
    NSString* dateAndTimeString=[awaitingFileTransferDict valueForKey:@"RecordCreatedDate"];
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    
    
    UILabel* recordingDurationLabel=[cell viewWithTag:102];
    int audioHour= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]/(60*60);
    int audioHourByMod= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]%(60*60);

    int audioMinutes = audioHourByMod / 60;
    int audioSeconds = audioHourByMod % 60;
    
    recordingDurationLabel.text=[NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];
  //  NSLog(@"%@",recordingDurationLabel.text);
    
    UILabel* departmentNameLabel=[cell viewWithTag:103];
    departmentNameLabel.text=[awaitingFileTransferDict valueForKey:@"Department"];
    
    UILabel* dateLabel=[cell viewWithTag:104];
    
    if (dateAndTimeArray.count>1)
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* dateStr = [NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]];
        NSDate *date = [dateFormatter dateFromString:dateStr];
        
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        
        dateLabel.text = newDateString;

        
        UILabel* timeLabel=[cell viewWithTag:105];
        timeLabel.text=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]];
    }
//    dateLabel.text=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]];
    
    
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    UITableViewCell* cell= [tableView cellForRowAtIndexPath:indexPath];
    UILabel* fileNameLabel=[cell viewWithTag:101];
    UILabel* recordingDurationLabel=[cell viewWithTag:102];
    UILabel* nameLabel=[cell viewWithTag:103];
    UILabel* dateLabel=[cell viewWithTag:104];
    NSDictionary* awaitingFileTransferDict= [app.inCompleteFileTransferNamesArray objectAtIndex:indexPath.row];

    int audioDurationInSeconds = [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue];

    InCompleteRecordViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"InCompleteRecordViewController"];
    vc.existingAudioFileName=fileNameLabel.text;
    vc.audioDuration=recordingDurationLabel.text;
    vc.existingAudioDepartmentName=nameLabel.text;
    vc.existingAudioDate=dateLabel.text;
    vc.audioDurationInSeconds = audioDurationInSeconds;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
   
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
