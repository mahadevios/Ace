 //
//  ListViewController.m
//  Ace
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ListViewController.h"
#import "PopUpCustomView.h"


@interface ListViewController ()

@end

@implementation ListViewController

@synthesize segment,checkedIndexPath,longPressAdded;

#pragma mark: View Delegate and Associate Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setUpForMultipleFileSelection];
    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
    [self beginAppearanceTransition:true animated:true];

//        self.splitViewController.delegate = self;
    
    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
//    }
     
    detailVC.delegate = self;

}



-(void)viewWillAppear:(BOOL)animated
{
 
    [self setNavigationBar];
    
    [self getTransferredAndDeletedList];
    
    [self setAlertBadge];
   
    
    [self.tableView reloadData];
    
    [self.tabBarController.tabBar setHidden:NO];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    
        [self setAudioDetailOrEmptyViewController:0];
//
//        [self setFirstRowSelected];
    }
    
    [self.segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:16.0],
                                           NSForegroundColorAttributeName:[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1]}
    forState:UIControlStateNormal];
      
      [self.segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:16.0],
        NSForegroundColorAttributeName:[UIColor whiteColor]}
       forState:UIControlStateSelected];
}



-(void)setNavigationBar
{
    self.currentViewName = @"List";

    self.navigationItem.title = @"List";
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.checkedIndexPath removeAllObjects];
    
    [arrayOfMarked removeAllObjects];
    
    isMultipleFilesActivated = NO;
    
    toolBarAdded = NO;
    
//    [segment setSelectedSegmentIndex:0];

}

-(void)getTransferredAndDeletedList
{
    
    Database* db = [Database shareddatabase];
    
    APIManager* app = [APIManager sharedManager];
    
    app.transferredListArray = [db getListOfTransferredOrDeletedFiles:@"Transferred"];
    
    app.deletedListArray = [db getListOfTransferredOrDeletedFiles:@"Deleted"];
}

