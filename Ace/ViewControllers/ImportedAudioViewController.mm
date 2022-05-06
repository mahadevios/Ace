//
//  ImportedAudioViewController.m
//  Ace
//
//  Created by mac on 27/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ImportedAudioViewController.h"
#import "AudioDetailsViewController.h"
#import "Database.h"
#import "APIManager.h"
#import "AppPreferences.h"
#import "Constants.h"

extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);

@interface ImportedAudioViewController ()

@end

@implementation ImportedAudioViewController

@synthesize audioFilePath;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Imported Dictations";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateFileUploadResponse:) name:NOTIFICATION_FILE_UPLOAD_API
                                               object:nil];
    // Do any additional setup after loading the view.
}

-(void)validateFileUploadResponse:(NSNotification*)obj
{
    [[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];

    [self.tableView reloadData];
}
-(void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//    
//    NSLog(@"%@",[sharedDefaults objectForKey:@"output"]);
//   // NSString* sharedAudioFolderPathString=[sharedDefaults objectForKey:@"audioFolderPath"];
//    
//    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
//    
//    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//    
//    int insertedFileCount = [[Database shareddatabase] getImportedFileCount];
//    
//    if (insertedFileCount<sharedAudioNamesArray.count)
//    {
//        //long unInsertedFileCount=sharedAudioNamesArray.count-insertedFileCount;
//        
//        [self setCompressAudio:insertedFileCount];
//        [self saveAudioRecordToDatabase:insertedFileCount];
//
//
//    }
//    
//    NSMutableDictionary* updatedFileDict=[sharedDefaults objectForKey:@"updatedFileDict"];
//
//    for (NSString* updatedFileNAme in [updatedFileDict allKeys])
//    {
//        NSString* updatedValue= [updatedFileDict objectForKey:updatedFileNAme];
//
//        if ([updatedValue isEqualToString:@"YES"])
//        {
//            NSLog(@"%@",updatedFileNAme);
//            [[Database shareddatabase] updateAudioFileDeleteStatus:@"NoDelete" fileName:updatedFileNAme];
//            [self setCompressAudioFileName:updatedFileNAme];
//
//        }
//    }
    
    //[[Database shareddatabase] getlistOfimportedFilesAudioDetailsArray:5];
    
    int count= [[Database shareddatabase] getCountOfTransfersOfDicatationStatus:@"RecordingPause"];
    
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
    

    [self.tableView reloadData];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    if (self.splitViewController.isCollapsed)
    {
        
        
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
        
        [self.tabBarController.tabBar setHidden:YES];
        
    }
    
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        
        self.navigationController.navigationBar.hidden = false;
        
        [self.tabBarController.tabBar setHidden:NO];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold],NSFontAttributeName, nil];
        
        //            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
        [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
        
    }
   

    
}
- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//-(void)showAudio
//{
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//    
//    NSString* audioFolderPath=[sharedDefaults objectForKey:@"audioFolderPath"];
//    
//    NSMutableArray* audioNamesArray=[NSMutableArray new];
//    
//    audioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//    
//    NSLog(@"%d",[sharedDefaults boolForKey:@"is"]);
//    if (nextCount<audioNamesArray.count)
//    {
//        NSString* audioFilePathString=[audioNamesArray objectAtIndex:nextCount];
//        nextCount++;
//
//        
//        audioFilePathString=[audioFilePathString stringByAppendingPathExtension:@"wav"];
//        NSURL* newurl=[NSURL URLWithString:audioFolderPath];
//        
//        NSString* audioFilePath1=[newurl.path stringByAppendingPathComponent:audioFilePathString];
//        
//        NSData* audioData=[NSData dataWithContentsOfFile:audioFilePath1];
//        
//        
//        NSLog(@"%@",[sharedDefaults objectForKey:@"assetUrl"]);
//        
//        //        dispatch_async(dispatch_get_main_queue(), ^
//        //                       {
//        //NSLog(@"Reachable");
//        NSError* error;
//       
//        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
//       
//        player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
//        
//        [player play];
//        
//       // bool playing=[self.player isPlaying];
//        NSLog(@"%@", error.localizedDescription);
//        
//        // });
//        
//    }
//    
//}