-(void)setAlertBadge
{
    int count = [[Database shareddatabase] getCountOfTransfersOfDicatationStatus:@"RecordingPause"];
    
    [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];//get count of imported non transferred files
    
    int importedFileCount = [AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count;
    
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



-(void)setFirstRowSelected
{
    if (self.splitViewController.isCollapsed == false) // for ipad reguler width reguler height
    {
        //if loop For iPad: added this because without this app was shwing empty audio detail screen when there is not any file list tab(after removing this check how list look when there is no file in list)
        if([APIManager sharedManager].transferredListArray.count >0 || [APIManager sharedManager].deletedListArray.count>0)
        {
            NSIndexPath *firstRowPath = [NSIndexPath indexPathForRow:0 inSection:0];
                   
            [self.tableView selectRowAtIndexPath:firstRowPath animated:NO scrollPosition: UITableViewScrollPositionNone];
                   
            [self tableView:self.tableView didSelectRowAtIndexPath:firstRowPath];
        }
       
    }
   
}

#pragma mark:Split VC delegate

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return true;
}

#pragma mark:Multiple File Selection

-(void)setUpForMultipleFileSelection
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    
    lpgr.minimumPressDuration = 1.0; //seconds
    
    lpgr.delegate = self;
    
    [self.tableView addGestureRecognizer:lpgr];
    
    self.checkedIndexPath = [[NSMutableArray alloc] init];
    
    arrayOfMarked=[[NSMutableArray alloc]init];
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (self.segment.selectedSegmentIndex==0)//if navigation title=@"somevalue" then only handle longpress
    {
        isMultipleFilesActivated = YES;
        
        [self addEmptyVCToSplitVC];
        
        APIManager* app=[APIManager sharedManager];
        
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        UITableViewCell* cell=[self.tableView cellForRowAtIndexPath:indexPath];
        //        UILabel* deleteStatusLabel=[cell viewWithTag:105];
        if (cell.accessoryType == UITableViewCellAccessoryNone)
        {
            NSDictionary* awaitingFileTransferDict= [app.transferredListArray objectAtIndex:indexPath.row];
            
            NSString* fileName=[awaitingFileTransferDict valueForKey:@"RecordItemName"];
            
            [self.checkedIndexPath addObject:fileName];
            
            [arrayOfMarked addObject:indexPath];
            
            [self hideAndShowUploadButton:YES];
            
            //[self hideAndShowLeftBarButton:YES];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            longPressAdded=YES;
        }
        
    }
}
- (void) hideAndShowUploadButton:(BOOL)isShown
{
    if (isShown)
    {
        self.navigationItem.title=@"";
        if (!toolBarAdded)
        {
            [self addToolbar];
            
        }
        
    }
    else
    {
        toolBarAdded=NO;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];

        
    }
}
-(void)addToolbar
{
    toolBarAdded=YES;
    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(30.0f, 10.0f, 150.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    //tools.layer.borderWidth = 1;
    tools.tag=101;
    tools.layer.borderColor = [[UIColor whiteColor] CGColor];
    tools.clipsToBounds = YES;
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    // Create a standard refresh button.
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteMutipleFiles)];
    
    [buttons addObject:bi];
    
    //Create a spacer.
    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    bi.width = 12.0f;
    [buttons addObject:bi];
    
    
    // Add profile button.
   
    
    bi = [[UIBarButtonItem alloc]initWithTitle:@"Select all" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllFiles:)];
    bi.tag=102;
    [bi setTintColor:[UIColor whiteColor]];
       [bi setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
       [UIFont fontWithName:@"Helvetica-Bold" size:14.0], NSFontAttributeName,
       [UIColor whiteColor], NSForegroundColorAttributeName,
       nil]
                             forState:UIControlStateNormal];
    
    [buttons addObject:bi];
    
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *threeButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = threeButtons;
    
    
    
    
    self.navigationItem.leftBarButtonItem=nil;
    //UIToolbar *tools1 = [[UIToolbar alloc]
    //                   initWithFrame:CGRectMake(-50.0f, 10.0f, 150.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    UIToolbar *tools1 = [[UIToolbar alloc]
                         initWithFrame:CGRectMake(-70.0f, 0.0f, 80.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    //tools.layer.borderWidth = 1;
    tools1.tag=101;
    tools1.layer.borderColor = [[UIColor whiteColor] CGColor];
    tools1.clipsToBounds = YES;
    
    NSMutableArray *buttons1 = [[NSMutableArray alloc] initWithCapacity:4];
    // Create a standard refresh button.
//    UIBarButtonItem *bi1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
//    bi1.imageInsets=UIEdgeInsetsMake(0, -30, 0, 0);
//    [buttons1 addObject:bi1];
    
    //Create a spacer.
//     UIBarButtonItem *bi1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    bi1.width = 8.0f;
//    [buttons1 addObject:bi1];
    
    
    // Add profile button.
    selectedCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 30, 20)];
    selectedCountLabel.text=[NSString stringWithFormat:@"%ld",arrayOfMarked.count];
     UIBarButtonItem *bi1 = [[UIBarButtonItem alloc]initWithCustomView:selectedCountLabel];
    [buttons1 addObject:bi1];
    
    bi1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    bi1.width = -15.0f;
    [buttons1 addObject:bi1];
    
    bi1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Check"] style:UIBarButtonItemStylePlain target:self action:nil];
    //bi1.imageInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    [buttons1 addObject:bi1];
    
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools1 setItems:buttons1 animated:NO];
    UIBarButtonItem *threeButtons1 = [[UIBarButtonItem alloc] initWithCustomView:tools1];
    self.navigationItem.leftBarButtonItem = threeButtons1;
    
    int uploadFileCount=0;
    for (NSInteger i = 0; i < [APIManager sharedManager].transferredListArray.count; ++i)
    {
        NSIndexPath* indexPath= [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell= [self.tableView cellForRowAtIndexPath:indexPath];
        UILabel* deleteStatusLabel=[cell viewWithTag:105];
        if ([deleteStatusLabel.text isEqual:@"Uploading"])
        {
            ++uploadFileCount;
        }
    }
    if ([APIManager sharedManager].transferredListArray.count-uploadFileCount==1)
    {
        UIBarButtonItem* vc=self.navigationItem.rightBarButtonItem;
        UIToolbar* view=  vc.customView;
        NSArray* arr= [view items];
        UIBarButtonItem* button= [arr objectAtIndex:2];
        //UIButton* button=  [view viewWithTag:102];
        
        [button setTitle:@"Deselect all"];
    }
    
    
    
}

-(void)selectAllFiles:(UIBarButtonItem*)sender
{
    
    if ([sender.title isEqualToString:@"Select all"])
    {
        sender.title=@"Deselect all";
        [self.checkedIndexPath removeAllObjects];
        [arrayOfMarked removeAllObjects];
        APIManager* app=[APIManager sharedManager];
        Database* db=[Database shareddatabase];
        app.transferredListArray=[db getListOfTransferredOrDeletedFiles:@"Transferred"];
        
        for (NSInteger i = 0; i < app.transferredListArray.count; ++i)
        {
            NSIndexPath* indexPath= [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell* cell= [self.tableView cellForRowAtIndexPath:indexPath];
            NSDictionary* awaitingFileTransferDict= [app.transferredListArray objectAtIndex:i];
            NSString* fileName=[awaitingFileTransferDict valueForKey:@"RecordItemName"];
            
            if (![[awaitingFileTransferDict valueForKey:@"DictationStatus"] isEqualToString:@"RecordingFileUpload"])
            {
                
                [arrayOfMarked addObject:indexPath];
                [cell setSelected:YES];
                [self.checkedIndexPath addObject:fileName];
                
            }
            selectedCountLabel.text=[NSString stringWithFormat:@"%ld",arrayOfMarked.count];
            
        }
        
        
        [self.tableView reloadData];
    }
    else
    {
        sender.title=@"Select all";
        //  self.navigationItem.title=self.currentViewName;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
        //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
        isMultipleFilesActivated=NO;
        [self.checkedIndexPath removeAllObjects];
        [arrayOfMarked removeAllObjects];
        selectedCountLabel.text=[NSString stringWithFormat:@"%ld",arrayOfMarked.count];
        
        toolBarAdded=NO;
        self.navigationItem.title = @"List";
        self.navigationItem.leftBarButtonItem = nil;
        [self.tableView reloadData];
        
        
    }
    
    
    
}

-(void)deleteMutipleFiles
{
    NSString* deleteMessage;
    if (arrayOfMarked.count > 1)
    {
        deleteMessage = DELETE_MESSAGE_MULTIPLES;
    }
    else
    {
        deleteMessage = DELETE_MESSAGE;
    }
    alertController = [UIAlertController alertControllerWithTitle:@"Delete"
                                                          message:deleteMessage
                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    
    actionDelete = [UIAlertAction actionWithTitle:@"Delete"
                                            style:UIAlertActionStyleDestructive
                                          handler:^(UIAlertAction * action)
                    {
                        
                        for (int i=0; i<arrayOfMarked.count; i++)
                            
                        {
                            Database* db=[Database shareddatabase];
                            APIManager* app=[APIManager sharedManager];
                            NSString* dateAndTimeString=[app getDateAndTimeString];
                            NSIndexPath* indexPath=[arrayOfMarked objectAtIndex:i];
                            
                            NSDictionary* awaitingFileTransferDict= [app.transferredListArray objectAtIndex:indexPath.row];
                            NSString* fileName=[awaitingFileTransferDict valueForKey:@"RecordItemName"];
                            self.navigationItem.title=self.currentViewName;
                            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];;
                            self.navigationItem.leftBarButtonItem = nil;
                            //                            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
                            isMultipleFilesActivated=NO;
                            toolBarAdded=NO;
                            [db updateAudioFileStatus:@"RecordingDelete" fileName:fileName dateAndTime:dateAndTimeString];
                            [app deleteFile:fileName];
                            [app deleteFile:[NSString stringWithFormat:@"%@backup",fileName]];
                            
                            
                        }
                        [arrayOfMarked removeAllObjects];
                        [self.tableView reloadData];
//                        [self addEmptyVCToSplitVC];
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                        
                        self.navigationItem.title=self.currentViewName;
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
                        self.navigationItem.leftBarButtonItem = nil;
                        
                        isMultipleFilesActivated=NO;
                        toolBarAdded=NO;
                        
                        [arrayOfMarked removeAllObjects];
                        [self.checkedIndexPath removeAllObjects];
                        [self.tableView reloadData];
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

#pragma mark: Navigation Bar Methods

-(void)popViewController:(id)sender
{
    [self.tabBarController.tabBar setHidden:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark: TableView DataSource and Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
   
    return 1;
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segment.selectedSegmentIndex==0)
    {
        [APIManager sharedManager].transferredListArray = [[Database shareddatabase] getListOfTransferredOrDeletedFiles:@"Transferred"];

        return [APIManager sharedManager].transferredListArray.count;
    }
    if (segment.selectedSegmentIndex==1)
    {
        [APIManager sharedManager].deletedListArray = [[Database shareddatabase] getListOfTransferredOrDeletedFiles:@"Deleted"];

        return [APIManager sharedManager].deletedListArray.count;
    }
    else
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel* fileNameLabel=[cell viewWithTag:101];
    UILabel* durationLabel=[cell viewWithTag:102];
    UILabel* transferByLabel=[cell viewWithTag:103];
    UILabel* dateLabel=[cell viewWithTag:104];
    UILabel* timeLabel=[cell viewWithTag:106];

    
    APIManager* app=[APIManager sharedManager];
    NSDictionary* dict;
    if (segment.selectedSegmentIndex==0)
    {
        dict= [app.transferredListArray objectAtIndex:indexPath.row];
    }
    else
    dict= [app.deletedListArray objectAtIndex:indexPath.row];
    
    fileNameLabel.text=[dict valueForKey:@"RecordItemName"];
    NSString* dateAndTimeString=[dict valueForKey:@"Date"];
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    if (segment.selectedSegmentIndex==0)
    {
        if (dateAndTimeArray.count>1)
        timeLabel.text=[NSString stringWithFormat:@"Transferred %@",[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]]];

    }
    else
    {
        if (dateAndTimeArray.count>1)
            timeLabel.text=[NSString stringWithFormat:@"Deleted %@",[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]]];


    }

    int audioHour= [[dict valueForKey:@"CurrentDuration"] intValue]/(60*60);
    int audioHourByMod= [[dict valueForKey:@"CurrentDuration"] intValue]%(60*60);
    
    int audioMinutes = audioHourByMod / 60;
    int audioSeconds = audioHourByMod % 60;
    
    durationLabel.text=[NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];
    //timeLabel.text=[NSString stringWithFormat:@"%@",@"Transferred 12:18:00 PM"];

    transferByLabel.text = [dict valueForKey:@"Department"];
    
    if (dateAndTimeArray.count>0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* dateStr = [NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]];
        NSDate *date = [dateFormatter dateFromString:dateStr];
        
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        
        dateLabel.text = newDateString;

//            dateLabel.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:0]]];

    }
    
    if ([arrayOfMarked containsObject:indexPath])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType=UITableViewCellAccessoryNone;
    
    if (isShownDetailsView == false)
    {
        if (self.splitViewController.isCollapsed == false)
        {
            if (detailVC == nil)
            {
                detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferredOrDeletedAudioDetailsViewController"];
                
                detailVC.delegate = self;
            }
            
            detailVC.listSelected = 0;
            
            detailVC.selectedRow = 0;
            
            [self.splitViewController showDetailViewController:detailVC sender:self];
            
        }
        isShownDetailsView = true;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    APIManager* app=[APIManager sharedManager];

    
    if (isMultipleFilesActivated)
    {
        int uploadFileCount;
//        UILabel* deleteStatusLabel=[cell viewWithTag:105];
        NSDictionary* awaitingFileTransferDict= [app.transferredListArray objectAtIndex:indexPath.row];
        NSString* fileName=[awaitingFileTransferDict valueForKey:@"RecordItemName"];
        
        for (NSInteger i = 0; i < app.transferredListArray.count; ++i)
        {
            NSIndexPath* indexPath= [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell* cell= [self.tableView cellForRowAtIndexPath:indexPath];
            UILabel* deleteStatusLabel=[cell viewWithTag:105];
            if ([deleteStatusLabel.text isEqual:@"Uploading"])
            {
                ++uploadFileCount;
            }
        }
        if (app.transferredListArray.count-uploadFileCount==1)
        {
            UIBarButtonItem* vc=self.navigationItem.rightBarButtonItem;
            UIToolbar* view=  vc.customView;
            NSArray* arr= [view items];
            UIBarButtonItem* button= [arr objectAtIndex:2];
            //UIButton* button=  [view viewWithTag:102];
            
            [button setTitle:@"Deselect all"];
        }
        if (arrayOfMarked.count == app.transferredListArray.count-uploadFileCount)
            
        {
            UIBarButtonItem* vc=self.navigationItem.rightBarButtonItem;
            UIToolbar* view=  vc.customView;
            NSArray* arr= [view items];
            UIBarButtonItem* button= [arr objectAtIndex:2];
            //UIButton* button=  [view viewWithTag:102];
            
            [button setTitle:@"Deselect all"];
        }
        
        if (cell.accessoryType == UITableViewCellAccessoryNone)
        {
            
            [self.checkedIndexPath addObject:fileName];
            [arrayOfMarked addObject:indexPath];
            selectedCountLabel.text=[NSString stringWithFormat:@"%ld",arrayOfMarked.count];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //
            if (arrayOfMarked.count == app.transferredListArray.count)
            {
                UIBarButtonItem* vc=self.navigationItem.rightBarButtonItem;
                UIToolbar* view=  vc.customView;
                NSArray* arr= [view items];
                UIBarButtonItem* button= [arr objectAtIndex:2];
                //UIButton* button=  [view viewWithTag:102];
                [button setTitle:@"Deselect all"];
            }
        }
        else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.checkedIndexPath removeObject:fileName];
            [arrayOfMarked removeObject:indexPath];
            selectedCountLabel.text=[NSString stringWithFormat:@"%ld",arrayOfMarked.count];
            
            //
            UIBarButtonItem* vc=self.navigationItem.rightBarButtonItem;
            UIToolbar* view=  vc.customView;
            NSArray* arr= [view items];
            UIBarButtonItem* button= [arr objectAtIndex:2];
            //UIButton* button=  [view viewWithTag:102];
            [button setTitle:@"Select all"];
            
        }
        
        if(arrayOfMarked.count > 0)
        {
            //Show upload files button
            
            [self hideAndShowUploadButton:YES];
        }
        else
        {
            //Remove upload files button.
            self.navigationItem.leftBarButtonItem= nil;
            self.navigationItem.title = @"List";
            isMultipleFilesActivated = NO;
            [self hideAndShowUploadButton:NO];

            if (self.splitViewController.isCollapsed == false) // for ipad reguler width reguler height
            {
                [self setAudioDetailOrEmptyViewController:indexPath.row];
            }
           

        }
    }

    else
    {
        if (self.splitViewController.isCollapsed) // not an ipad
        {
//            if (detailVC == nil)
//            {
                detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferredOrDeletedAudioDetailsViewController"];
            
            detailVC.delegate = self;
//            }
            detailVC.listSelected = segment.selectedSegmentIndex;
            //NSLog(@"%ld",vc.listSelected);
            detailVC.selectedRow = indexPath.row;
            
              detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self.navigationController presentViewController:detailVC animated:YES completion:nil];
        }
        else
        {
            if (detailVC == nil)
            {
                detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferredOrDeletedAudioDetailsViewController"];
                
                detailVC.delegate = self;
            }
            
//            detailVC.selectedRow = 0;
            
            detailVC.listSelected = segment.selectedSegmentIndex;
            //NSLog(@"%ld",vc.listSelected);
            detailVC.selectedRow = indexPath.row;
            
            [detailVC setAudioDetails];
            
//              detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self.splitViewController showDetailViewController:detailVC sender:self];

        }
   
    }
    
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
//    
//               if (isMultipleFilesActivated)
//            {
//                if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
//                {
//                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    NSDictionary* awaitingFileTransferDict= [[APIManager sharedManager].transferredListArray objectAtIndex:indexPath.row];
//                    NSString* fileName=[awaitingFileTransferDict valueForKey:@"RecordItemName"];
//                    [arrayOfMarked removeObject:indexPath];
//                    selectedCountLabel.text=[NSString stringWithFormat:@"%ld",arrayOfMarked.count];
//                    
//                    [self.checkedIndexPath removeObject:fileName];
//                    
//                    //
//                    UIBarButtonItem* vc=self.navigationItem.rightBarButtonItem;
//                    UIToolbar* view=  vc.customView;
//                    NSArray* arr= [view items];
//                    UIBarButtonItem* button= [arr objectAtIndex:2];
//                    //UIButton* button=  [view viewWithTag:102];
//                    [button setTitle:@"Select all"];
//                    
//                }
//                
//                if(arrayOfMarked.count > 0)
//                {
//                    //Show upload files button
//                    [self hideAndShowUploadButton:YES];
//                }
//                else
//                {
//                    //Remove upload files button.
//                    isMultipleFilesActivated = NO;
//                    [self hideAndShowUploadButton:NO];
//                }
//                
//            }
//        
//    
//}


- (void)didReceiveMemoryWarning {
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

- (IBAction)segmentChanged:(UISegmentedControl*)sender
{
    
    if (sender.selectedSegmentIndex == 1)
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserSettings:)];
        self.navigationItem.title = @"List";
        [self.checkedIndexPath removeAllObjects];
    
        [arrayOfMarked removeAllObjects];
        
    }
   
    self.segment.selectedSegmentIndex= sender.selectedSegmentIndex;
    isMultipleFilesActivated = NO;
    toolBarAdded = NO;
    
    [self.tableView reloadData];
    
    [self setAudioDetailOrEmptyViewController:0];

    if (sender.selectedSegmentIndex == 1)
    {
        if ([APIManager sharedManager].deletedListArray.count > 0)
        {
            [self setFirstRowSelected];
        }
    }
    else
    {
        if ([APIManager sharedManager].transferredListArray.count > 0)
        {
            [self setFirstRowSelected];
        }
    }
    
}