//-(void)setCompressAudio:(int)insertedFileCount
//{
//    NSMutableArray* audioNamesArray=[NSMutableArray new];
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//
//    audioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//    for (long i=0+insertedFileCount; i<audioNamesArray.count; i++)
//    {
//    
//    NSString* audioFolderPath=[sharedDefaults objectForKey:@"audioFolderPath"];
//        
//    NSLog(@"%d",[sharedDefaults boolForKey:@"is"]);
//    
//    NSString* audioFileNameString=[audioNamesArray objectAtIndex:i];
//    
//    NSString* audioFileNameForDestination= [NSString stringWithFormat:@"Copied%@",audioFileNameString];
//
//    NSURL* newurl=[NSURL URLWithString:audioFolderPath];
//    
//    audioFilePath=[newurl.path stringByAppendingPathComponent:audioFileNameString];
//    
//
//    NSString* audioFilePathForDestination=[newurl.path stringByAppendingPathComponent:audioFileNameForDestination];
//    
//    destinationFilePath= [NSString stringWithFormat:@"%@",audioFilePathForDestination];
//    //destinationFilePath = [[NSString alloc] initWithFormat: @"%@/output.caf", documentsDirectory];
//    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
//    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)audioFilePath, kCFURLPOSIXPathStyle, false);
//    NSError* error;
//    
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
//    
//    if (error)
//    {
//        printf("Setting the AVAudioSessionCategoryAudioProcessing Category failed! %ld\n", (long)error.code);
//        
//        return;
//    }
//    
//    
//   
//     [self convertAudio];
//    }
//}

//-(void)setCompressAudioFileName:(NSString*)audioFileNameString
//{
//    NSMutableArray* audioNamesArray=[NSMutableArray new];
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//    
//    audioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//   
//        
//        NSString* audioFolderPath=[sharedDefaults objectForKey:@"audioFolderPath"];
//        
//        NSLog(@"%d",[sharedDefaults boolForKey:@"is"]);
//    
//        NSString* audioFileNameForDestination= [NSString stringWithFormat:@"Copied%@",audioFileNameString];
//        
//        NSURL* newurl=[NSURL URLWithString:audioFolderPath];
//        
//        audioFilePath=[newurl.path stringByAppendingPathComponent:audioFileNameString];
//    
//   
//        
//        NSString* audioFilePathForDestination=[newurl.path stringByAppendingPathComponent:audioFileNameForDestination];
//        
//        destinationFilePath= [NSString stringWithFormat:@"%@",audioFilePathForDestination];
//        //destinationFilePath = [[NSString alloc] initWithFormat: @"%@/output.caf", documentsDirectory];
//        destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
//        sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)audioFilePath, kCFURLPOSIXPathStyle, false);
//        NSError* error;
//        
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
//        
//        if (error)
//        {
//            printf("Setting the AVAudioSessionCategoryAudioProcessing Category failed! %ld\n", (long)error.code);
//            
//            return;
//        }
//        
//        
//        
//        [self convertAudio];
//   
//}

//- (bool)convertAudio
//{
//    //    outputFormat = kAudioFormatLinearPCM;
//    outputFormat = kAudioFormatLinearPCM;
//    
//      sampleRate = 8000.0;
//    //sampleRate = 0;
//    
//    OSStatus error = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate);
//    NSError* error1;
//    
//    if (error) {
//
//        
//        return false;
//    }
//    else
//    {
//        NSLog(@"Converted");
//        
//        NSError* error;
//
//        NSString* folderPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
//        
//        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
//            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//        
//        NSString* homeDirectoryFileName=[audioFilePath lastPathComponent];//store on same name as shared file name
//
//          // [[NSFileManager defaultManager] moveItemAtPath:destinationFilePath toPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,@"compressed"]] error:&error1];
//                if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,homeDirectoryFileName]]])
//                {
//                    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,homeDirectoryFileName]] error:nil];
//                }
//
//     bool copied=   [[NSFileManager defaultManager] copyItemAtPath:destinationFilePath toPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,homeDirectoryFileName]] error:&error1];
//
//        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath])
//        {
//            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:&error];//remove temporary file which was used to store compression result
//        }
//        if ([[NSFileManager defaultManager] fileExistsAtPath:audioFilePath])
//        {
//            [[NSFileManager defaultManager] removeItemAtPath:audioFilePath error:&error];//remove file stored at shared storage(i.e. in path extension) 
//        }
//        
//        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//
//        
//        NSDictionary* copyDict=[sharedDefaults objectForKey:@"updatedFileDict"];
//        
//        NSMutableDictionary* updatedFileDict=[copyDict mutableCopy];
//        
//        [updatedFileDict setObject:@"NO" forKey:homeDirectoryFileName];
//        
//        [sharedDefaults setObject:updatedFileDict forKey:@"updatedFileDict"];
//        
//        [sharedDefaults synchronize];
//        
//        return true;
//    }
//    
//}

//-(void)saveAudioRecordToDatabase:(long) insertedFileCount
//{
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//
//    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
//    
//    NSMutableDictionary* sharedAudioNamesAndDateDict=[NSMutableDictionary new];
//
//    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//    
//    sharedAudioNamesAndDateDict=[sharedDefaults objectForKey:@"audioNamesAndDateDict"];
//
//    NSLog(@"%ld",sharedAudioNamesAndDateDict.count);
//
//    for (long i=0+insertedFileCount; i<sharedAudioNamesArray.count; i++)
//    {
//        NSString* fileName=[sharedAudioNamesArray objectAtIndex:i];
//        
//        APIManager* app=[APIManager sharedManager];
//        
//        NSString* sharedAudioFilePathString= [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,fileName]];
//        
//        NSString* filePath=sharedAudioFilePathString;
//        
//        uint64_t freeSpaceUnsignLong= [[APIManager sharedManager] getFileSize:filePath];
//        
//        long fileSizeinKB=freeSpaceUnsignLong;
//        
//        [self prepareAudioPlayer:sharedAudioFilePathString];//initiate audio player with current recording to get currentAudioDuration
//        
//        NSString* recordCreatedDateString=[app getDateAndTimeString];//recording createdDate
//        
//        NSString* recordingDate=@"";//recording updated date
//        
//        int dictationStatus=5;
//
//        int transferStatus=0;
//        
//        int deleteStatus=0;
//        
//        NSString* deleteDate=@"";
//        
//        NSString* transferDate=@"";
//        
//
//        NSString *currentDuration1=[NSString stringWithFormat:@"%f",player.duration];
//        
//        NSURL* fileURL=[NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        
//        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL
//                                                    options:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                             [NSNumber numberWithBool:YES],
//                                                             AVURLAssetPreferPreciseDurationAndTimingKey,
//                                                             nil]];
//        
//        NSTimeInterval durationInSeconds = 0.0;
//        
//        if (asset)
//            durationInSeconds = CMTimeGetSeconds(asset.duration) ;
//        
//        NSString* fileSize=[NSString stringWithFormat:@"%ld",fileSizeinKB];
//        
//        int newDataUpdate=5;//5 for imported file
//        
//        int newDataSend=0;
//        
//        int mobileDictationIdVal;
//        
//        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
//        
//        DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        
//        NSString* departmentName=[[Database shareddatabase] getDepartMentIdFromDepartmentName:deptObj.departmentName];
//        
//        NSDictionary* audioRecordDetailsDict=[[NSDictionary alloc]initWithObjectsAndKeys:fileName,@"recordItemName",recordCreatedDateString,@"recordCreatedDate",recordingDate,@"recordingDate",transferDate,@"transferDate",[NSString stringWithFormat:@"%d",dictationStatus],@"dictationStatus",[NSString stringWithFormat:@"%d",transferStatus],@"transferStatus",[NSString stringWithFormat:@"%d",deleteStatus],@"deleteStatus",deleteDate,@"deleteDate",fileSize,@"fileSize",currentDuration1,@"currentDuration",[NSString stringWithFormat:@"%d",newDataUpdate],@"newDataUpdate",[NSString stringWithFormat:@"%d",newDataSend],@"newDataSend",[NSString stringWithFormat:@"%d",mobileDictationIdVal],@"mobileDictationIdVal",departmentName,@"departmentName",nil];
//        
//        [[Database shareddatabase] insertRecordingData:audioRecordDetailsDict];
//        
//    }
//    
//    
//}
//-(void)prepareAudioPlayer:(NSString*)filePath
//{
//   
//    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryAudioProcessing];
//    
//    NSData* audioData=[NSData dataWithContentsOfFile:filePath];
//    
//    NSError* error;
//    
//    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
//    
//    player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
//    
//    [player prepareToPlay];
//    
//    
//}