-(void)setAudioDetailOrEmptyViewController:(int)selectedRowIndex
{
    APIManager* app=[APIManager sharedManager];
    Database* db=[Database shareddatabase];
    [app.deletedListArray removeAllObjects];
    [app.transferredListArray removeAllObjects];
    app.deletedListArray=[db getListOfTransferredOrDeletedFiles:@"Deleted"];
    app.transferredListArray=[db getListOfTransferredOrDeletedFiles:@"Transferred"];
    if (self.splitViewController.isCollapsed == false) // if not collapsed that is reguler width hnce ipad
    {
        if (self.segment.selectedSegmentIndex == 0) // if transfer segment
        {
            if(app.transferredListArray.count==0) // if transferred count 0 then show empty VC  else show audio details
            {
                [self addEmptyVCToSplitVC];
            }
            else
            {
//                [self setFirstRowSelected]; // set first row seletced by default
                
                detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferredOrDeletedAudioDetailsViewController"];
                
                detailVC.delegate = self;
                
                detailVC.listSelected = 0;
                
                detailVC.selectedRow = selectedRowIndex;
                
                [self.splitViewController showDetailViewController:detailVC sender:self];
            }
        }
        else // else deleted segment
        {
            if(app.deletedListArray.count==0) // if delete count 0 then show empty else show audio details
            {
                [self addEmptyVCToSplitVC];
                
            }
            else
            {
                
                
                detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferredOrDeletedAudioDetailsViewController"];
                
                detailVC.delegate = self;
                
                detailVC.listSelected = 1;
                
                detailVC.selectedRow = selectedRowIndex;
                
                [self.splitViewController showDetailViewController:detailVC sender:self];
                
            }
        }
    }
    
}

-(void)addEmptyVCToSplitVC
{
    
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EmptyViewController"];
    
    NSMutableArray* subVC = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
    
    if (subVC.count > 1)
    {
        [subVC removeObjectAtIndex:1];
        
        [subVC addObject:vc];
        
    }
    else
    {
        [subVC addObject:vc];
    }
    
    [self.splitViewController setViewControllers:subVC];
    
}

- (void)myClassDelegateMethod:(TransferredOrDeletedAudioDetailsViewController *)sender
{
    [self.tableView reloadData];
    
    [self setFirstRowSelected];
}



@end