#pragma mark: tableView delegates adn datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* awaitingFileTransferDict;
    
    awaitingFileTransferDict=[[AppPreferences sharedAppPreferences].importedFilesAudioDetailsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* departmentNameLabel=[cell viewWithTag:101];
    
    UILabel* recordingDurationLabel=[cell viewWithTag:102];
    
    UILabel* nameLabel=[cell viewWithTag:103];
    
    UILabel* dateLabel=[cell viewWithTag:104];
    
    UILabel* timeLabel=[cell viewWithTag:105];
    
    UILabel* statusLabel=[cell viewWithTag:106];

    NSString* dateAndTimeString=[awaitingFileTransferDict valueForKey:@"RecordCreatedDate"];
    
    NSArray* dateAndTimeArray=[dateAndTimeString componentsSeparatedByString:@" "];
    
    //int audioMinutes= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]/60;
    
    //int audioSeconds= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]%60;
    
    departmentNameLabel.text=[[awaitingFileTransferDict valueForKey:@"RecordItemName"] stringByDeletingPathExtension];
    
    int audioHour= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]/(60*60);
    int audioHourByMod= [[awaitingFileTransferDict valueForKey:@"CurrentDuration"] intValue]%(60*60);
    
    int audioMinutes = audioHourByMod / 60;
    int audioSeconds = audioHourByMod % 60;
    
    recordingDurationLabel.text=[NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];

    //recordingDurationLabel.text=[NSString stringWithFormat:@"%02d:%02d",audioMinutes,audioSeconds];
    
    nameLabel.text=[awaitingFileTransferDict valueForKey:@"Department"];
    
    if ([[awaitingFileTransferDict valueForKey:@"TransferStatus"] isEqualToString:@"Transferred"] && !([[awaitingFileTransferDict valueForKey:@"DictationStatus"] isEqualToString:@"RecordingFileUpload"]))
    {
        statusLabel.textColor=[UIColor colorWithRed:49/255.0 green:85/255.0 blue:25/255.0 alpha:1.0];
    }
    else
    {
        statusLabel.textColor=[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1.0];
    }
    
    if ([[awaitingFileTransferDict valueForKey:@"DictationStatus"] isEqualToString:@"RecordingFileUpload"])
    {
        statusLabel.text=@"Uploading";
    }
    else
    {
        if ([[awaitingFileTransferDict valueForKey:@"TransferStatus"] isEqualToString:@"NotTransferred"])
        {
            statusLabel.text=@"Not Transferred";

        }
        else
        statusLabel.text=[awaitingFileTransferDict valueForKey:@"TransferStatus"];
    }
    
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
        
        timeLabel.text=[NSString stringWithFormat:@"%@",[dateAndTimeArray objectAtIndex:1]];
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary* awaitingFileTransferDict;
    UITableViewCell* cell= [tableview cellForRowAtIndexPath:indexPath];
    
    UILabel* deleteStatusLabel=[cell viewWithTag:106];
    
    if(([deleteStatusLabel.text isEqual:@"Uploading"]))
    {
        
        alertController = [UIAlertController alertControllerWithTitle:@"Alert?"
                                                              message:@"File is in use!"
                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        actionDelete = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                        {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }];
        
        [alertController addAction:actionDelete];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

    else
    {
        
        AudioDetailsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AudioDetailsViewController"];
    
        vc.selectedView=@"Imported";
        
        vc.selectedRow=indexPath.row;
        
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        if (self.splitViewController.isCollapsed)
        {
            
            [self presentViewController:vc animated:YES completion:nil];
        }
        else
        {
//            NSMutableArray* subVC = [[NSMutableArray alloc] initWithArray:[self.splitViewController viewControllers]];
            
//            [subVC addObject:vc];
            
//            [self.splitViewController setViewControllers:subVC];
//            [self.splitViewController addChildViewController:vc];
//            [self.splitViewController showDetailViewController:vc sender:self];
            [self.navigationController pushViewController:vc animated:true];
        }
        

    }
        
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
