//
//  RecordViewController.m
//  Ace
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
// tag view 200 series are of storyboard reference Views
// tag with 300 series are of programmatically created actual circle Views


// audio compression(DoConvert tuto) http://stackoverflow.com/questions/6576530/ios-how-to-use-extaudiofileconvert-sample-in-a-new-project

#import "RecordViewController.h"
#import "PopUpCustomView.h"
#import "DepartMent.h"
#import "SpeechRecognitionViewController.h"
#import <AVKit/AVKit.h>

#define IMPEDE_PLAYBACK NO
//extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);


@interface RecordViewController ()

@end


@implementation RecordViewController

@synthesize player, recordedAudioFileName, recorder,recordedAudioURL,recordCreatedDateString,hud,deleteButton,stopNewButton,stopNewImageView,stopLabel,recordLAbel, SpeechToTextView;


#pragma mark- View Delegate And Associate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewForViewDidLoad];
  
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_VRS_ENABLE] == YES) {
            [SpeechToTextView setHidden:NO];
        
       }else{
            [SpeechToTextView setHidden:YES];
           UILabel* recordingStatusLabel= [self.view viewWithTag:99];

           recordingStatusLabel.text = @"Tap on record to start recording your audio";
       }
  //AVAudioSessionPortBuiltInMic;
}

-(void)viewWillAppear:(BOOL)animated
{
   
    [AppPreferences sharedAppPreferences].isRecordView=YES;
    
   
    
    if (![APIManager sharedManager].userSettingsOpened)
    {
        
        if (isViewSetUpWhenFirstAppear == false)
        {
            [self setUpView];
            
            [self setRecordingAudioFileName];
            
            [self setTodaysDateAndDepartment];
            
            [self setMinutesValueToPauseRecord];
            
            self.navigationItem.title = @"Record";
            
            isViewSetUpWhenFirstAppear = true;
        }
        
        if (!IMPEDE_PLAYBACK)
        {
            [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
        }
  
    }
}

-(void)setUpView
{
    // start recording
    UIView* startRecordingView1 = [self.view viewWithTag:203];
    
    [self performSelector:@selector(addView:) withObject:startRecordingView1 afterDelay:0.02];
    
    cirecleTimerLAbel = [self.view viewWithTag:104];
    
    [cirecleTimerLAbel setHidden:YES];
    
    [stopNewButton setHidden:YES];
    
    [stopNewImageView setHidden:YES];
    
    [stopLabel setHidden:YES];
    
    circleViewTimerMinutes = 0;
    circleViewTimerSeconds = 0;
    dictationTimerSeconds = 0;
    recordingPauseAndExit = YES;
    stopped=YES;

    
}

-(void)setRecordingAudioFileName
{
    // To get a serial of filename to be record
    UILabel* fileNameLabel = [self.view viewWithTag:101];

    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* todaysDate = [dateFormatter stringFromDate:[NSDate new]];
    
    NSString* storedTodaysDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"TodaysDate"];
    
    if ([todaysDate isEqualToString:storedTodaysDate]) // for subsequent time in a day after first
    {
        todaysSerialNumberCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"todaysSerialNumberCount"] longLongValue];
        
        todaysSerialNumberCount++;  // get todays stored SerialNumberCount and increment it by 1
        
    }
    else // for first time in a day
    {
        [[NSUserDefaults standardUserDefaults] setValue:todaysDate forKey:@"TodaysDate"]; // set todays date
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"todaysSerialNumberCount"]; // set todays serial number to 0
        
        NSString* countString = [[NSUserDefaults standardUserDefaults] valueForKey:@"todaysSerialNumberCount"];
        
        todaysSerialNumberCount = [countString longLongValue];
        
        todaysSerialNumberCount++;  // for first recording in a day set todaysSerialNumberCount = 1
        
    }
    
    // get todays date for filename
    todaysDate = [todaysDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString* fileNamePrefix;
    
    fileNamePrefix = [[NSUserDefaults standardUserDefaults] valueForKey:@"FileNamePrefix"];
    
    // set recording audio filename
    self.recordedAudioFileName = [NSString stringWithFormat:@"%@%@-%02ld",fileNamePrefix,todaysDate,todaysSerialNumberCount];
    
    // set filename label text
    fileNameLabel.text = [NSString stringWithFormat:@"%@%@-%02ld",fileNamePrefix,todaysDate,todaysSerialNumberCount];
    
}

-(void)setTodaysDateAndDepartment
{
    // set department label text
    UILabel* transferredByLabel = [self.view viewWithTag:102];
    
    UILabel* dateLabel = [self.view viewWithTag:103];
    
//    DepartMent* deptObj2= [[Database shareddatabase] getDepartMentFromDepartmentName:@"Sanjay  Ubale"];
//    NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:deptObj2];
//    [[NSUserDefaults standardUserDefaults] setObject:data2 forKey:SELECTED_DEPARTMENT_NAME];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
    DepartMent* deptObj = [[DepartMent alloc] init];
    deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    transferredByLabel.text = deptObj.departmentName;
   
    existingDepartmentName = deptObj.departmentName;
   
    // set date label text
    NSString* dateAndTimeString = [app getDateAndTimeString];
    NSArray* dateAndTimeArray = [dateAndTimeString componentsSeparatedByString:@" "];
    NSString* dateString = [dateAndTimeArray objectAtIndex:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateStr = [NSString stringWithFormat:@"%@",dateString];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:date];
    
    dateLabel.text = newDateString;

    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
    
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:SELECTED_DEPARTMENT_NAME_COPY];


}

-(void)setMinutesValueToPauseRecord
{
    // get and set minutes value after which record should pause automatically
    NSString* dictationTimeString = [[NSUserDefaults standardUserDefaults] valueForKey:SAVE_DICTATION_WAITING_SETTING];
        
    NSArray* minutesAndValueArray = [dictationTimeString componentsSeparatedByString:@" "];
    
    if (minutesAndValueArray.count < 1)
    {
        return;
    }
    
    minutesValue = [[minutesAndValueArray objectAtIndex:0]intValue];
}

-(void)setViewForViewDidLoad
{
    app = [APIManager sharedManager];
    
    db = [Database shareddatabase];
    
    popupView = [[UIView alloc]init];
    
    forTableViewObj = [[PopUpCustomView alloc]init];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissPopView:)];
    
    tap.delegate = self;
    
    cirecleTimerLAbel=[[UILabel alloc]init];
    
    [[self.view viewWithTag:701] setHidden:YES];
    [[self.view viewWithTag:702] setHidden:YES];
    [[self.view viewWithTag:703] setHidden:YES];//edit button and image
    [[self.view viewWithTag:704] setHidden:YES];
    
    
    maxRecordingTimeString = [[NSUserDefaults standardUserDefaults] valueForKey:SAVE_DICTATION_WAITING_SETTING];
    
    recordingPausedOrStoped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseRecordingFromBackGround) name:NOTIFICATION_PAUSE_RECORDING
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideDeleteButton) name:NOTIFICATION_FILE_UPLOAD_API
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveRecordin) name:NOTIFICATION_SAVE_RECORDING
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pausePlayerFromBackGround) name:NOTIFICATION_PAUSE_AUDIO_PALYER
                                               object:nil];
    
    self.speechToTextCircleView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.speechToTextCircleView.layer.cornerRadius = 48;
    }
    if (!IMPEDE_PLAYBACK)
    {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayAndRecord];
    }
}

-(void)pausePlayerFromBackGround
{
    if (player.isPlaying)
    {
        UIView* startRecordingView= [self.view viewWithTag:303];
        //
        //        UILabel* recordingStatusLabel=[self.view viewWithTag:99];
        //
        UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
        
        startRecordingImageView.image = [UIImage imageNamed:@"Play"];
        
        [player pause];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    long freeDiskSpaceInMB= [[APIManager sharedManager] getFreeDiskspace];
    long storageThreshold = 0.0l;
    NSString* lowStorageThresholdString= [[NSUserDefaults standardUserDefaults] valueForKey:LOW_STORAGE_THRESHOLD];
    // NSString* lowStorageThresholdString= @"12 GB";
    
    if ([lowStorageThresholdString isEqualToString:@"512 MB"])
    {
        NSArray* thresholdArray= [lowStorageThresholdString componentsSeparatedByString:@" "];
        storageThreshold =[[thresholdArray objectAtIndex:0]longLongValue];
    }
    else
        if ([lowStorageThresholdString isEqualToString:@"1 GB"])
        {
            NSArray* thresholdArray= [lowStorageThresholdString componentsSeparatedByString:@" "];
            storageThreshold =[[thresholdArray objectAtIndex:0]longLongValue];
            storageThreshold=storageThreshold*1024ll;
        }
        else
            if ([lowStorageThresholdString isEqualToString:@"2 GB"])
            {
                NSArray* thresholdArray= [lowStorageThresholdString componentsSeparatedByString:@" "];
                storageThreshold =[[thresholdArray objectAtIndex:0]longLongValue];
                storageThreshold=storageThreshold*1024ll;
                
            }
            else
                if ([lowStorageThresholdString isEqualToString:@"3 GB"])
                {
                    NSArray* thresholdArray= [lowStorageThresholdString componentsSeparatedByString:@" "];
                    storageThreshold =[[thresholdArray objectAtIndex:0]longLongValue];
                    storageThreshold=storageThreshold*1024ll;
                }
    //                else
    //                    if ([lowStorageThresholdString isEqualToString:@"12 GB"])
    //                    {
    //                        NSArray* thresholdArray= [lowStorageThresholdString componentsSeparatedByString:@" "];
    //                        storageThreshold =[[thresholdArray objectAtIndex:0]longLongValue];
    //                        storageThreshold=storageThreshold*1024ll;
    //                    }
    
    if (freeDiskSpaceInMB<storageThreshold)
    {
        alertController = [UIAlertController alertControllerWithTitle:@"Low storage"
                                                              message:@"Please delete some data from your deivice"
                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        actionDelete = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                        {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                            
                            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                            
                        }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionDelete];
        
        
        actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction * action)
                        {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                            
                            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionCancel];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //NSLog(@"disk space=%ld",freeDiskSpaceInMB);
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [sliderTimer invalidate];
    
    [stopTimer invalidate];
    
    if( [APIManager sharedManager].userSettingsClosed)
    {
        [APIManager sharedManager].userSettingsOpened=NO;
    }
    if (![APIManager sharedManager].userSettingsOpened)
    {
        
    }
    
    if([AppPreferences sharedAppPreferences].recordNew)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"dismiss"];
        
    }
    
    
}

#pragma mark: Local Notification Methods

-(void)pauseRecordingFromBackGround
{
    if (!stopped && !paused)
    {
        
        UIImageView* animatedView= [self.view viewWithTag:1001];
        
        [animatedView stopAnimating];
        
        animatedView.image=[UIImage imageNamed:@"SoundWave-3"];
       
        [stopTimer invalidate];
        
        UIView* startRecordingView = [self.view viewWithTag:303];
        
        UIImageView* startRecordingImageView = [startRecordingView viewWithTag:403];
        
        [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
       
        dictationTimerSeconds=0;
        recordingPauseAndExit=YES;
        paused=YES;
        [recorder pause];
        UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
        
        recordOrPauseLabel.text = @"Resume";        /////
        
        
        if ( [startRecordingImageView.image isEqual:[UIImage imageNamed:@"PauseNew"]] &&  !recordingPausedOrStoped && edited)
        {
            
            [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
            
            recordingPausedOrStoped=YES;
            
            UIApplication*    appl = [UIApplication sharedApplication];
            
            task = [appl beginBackgroundTaskWithExpirationHandler:^{
                [appl endBackgroundTask:task];
                task = UIBackgroundTaskInvalid;
            }];
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                [self performSelectorOnMainThread:@selector(showHud) withObject:nil waitUntilDone:NO];
                
                [self composeAudio];
                
            [self updateDictationStatus:@"RecordingPause"];
//            });
            startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];
            
        }
        else
        {
            
            recordingPausedOrStoped=YES;
            
            startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];
            
            [self savePausedFileFromBG];
        }
      
    }
    
}


-(void)savePausedFileFromBG
{
    NSError* error;
    
    NSString* originalFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
    
   bool isCopied =  [[NSFileManager defaultManager] copyItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] toPath:originalFilePath error:&error];// save file for next time composition(i.e.1st file and 2nd will be editedCopy which we will record);
    
    [self saveAudioRecordToDatabase];
    
    edited = true;
    
    [self setCompressAudio];
}
-(void)saveRecordin  //save recording if user kill the app while recording
{
    //
    if ([AppPreferences sharedAppPreferences].isRecordView)
    {
        NSError* error;
        
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@editedCopy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error];
        
         [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error];
        
         [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error];
        
        if (!stopped)
        {
            [self updateDictationStatus:@"RecordingPause"];
        }

    }
}

-(void)updateDictationStatus:(NSString*)dictationStatus
{
    
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@.caf", self.recordedAudioFileName],
                               nil];
    self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
    
    [self prepareAudioPlayer];

    dispatch_async(dispatch_get_main_queue(), ^{
    
        [[Database shareddatabase] updateAudioFileName:self.recordedAudioFileName dictationStatus:dictationStatus];
        
        [db updateAudioFileName:recordedAudioFileName duration:player.duration];

    });

}
-(void)hideDeleteButton
{
    if ([[self.view viewWithTag:98] isDescendantOfView:self.view])//if animated view added then dont hide delete button
    {
        [[self.view viewWithTag:701] setHidden:NO];
        [[self.view viewWithTag:702] setHidden:NO];
        [[self.view viewWithTag:703] setHidden:NO];//edit button and image
        [[self.view viewWithTag:704] setHidden:NO];

    }
    else
    {
        [[self.view viewWithTag:703] setHidden:YES];//edit button and image
        [[self.view viewWithTag:704] setHidden:YES];
        [[self.view viewWithTag:701] setHidden:YES];
        [[self.view viewWithTag:702] setHidden:YES];
    }
    
}




#pragma mark: Dismiss Views
-(void)disMissPopView:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:504] removeFromSuperview];
    
}
-(void)dismissPopView:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
}
-(void)dismissView
{
    [player stop];
    
    [AppPreferences sharedAppPreferences].recordNewOffline = NO;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//addCircleViews
#pragma mark: Add custom CircleViews

-(void)addView:(UIView*)sender
{
    if (sender.tag==203)//Greater width for middle circle
    {
        double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
        
        if (screenHeight<481)
        {
            [self setRoundedView:sender toDiameter:sender.frame.size.width];
            
        }
        else
       // [self setRoundedView:sender toDiameter:sender.frame.size.width+20];
        [self setRoundedView:sender toDiameter:sender.frame.size.width+20];

    }
//    else
//        [self setRoundedView:sender toDiameter:sender.frame.size.width];
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    circleView=[[UIView alloc]init];
    
    CGRect newFrame;
    
    if (roundedView.tag==203)
    {
        double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
        
        if (screenHeight<481)
        {
            newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y-10, newSize, newSize);
            
        }
        else
        newFrame = CGRectMake(roundedView.frame.origin.x-10, roundedView.frame.origin.y-10, newSize, newSize);
        
    }
//    else
//        newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    
    circleView.frame = newFrame;
    circleView.layer.cornerRadius = newSize / 2.0;
    circleView.tag=roundedView.tag+100;
    
    UIButton* viewClickbutton=[[UIButton alloc]init];
    viewClickbutton.frame=CGRectMake(0, 0, newSize, newSize);//button:subview of view hence 0,0
    
    UIImageView* startStopPauseImageview=[[UIImageView alloc]init];
    
    //--------set Images within the circle,add respective viewClickbutton targets-------//
    
    if (roundedView.tag==201)
    {
//        startStopPauseImageview.image=[UIImage imageNamed:@"Stop"];
//
//        startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-15, (circleView.frame.size.height/2)-8, 15, 15);
//
//        circleView.backgroundColor=[UIColor grayColor];
//
//        [viewClickbutton addTarget:self action:@selector(setStopRecordingView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (roundedView.tag==202)
    {
//        startStopPauseImageview.image=[UIImage imageNamed:@"Play"];
//
//        startStopPauseImageview.frame=CGRectMake((newSize/2), (newSize/2)-8, 15, 15);
//
//        startStopPauseImageview.tag=roundedView.tag+200;
//
//        circleView.backgroundColor=[UIColor grayColor];
//
//        [viewClickbutton addTarget:self action:@selector(setPauseRecordingView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (roundedView.tag==203)
    {
        startStopPauseImageview.image=[UIImage imageNamed:@"Record"];
        
//        startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-15, (circleView.frame.size.height/2)-25, 30, 50);
//        startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-15, (circleView.frame.size.height/2)-25, 43, 69);
        startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-18, (circleView.frame.size.height/2)-29, 36, 58);

        startStopPauseImageview.tag=roundedView.tag+200;
        
//        circleView.layer.borderColor = [UIColor whiteColor].CGColor;
        
//        circleView.layer.borderWidth = 3.0f;
        
//        circleView.backgroundColor=[UIColor colorWithRed:194/255.0 green:19/255.0 blue:19/255.0 alpha:1]; // red color
        circleView.backgroundColor = [UIColor colorWithRed:91/255.0 green:131/255.0 blue:255/255.0 alpha:1];

        [viewClickbutton addTarget:self action:@selector(setStartRecordingView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
   
    [circleView addSubview:viewClickbutton];
    
    [circleView addSubview:startStopPauseImageview];
    
    [self.view addSubview:circleView];
    
   // [self.view addSubview:recordLabel];
}


-(void)setStartRecordingView:(UIButton*)sender
{
    
    UIView* startRecordingView= [self.view viewWithTag:303];
    
    if ([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1]] || [startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1]])
    {
        if ([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1]])
        {
            
            UIImageView* startRecordingImageView;
            
            startRecordingImageView  = [startRecordingView viewWithTag:403];
            
            if (!edited)// pause and resume for normal recording
            {
                if (!paused)
                {
                    recordingPausedOrStoped=YES;
                    
                    paused=YES;
                    
                    [recorder pause];
                    
                    UIImageView* animatedView= [self.view viewWithTag:1001];
                    
                    [animatedView stopAnimating];
                    
                    animatedView.image=[UIImage imageNamed:@"SoundWave-3"];
                    
                    [self pauseRecording];
                    
                    
                    UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
                    
                    recordOrPauseLabel.text = @"Resume";
                    
                    
                    [stopTimer invalidate];
                    
                    
                    
                    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
                    
                    startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];
                    
                    [UIApplication sharedApplication].idleTimerDisabled = NO;
                }
                else if ( isRecordingStarted==YES && paused)
                {
                    recordingPausedOrStoped=NO;
                    
                    paused=NO;
                    
                    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayAndRecord];
                    
                    UIImageView* animatedView= [self.view viewWithTag:1001];
                    
                    [animatedView startAnimating];
                    
                    
                    UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
                    
                    recordOrPauseLabel.text = @"Pause";
                    
                    
                    [self setTimer];
                    
                    [self performSelector:@selector(mdRecord) withObject:nil afterDelay:0.1];
                    
                    [UIApplication sharedApplication].idleTimerDisabled = YES;
                    
                    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-18, 18, 36)];
                    
                    startRecordingImageView.image=[UIImage imageNamed:@"PauseNew"];
                }
                

            }
            
            else // pause and resume for edited recording
            {
                if ( !paused)
                {
                    recordingPausedOrStoped=YES;
                    
                    paused=YES;
                    
                    UIImageView* animatedView= [self.view viewWithTag:1001];
                    
                    [animatedView stopAnimating];
                    
                    animatedView.image=[UIImage imageNamed:@"SoundWave-3"];
                    
                    [recorder stop];

                    [self showHud];
                    
                    [self pauseRecording];
                    
                    [self showHud];
                    
                    [self composeAudio];
                    
                    UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
                    
                    recordOrPauseLabel.text = @"Resume";
                    
                    [stopTimer invalidate];
                    
                    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
                    
                    startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];
                    
                    [UIApplication sharedApplication].idleTimerDisabled = NO;
                }
                else if ( isRecordingStarted==YES && paused)
                {
                    recordingPausedOrStoped=NO;
                    
                    paused=NO;
                    
                    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayAndRecord];
                    
                    UIImageView* animatedView= [self.view viewWithTag:1001];
                    
                    [animatedView startAnimating];
                    
                    
                    UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
                    
                    recordOrPauseLabel.text = @"Pause";
                    
                    
                    [self setTimer];
                    
                    [self editRecord];
                    
                    [self mdRecord];
                    
                    [UIApplication sharedApplication].idleTimerDisabled = YES;
                    
                    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-18, 18, 36)];
                    
                    startRecordingImageView.image=[UIImage imageNamed:@"PauseNew"];
                }
                

            }
            
            
        }
        else
        {
            UIImageView* startRecordingImageView;
            
            startRecordingImageView  = [startRecordingView viewWithTag:403];
            startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1];
            
            
            [startRecordingImageView setHidden:NO];
            
            [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-9, 18, 18)];
            
            if([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1]])
            {
                [UIApplication sharedApplication].idleTimerDisabled = NO;
                if ([startRecordingImageView.image isEqual:[UIImage imageNamed:@"Play"]] || !player.isPlaying)
                {
                    
                    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(keepUpdatingSliderTimeWhileAudioPlaying:) userInfo:nil repeats:YES];
                    
                    [self prepareAudioPlayer];
                    
                    [self playRecording];
                    
                    [[self.view viewWithTag:701] setHidden:YES];//edit button and image
                    
                    [[self.view viewWithTag:702] setHidden:YES];
                    
                    [[self.view viewWithTag:703] setHidden:YES];//edit button and image
                    
                    [[self.view viewWithTag:704] setHidden:YES];
                    
                    
                    startRecordingImageView.image=[UIImage imageNamed:@"Pause"];
                    
                }
                //if image is pause then pause recording
                else
                {
                     [sliderTimer invalidate];
                    
                    [player pause];
                    
                    [stopTimer invalidate];
                    
                    [[self.view viewWithTag:701] setHidden:NO];//edit button and image
                    
                    [[self.view viewWithTag:702] setHidden:NO];
                    
                    [[self.view viewWithTag:703] setHidden:NO];//edit button and image
                    
                    [[self.view viewWithTag:704] setHidden:NO];
                    
                    
                    startRecordingImageView.image=[UIImage imageNamed:@"Play"];
                }
                //*-------------------for animated flipFromBottom subView---------------------*
            }
            //*-------------------for animated flipFromBottom subView---------------------*
        }
    }
    
    if ([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:91/255.0 green:131/255.0 blue:255/255.0 alpha:1]])
    {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:ALERT_BEFORE_RECORDING])
        {
            
            
            
            [self checkPermissionAndStartRecording];
            
        }
        else
        {
            alertController = [UIAlertController alertControllerWithTitle:@""
                                                                  message:@"Do you want to start recording?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
            
            actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                                
                                
                                [self checkPermissionAndStartRecording];
                                
                            }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionDelete];
            
            
            actionCancel = [UIAlertAction actionWithTitle:@"No"
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * action)
                            {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                
                            }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionCancel];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        
        
    }
}



-(void)setStopRecordingView:(UIButton*)sender
{
    
    if (edited && !paused)  // if not edited && not paused, hence file has not been composed hence we need to compose it. i
    {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:CONFIRM_BEFORE_SAVING_SETTING] || recordingRestrictionLimitCrossed)
        {
            [recorder stop];
            
            [stopTimer invalidate];
            
            [self hideViewForStopRecording];
            
            [self composeAudio];
            
            [self updateDictationStatus:@"RecordingComplete"];
            
            recordingRestrictionLimitCrossed = false;
        }
        else
        {
            alertController = [UIAlertController alertControllerWithTitle:@""
                                                                  message:@"Do you want to stop recording?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
            
            actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                                [recorder stop];
                                
                                [stopTimer invalidate];
                                
                                [UIApplication sharedApplication].idleTimerDisabled = NO;
                                
                                dispatch_async(dispatch_get_main_queue(), ^
                                               {
                                                   [self hideViewForStopRecording];

                                               });
                                
                                [self composeAudio];
                                
                                [self updateDictationStatus:@"RecordingComplete"];

                            }];
            
            [alertController addAction:actionDelete];
            
            
            actionCancel = [UIAlertAction actionWithTitle:@"No"
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * action)
                            {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            
            [alertController addAction:actionCancel];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }

    }
    else
    {
        [self stopUneditedRecording];

       

    }
    

    
//    updatedInsertionTime = 0;
    
    
}

-(void)hideViewForStopRecording
{
    
    UIImageView* animatedImageView= [self.view viewWithTag:1001];
    
    UIView* startRecordingView= [self.view viewWithTag:303];
    
    UIView* stopRecordingView = [self.view viewWithTag:301];
    
    UIView* pauseRecordingView =  [self.view viewWithTag:302];
    
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
    
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    
    UILabel* RecordingLabel=[self.view viewWithTag:603];
    
    UILabel* recordingStatusLabel = [self.view viewWithTag:100];

    [recordingStatusLabel setHidden:YES];
    
    [animatedImageView stopAnimating];
    
    animatedImageView.image=[UIImage imageNamed:@"SoundWave-3"];
    
    [animatedImageView setHidden:YES];
    
    [self showHud];
    
    [stopRecordingView setHidden:YES];
    
    [pauseRecordingView setHidden:YES];
    
    recordingPausedOrStoped=YES;
    
    isRecordingStarted=NO;
    
    [stopRecordingView setHidden:YES];
    
    [pauseRecordingView setHidden:YES];
    
    [stopRecordingLabel setHidden:YES];
    
    [pauseRecordingLabel setHidden:YES];
    
    [RecordingLabel setHidden:YES];
    
    [stopNewImageView setHidden:YES];
    
    [stopNewButton setHidden:YES];
    
    [stopLabel setHidden:YES];
    
    startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1];
    
    UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
    
    [startRecordingImageView setHidden:NO];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-9, 18, 18)];
    
    startRecordingImageView.image = [UIImage imageNamed:@"Play"];
    
    [[self.view viewWithTag:701] setHidden:NO];
    
    [[self.view viewWithTag:702] setHidden:NO];
    
    [[self.view viewWithTag:703] setHidden:NO];//edit button and image
    
    [[self.view viewWithTag:704] setHidden:NO];
    
    [stopTimer invalidate];
    
    [cirecleTimerLAbel setHidden:YES];
    
    double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight<481)
    {
        circleView.frame = CGRectMake(circleView.frame.origin.x, circleView.frame.origin.y-20, circleView.frame.size.width, circleView.frame.size.height);
    }
}

-(void)showAudioTimeDuration
{

    if (edited)
    {
        NSArray* pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   AUDIO_FILES_FOLDER_NAME,
                                   [NSString stringWithFormat:@"%@.caf", self.recordedAudioFileName],
                                   nil];
        self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
    }
    
    [self prepareAudioPlayer];
    
    int currentTime= player.duration;
    int minutes=currentTime/60;
    int seconds=currentTime%60;
//    dispatch_async(dispatch_get_main_queue(), ^
//                   {
                       totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
                       currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
                       audioRecordSlider.value= player.duration;
                       currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
 //                  });
    
}
-(void)stopUneditedRecording
{
  
    UIView* startRecordingView =  [self.view viewWithTag:303];
    
    if ([startRecordingView.backgroundColor isEqual:[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1]])
    {
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:CONFIRM_BEFORE_SAVING_SETTING] || recordingRestrictionLimitCrossed)
        {

//            [self updateDictationStatus:@"RecordingComplete"];
            
            [recorder stop];
            
            [self hideViewForStopRecording];
            
            [self stopRecording];
            
            [self addAnimatedView];
            
            [self showAudioTimeDuration];
            
            recordingRestrictionLimitCrossed = false;
            
            [self updateDictationStatus:@"RecordingComplete"];

            playerDurationWithMilliSeconds = player.duration;
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:BACK_TO_HOME_AFTER_DICTATION])
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
        }
        
        else
        {
            alertController = [UIAlertController alertControllerWithTitle:@""
                                                                  message:@"Do you want to stop recording?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
            
            actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                               
                                [recorder stop];

                                [self hideViewForStopRecording];

                                [self stopRecording];
                                
                                [self addAnimatedView];
                                
                                [self showAudioTimeDuration];
                                
                                [self updateDictationStatus:@"RecordingComplete"];

                                playerDurationWithMilliSeconds = player.duration;
                
                                if ([[NSUserDefaults standardUserDefaults] boolForKey:BACK_TO_HOME_AFTER_DICTATION])
                                {
                                    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }
                                
                            }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionDelete];
            
            
            actionCancel = [UIAlertAction actionWithTitle:@"No"
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * action)
                            {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                
                            }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
        }
        
        
    }
    
    

    NSLog(@"");
}

-(void)stopEditedRecording
{
    
    UIView* startRecordingView =  [self.view viewWithTag:303];
    
    UIImageView* animatedImageView= [self.view viewWithTag:1001];
    
    UIView* stopRecordingView = [self.view viewWithTag:301];
    
    UIView* pauseRecordingView =  [self.view viewWithTag:302];
    
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
    
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    
    UILabel* RecordingLabel=[self.view viewWithTag:603];
    
    [animatedImageView stopAnimating];
    
    [animatedImageView setHidden:YES];
    
    animatedImageView.image=[UIImage imageNamed:@"SoundWave-3"];
    
    [stopRecordingView setHidden:YES];
    
    [pauseRecordingView setHidden:YES];
    
    recordingPausedOrStoped=YES;
    isRecordingStarted=NO;
    
    [stopRecordingView setHidden:YES];
    
    [pauseRecordingView setHidden:YES];
    
    [stopRecordingLabel setHidden:YES];
    
    [pauseRecordingLabel setHidden:YES];
    
    [RecordingLabel setHidden:YES];
    
    [stopNewImageView setHidden:YES];
    
    [stopNewButton setHidden:YES];
    
    [stopLabel setHidden:YES];
    
    
    startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1];
    
    UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
    
    [startRecordingImageView setHidden:NO];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-9, 18, 18)];
    
    startRecordingImageView.image=[UIImage imageNamed:@"Play"];
    
    [[self.view viewWithTag:701] setHidden:NO];
    
    [[self.view viewWithTag:702] setHidden:NO];
    
    [[self.view viewWithTag:703] setHidden:NO];//edit button and image
    [[self.view viewWithTag:704] setHidden:NO];
    
    
    [stopTimer invalidate];
    
    [cirecleTimerLAbel setHidden:YES];
    
    // edited = NO;
    
    [self stopRecording];
    
    double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight<481)
    {
        
        circleView.frame = CGRectMake(circleView.frame.origin.x, circleView.frame.origin.y-20, circleView.frame.size.width, circleView.frame.size.height);
    }
    
    
    [self addAnimatedView];
    
    if (edited)
    {
        NSArray* pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   AUDIO_FILES_FOLDER_NAME,
                                   [NSString stringWithFormat:@"%@.caf", self.recordedAudioFileName],
                                   nil];
        self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
    }
    
    [self prepareAudioPlayer];
    
    int currentTime= player.duration;
    int minutes=currentTime/60;
    int seconds=currentTime%60;
    //            dispatch_async(dispatch_get_main_queue(), ^
    //                           {
    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    audioRecordSlider.value= player.duration;
    currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    //});
    
    
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:BACK_TO_HOME_AFTER_DICTATION])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    playerDurationWithMilliSeconds = player.duration;
    
    
    //  }
    
}


#pragma mark: Progress Hud Methods

-(void)showHud
{
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    [hud hideAnimated:NO];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.label.text = @"Saving audio...";
    
    hud.detailsLabel.text = @"Please wait";
    
    
}

-(void)hideHud
{
    [hud hideAnimated:YES];

}

#pragma mark: Recorder preparation and Start methods

- (void) mdRecord
{
    [recorder record];
    
}


-(void) checkPermissionAndStartRecording
{
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    
    switch (permissionStatus) {
        case AVAudioSessionRecordPermissionUndetermined:{
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                // CALL YOUR METHOD HERE - as this assumes being called only once from user interacting with permission alert!
                if (granted)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self startRecordingForUserSetting];
                        
                    });
                    // Microphone enabled code
                }
                else
                {
                    [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Microphone Access Denied" withMessage:@"You must allow microphone access in Settings > Privacy > Microphone" withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
                    // Microphone disabled code
                }
            }];
            break;
        }
        case AVAudioSessionRecordPermissionDenied:
            // direct to settings...
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Microphone Access Denied" withMessage:@"You must allow microphone access in Settings > Privacy > Microphone" withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
            
            break;
        case AVAudioSessionRecordPermissionGranted:
            // mic access ok...
            [self startRecordingForUserSetting];
            
            break;
        default:
            // this should not happen.. maybe throw an exception.
            break;
    }
    
    
}

-(void)startRecordingForUserSetting
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    UIView* startRecordingView= [self.view viewWithTag:303];
    
    UILabel* recordingStatusLabel= [self.view viewWithTag:99];
    
    UILabel* startLabel = [self.view viewWithTag:603];
    
    startLabel.text = @"Pause";
    
    //startLabel.textColor = [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1];
    
    startRecordingView.backgroundColor = [UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1];

    UIImageView* startRecordingImageView;
    
    stopped=NO;
    
    [stopNewButton setHidden:NO];
    
    [stopNewImageView setHidden:NO];
    
    [stopLabel setHidden:NO];

    [cirecleTimerLAbel setHidden:NO];
   
    [SpeechToTextView setHidden:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",todaysSerialNumberCount] forKey:@"todaysSerialNumberCount"];
    
    [self audioRecord];
  
    recordingStatusLabel.text=@"Your audio is being recorded";
   
    double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    UIImageView* animatedImageView;
    if (screenHeight<481)
    {
        animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x-10, stopNewImageView.frame.origin.y + stopNewImageView.frame.size.height + 30, recordingStatusLabel.frame.size.width+20, 15)];
    }
    else
    animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x-10, stopNewImageView.frame.origin.y + stopNewImageView.frame.size.height + 40, recordingStatusLabel.frame.size.width+20, 30)];

     UILabel* updatedrecordingStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x, animatedImageView.frame.origin.y + animatedImageView.frame.size.height + 10, recordingStatusLabel.frame.size.width, 30)];
    
    updatedrecordingStatusLabel.tag = 100;
    
    updatedrecordingStatusLabel.text=@"Your audio is being recorded";
    
    updatedrecordingStatusLabel.textColor = [UIColor lightGrayColor];
    
    updatedrecordingStatusLabel.textAlignment = NSTextAlignmentCenter;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {//for ipad
        updatedrecordingStatusLabel.font = [UIFont systemFontOfSize:23];
        
        animatedImageView.frame = CGRectMake(recordingStatusLabel.frame.origin.x-10, stopNewImageView.frame.origin.y + stopNewImageView.frame.size.height + 100, recordingStatusLabel.frame.size.width+20, 60);

        updatedrecordingStatusLabel.frame = CGRectMake(recordingStatusLabel.frame.origin.x, animatedImageView.frame.origin.y + animatedImageView.frame.size.height + 10, recordingStatusLabel.frame.size.width, 30);
    }
    else
    {
        updatedrecordingStatusLabel.font = [UIFont systemFontOfSize:18];

    }
    
    [updatedrecordingStatusLabel setHidden:NO];
    
    [recordingStatusLabel setHidden:YES];
    
    
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"SoundWave-1"],
                                         [UIImage imageNamed:@"SoundWave-2"],
                                         [UIImage imageNamed:@"SoundWave-3"],
                                          nil];

    animatedImageView.animationDuration = 1.0f;
    
    animatedImageView.animationRepeatCount = 0;
    
    [animatedImageView startAnimating];
    
    animatedImageView.userInteractionEnabled=YES;
    
    animatedImageView.tag=1001;
    
    [self.view addSubview:updatedrecordingStatusLabel];
    
    [self.view addSubview: animatedImageView];
    
    cirecleTimerLAbel = [self.view viewWithTag:104];
    
    cirecleTimerLAbel.textAlignment=NSTextAlignmentCenter;
    
    cirecleTimerLAbel.text=[NSString stringWithFormat:@"%02d:%02d:%02d",00,00,00];
    
    isRecordingStarted=YES;
    
    recordingPausedOrStoped = NO;
    
    paused=NO;
    
    startRecordingImageView= [startRecordingView viewWithTag:403];
    
    startRecordingImageView.image=[UIImage imageNamed:@"PauseNew"];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-18, 18, 36)];
   
    [self startRecorderAfterPrepared];
   
}

-(void)startRecorderAfterPrepared
{

    [self setTimer];
    
    [recorder record];

}

#pragma mark: Animated View Methods

-(void)addAnimatedView
{
    
    UIView* animatedView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/2)];
    animatedView.tag=98;
    
    audioRecordSlider=[[UISlider alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.14,animatedView.frame.size.height*0.01 , animatedView.frame.size.width*0.7, 30)];
    [audioRecordSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    //audioRecordSlider.minimumValue = 0.0;
    audioRecordSlider.continuous = YES;
    audioRecordSlider.maximumValue=player.duration;
    
    //float currentTimeFloat=player.duration;
    int currentTime= player.duration;
    int minutes=currentTime/60;
    int seconds=currentTime%60;
   
    UIButton* uploadAudioButton=[[UIButton alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.1, animatedView.frame.size.height*0.2, animatedView.frame.size.width*0.8, 36)];
    uploadAudioButton.backgroundColor=[UIColor colorWithRed:91/255.0 green:131/255.0 blue:255/255.0 alpha:1];
    uploadAudioButton.userInteractionEnabled=YES;
    [uploadAudioButton setTitle:@"Upload Recording" forState:UIControlStateNormal];
    uploadAudioButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    
    [uploadAudioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadAudioButton.layer.cornerRadius=5.0f;
    [uploadAudioButton addTarget:self action:@selector(uploadAudio:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton* uploadLaterButton=[[UIButton alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.1, uploadAudioButton.frame.origin.y+uploadAudioButton.frame.size.height+10, uploadAudioButton.frame.size.width*0.48, 36)];
    uploadLaterButton.backgroundColor=[UIColor colorWithRed:144/255.0 green:169/255.0 blue:255/255.0 alpha:1];
    [uploadLaterButton setTitle:@"Upload Later" forState:UIControlStateNormal];
    uploadLaterButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    [uploadLaterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadLaterButton.layer.cornerRadius=5.0f;
    [uploadLaterButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* recordNewButton=[[UIButton alloc]initWithFrame:CGRectMake(uploadLaterButton.frame.origin.x+uploadLaterButton.frame.size.width+uploadAudioButton.frame.size.width*0.04, uploadAudioButton.frame.origin.y+uploadAudioButton.frame.size.height+10, uploadAudioButton.frame.size.width*0.48, 36)];
    recordNewButton.backgroundColor=[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    [recordNewButton setTitle:@"Record New" forState:UIControlStateNormal];
    recordNewButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    [recordNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recordNewButton.layer.cornerRadius=5.0f;
    [recordNewButton addTarget:self action:@selector(presentRecordView) forControlEvents:UIControlEventTouchUpInside];
 
    currentDuration=[[UILabel alloc]initWithFrame:CGRectMake(uploadAudioButton.frame.origin.x, animatedView.frame.size.height*0.1, 80, 20)];
    totalDuration=[[UILabel alloc]initWithFrame:CGRectMake(uploadAudioButton.frame.origin.x+uploadAudioButton.frame.size.width-80, animatedView.frame.size.height*0.1, 80, 20)];
    currentDuration.textAlignment=NSTextAlignmentLeft;
    totalDuration.textAlignment=NSTextAlignmentRight;
    
    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    
    currentDuration.textColor = [UIColor blackColor];
    totalDuration.textColor = [UIColor blackColor];
//    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {//for ipad
        
        uploadAudioButton.frame = CGRectMake(animatedView.frame.size.width*0.2, animatedView.frame.size.height*0.2, animatedView.frame.size.width*0.6, 48);
        
        uploadLaterButton.frame = CGRectMake(animatedView.frame.size.width*0.2, uploadAudioButton.frame.origin.y+uploadAudioButton.frame.size.height+10, uploadAudioButton.frame.size.width*0.48, 48);
        
        recordNewButton.frame = CGRectMake(uploadLaterButton.frame.origin.x+uploadLaterButton.frame.size.width+uploadAudioButton.frame.size.width*0.04, uploadAudioButton.frame.origin.y+uploadAudioButton.frame.size.height+10, uploadAudioButton.frame.size.width*0.48, 48);
        
        uploadAudioButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        
        uploadLaterButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];

        recordNewButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];


    }

    if (minutes>99)//foe more than 99 min show time in 3 digits
    {
        totalDuration.text=[NSString stringWithFormat:@"%03d:%02d",minutes,seconds];//for slider label time label
        
    }

    [animatedView addSubview:audioRecordSlider];
    [animatedView addSubview:uploadAudioButton];
    [animatedView addSubview:uploadLaterButton];
    [animatedView addSubview:recordNewButton];
    [animatedView addSubview:currentDuration];
    [animatedView addSubview:totalDuration];
    
    animatedView.backgroundColor=[UIColor whiteColor];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         animatedView.frame = CGRectMake(0, self.view.frame.size.height*0.6, self.view.frame.size.width, self.view.frame.size.height/2);
                     }
                     completion:^(BOOL finished)
    {
                     }];
    [self.view addSubview:animatedView];
   
}



-(void)presentRecordView
{
    recordingNew=YES;
    if ([AppPreferences sharedAppPreferences].selectedTabBarIndex==3)
    {
            [AppPreferences sharedAppPreferences].recordNew=YES;

    }
    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"dismiss"];

    [AppPreferences sharedAppPreferences].recordNewOffline = YES;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"] animated:NO completion:nil];
    
}


-(void)uploadAudio:(UIButton*)sender
{
   if([AppPreferences sharedAppPreferences].userObj != nil)
    {
        if ([[AppPreferences sharedAppPreferences] isReachable])
        {
            alertController = [UIAlertController alertControllerWithTitle:TRANSFER_MESSAGE
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
            actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                                
                                //                        NSDictionary* audiorecordDict= [app.awaitingFileTransferNamesArray objectAtIndex:self.selectedRow];
                                //                        NSString* filName=[audiorecordDict valueForKey:@"RecordItemName"];
                                //                        [transferDictationButton setHidden:YES];
                                //                        [deleteDictationButton setHidden:YES];
                                [player stop];
                                [[self.view viewWithTag:701] setHidden:YES];//delete button and image
                                [[self.view viewWithTag:702] setHidden:YES];
                                [[self.view viewWithTag:703] setHidden:YES];//edit button and image
                                [[self.view viewWithTag:704] setHidden:YES];
                                [[Database shareddatabase] updateAudioFileStatus:@"RecordingFileUpload" fileName:self.recordedAudioFileName];
               
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    
                                    
                                    [app uploadFileToServer:self.recordedAudioFileName jobName:FILE_UPLOAD_API];
                                    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
                                   
                                    dispatch_async(dispatch_get_main_queue(), ^
                                                   {
                                                       sender.userInteractionEnabled=NO;
                                                       deleteButton.userInteractionEnabled=NO;
                                                       recordingNew=NO;
                                                        [AppPreferences sharedAppPreferences].recordNewOffline = NO;
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                   });
                                    
                                    
                                    
                                    
                                });
                                
                            }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionDelete];
            
            
            actionCancel = [UIAlertAction actionWithTitle:@"No"
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * action)
                            {
                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                
                            }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your internet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Login Required!" withMessage:@"Please login to upload the recording." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

#pragma mark: Timer methods

-(void)setTimer
{
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(updateTimer)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)setMilliSecnodsTimer
{
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(updateMilliSecondsTimer)
                                               userInfo:nil
                                                repeats:YES];
}

//-(void)updateMilliSecondsTimer
//{
//    milliSeconds = milliSeconds + 0.1;
//}

-(void)updateTimer
{
    //for dictation waiting by
    if (recorder.isRecording)
    {
        //NSLog(@"recording");

    }
    else
    {
        //NSLog(@"Not recording");

    }
    ++dictationTimerSeconds;
    //++totalSecondsOfAudio;
    
    if ((recorder.currentTime + player.duration) > RECORDING_LIMIT)
    {
        recordingRestrictionLimitCrossed = true;
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:RECORDING_SAVED_MESSAGE withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
         [self setStopRecordingView:nil];
        
         return;
    }

    if (dictationTimerSeconds==(60*minutesValue-1))
    {
        recordingPausedOrStoped=YES;
        
        UIImageView* animatedView= [self.view viewWithTag:1001];
        
        [animatedView stopAnimating];
        
        animatedView.image=[UIImage imageNamed:@"SoundWave-3"];
        
        UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
        
        recordOrPauseLabel.text = @"Resume";
        
        paused=YES;
        
        [self pauseRecording];
        
        if (edited)
        {
            [recorder stop];
            
            [self showHud];
            
            [self composeAudio];
        }
     //   [UIApplication sharedApplication].idleTimerDisabled = NO;

    }
//    [UIApplication sharedApplication].idleTimerDisabled = YES;
    if(![self.view viewWithTag:701].hidden && recorder.isRecording)
    {
    [[self.view viewWithTag:701] setHidden:YES];
    [[self.view viewWithTag:702] setHidden:YES];
        [[self.view viewWithTag:703] setHidden:YES];//edit button and image
        [[self.view viewWithTag:704] setHidden:YES];

    }
    //------------------------
    ++circleViewTimerSeconds;
    if (circleViewTimerSeconds==60)
    {
        circleViewTimerSeconds=0;
        ++circleViewTimerMinutes;
    }
    if (circleViewTimerMinutes==60)
    {
        circleViewTimerSeconds=0;
        circleViewTimerMinutes=0;
        ++circleViewTimerHours;
    }
   
//    int totalTime= recorder.currentTime + player.duration;
//    int audioHour= (recorder.currentTime + player.duration)/(60*60);
//    int audioHourByMod = totalTime % (60*60);
//
//    int audioMinutes = audioHourByMod / 60;
//    int audioSeconds = audioHourByMod % 60;
    cirecleTimerLAbel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",circleViewTimerHours,circleViewTimerMinutes,circleViewTimerSeconds];//for circleView timer label
    
    //cirecleTimerLAbel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];//for circleView timer label
}


#pragma mark:AudioSlider actions

-(void)sliderValueChanged
{
    player.currentTime = audioRecordSlider.value;
    
    if (audioRecordSlider.value > 0.1) {
        playerDurationWithMilliSeconds = audioRecordSlider.value - 0.03;// to adjust accuracy and file compose failure;
    }else{
        playerDurationWithMilliSeconds = audioRecordSlider.value;
    }
    
    int currentTime=audioRecordSlider.value;
    int minutes = currentTime/60;
    int seconds = currentTime%60;
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
        //NSLog(@"Reachable");
        currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
        
        if (minutes>99)//foe more than 99 min show time in 3 digits
        {
            currentDuration.text=[NSString stringWithFormat:@"%03d:%02d",minutes,seconds];//for slider label time label
            
        }
    });
    

    float sliderCurrentTimeDown = floorf(audioRecordSlider.value * 100) / 100;
    
    float playerCurrentTimeDown = floorf(player.duration * 100) / 100;

    if (sliderCurrentTimeDown == playerCurrentTimeDown)
    {
        [player stop];
        
        [self audioPlayerDidFinishPlaying:player successfully:true];
    }
}
-(void)sliderValueChanged:(id)sender
{
    player.currentTime = audioRecordSlider.value;
    
    
}
-(void)keepUpdatingSliderTimeWhileAudioPlaying:(UISlider*)sender
{
    playerDurationWithMilliSeconds = player.currentTime;
    
//    NSLog(@"player current time = %f", player.currentTime);
    audioRecordSlider.value = player.currentTime;
    int currentTime=player.currentTime;
    int minutes=currentTime/60;
    int seconds=currentTime%60;
    currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label

    if (minutes>99)//foe more than 99 min show time in 3 digits
    {
        currentDuration.text=[NSString stringWithFormat:@"%03d:%02d",minutes,seconds];//for slider label time label

    }
  
}


#pragma mark:Navigation bar items actions

- (IBAction)backButtonPressed:(id)sender
{
    if (!recordingPausedOrStoped)
    {
        alertController = [UIAlertController alertControllerWithTitle:PAUSE_STOP_MESSAGE
                                                              message:@""
                                                       preferredStyle:UIAlertControllerStyleAlert];
        actionDelete = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                        {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                            
                        }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionDelete];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    if (recordingPauseAndExit && !stopped)
    {
        
       
        [self saveAudioRecordToDatabase];


        NSString* destinationPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
        NSError* error1;
         [[NSFileManager defaultManager] moveItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] toPath:destinationPath error:&error1];
        
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error1];
        
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@editedCopy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error1];
        
      
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
        
        [AppPreferences sharedAppPreferences].recordNewOffline = NO;
        
        [sliderTimer invalidate];
        
        [player stop];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];

        dispatch_async(dispatch_get_main_queue(), ^{

            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
        


    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];

        [AppPreferences sharedAppPreferences].recordNewOffline = NO;

        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];
        
        UIView* animatedView=  [self.view viewWithTag:98];

        [animatedView removeFromSuperview];
        
        [sliderTimer invalidate];

        [player stop];
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}

- (IBAction)moreButtonPressed:(id)sender
{
    if ([[self.view viewWithTag:98] isDescendantOfView:self.view])
    {
        if ([AppPreferences sharedAppPreferences].userObj != nil)
        {
            NSArray* subViewArray=[NSArray arrayWithObjects:@"User Settings", nil];
            editPopUp=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, self.view.frame.origin.y+40, 160, 40) andSubViews:subViewArray :self];
            [[[UIApplication sharedApplication] keyWindow] addSubview:editPopUp];
        }
        else
        {
            NSArray* subViewArray=[NSArray arrayWithObjects:@"Change Department", nil];
            editPopUp=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, self.view.frame.origin.y+40, 160, 40) andSubViews:subViewArray :self];
            // editPopUp.tag=888;
            [[[UIApplication sharedApplication] keyWindow] addSubview:editPopUp];
        }
       
    }
    else
    {
      NSArray* subViewArray=[NSArray arrayWithObjects:@"Change Department", nil];
      editPopUp=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, self.view.frame.origin.y+40, 160, 40) andSubViews:subViewArray :self];
       // editPopUp.tag=888;
      [[[UIApplication sharedApplication] keyWindow] addSubview:editPopUp];
    }
}
-(void)UserSettings
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    [APIManager sharedManager].userSettingsOpened=YES;
    [APIManager sharedManager].userSettingsClosed=NO;
      UIViewController* vc = [self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"];
      vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:true completion:nil];
}


-(void)ChangeDepartment
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    CGRect frame=CGRectMake(10.0f, self.view.center.y-150, self.view.frame.size.width - 20.0f, 200.0f);
    UITableView* tab= [forTableViewObj tableView:self frame:frame];
    [popupView addSubview:tab];
    //[popupView addGestureRecognizer:tap];
    [popupView setFrame:[[UIScreen mainScreen] bounds]];
    //[popupView addSubview:[self.view viewWithTag:504]];
    UIView *buttonsBkView = [[UIView alloc] initWithFrame:CGRectMake(tab.frame.origin.x, tab.frame.origin.y + tab.frame.size.height, tab.frame.size.width, 70.0f)];
    buttonsBkView.backgroundColor = [UIColor whiteColor];
    [popupView addSubview:buttonsBkView];
    
    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-200, 20.0f, 80, 30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* saveButton=[[UIButton alloc]initWithFrame:CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+16, 20.0f, 80, 30)];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[saveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
   
    [buttonsBkView addSubview:cancelButton];
    [buttonsBkView addSubview:saveButton];


    popupView.tag=504;
    [popupView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:popupView];
    
}


#pragma mark:Gesture recogniser delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (editPopUp.superview != nil)
    {
     if (![touch.view isEqual:editPopUp])
     {
         return NO;
     }
     
     return YES;
    }
    if (![touch.view isEqual:popupView])
    {
        return NO;
    }
    
    return YES; // handle the touch
}

#pragma mark:Audio recorder and player custom and delegtaes methods

-(void)audioRecord
{
    //[recorder recordForDuration:10];
    
    if (!IMPEDE_PLAYBACK)
    {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
    }
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@copy.caf", self.recordedAudioFileName],
                 
                               nil];
    NSString* backUpPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:backUpPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:backUpPath error:nil];
    }
    self.recordedAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // settings for the recorder
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];//kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];//8000

    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    
    // initiate recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:self.recordedAudioURL settings:recordSetting error:&error];
   [recorder prepareToRecord];
    
}

-(void)editRecord
{
    // [recorder recordForDuration:60];
    
    if (!IMPEDE_PLAYBACK)
    {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
    }
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
  [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@editedCopy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:nil];
    
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@editedCopy.caf", self.recordedAudioFileName],
                               
                               nil];
    NSString* backUpPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@editedCopy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:backUpPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:backUpPath error:nil];
    }
    self.recordedAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // settings for the recorder
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];//kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];//8000
    
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    
    // initiate recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:self.recordedAudioURL settings:recordSetting error:&error];
    [recorder prepareToRecord];
    
    
}


-(void)pauseRecording
{
    //for dictation waiting by setting
//    UIView* pauseView=  [self.view viewWithTag:302];
//    UIImageView* pauseImageView= [pauseView viewWithTag:402];
    [stopTimer invalidate];
   
 //    pauseImageView.image=[UIImage imageNamed:@"Play"];
   
    UIView* startRecordingView = [self.view viewWithTag:303];
    
    UIImageView* startRecordingImageView = [startRecordingView viewWithTag:403];
    
     [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
    
    startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];
//
    dictationTimerSeconds=0;  // for save dicatation waiting by timer value
    recordingPauseAndExit=YES;
    paused=YES;
    [recorder pause];

}


-(void)stopRecording
{
    [recorder stop];
    stopped = YES;
    paused = YES;
    recordingPauseAndExit=NO;
    app=[APIManager sharedManager];
    
    if (!edited)
    {
        [self saveAudioRecordToDatabase];

    }
    
    dictationTimerSeconds = 0; // reset the save dicattaion waiting by timer
    
    [self setCompressAudio];
   
    app.awaitingFileTransferCount= [db getCountOfTransfersOfDicatationStatus:@"RecordingComplete"];
}

-(void)prepareAudioPlayer
{
    [recorder stop];
    
    if (!IMPEDE_PLAYBACK)
    {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
    }
    // [recorder stop];
    NSError *audioError;
    
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordedAudioURL error:&audioError];
    //int maxValue= ceil(player.duration);
    audioRecordSlider.maximumValue = player.duration;
    player.currentTime = audioRecordSlider.value;
    
    player.delegate = self;
        
    [player prepareToPlay];
    
}

-(void)prepareAudioPlayerForOriginalFileDuration
{
    [recorder stop];
    
    if (!IMPEDE_PLAYBACK)
    {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
    }
    // [recorder stop];
    NSError *audioError;
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@.caf", self.recordedAudioFileName],
                               nil];
    
    
    NSURL* existingFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:existingFileUrl error:&audioError];
    //int maxValue= ceil(player.duration);
    audioRecordSlider.maximumValue = player.duration;
    player.currentTime = audioRecordSlider.value;
    
    player.delegate = self;
    
    [player prepareToPlay];
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Error while decoding: %@", [error localizedDescription] );
}

-(void)playRecording
{
    //circleViewTimerSeconds=0;
   // circleViewTimerMinutes=0;
    
    //int maxValue= ceil(player.duration);
    
    int totalMinutes=player.duration/60;
    int total=  player.duration;
    int totalSeconds= total%60;
    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",totalMinutes,totalSeconds];
    
    if (totalMinutes>99)//foe more than 99 min show time in 3 digits
    {
        currentDuration.text=[NSString stringWithFormat:@"%03d:%02d",totalMinutes,totalSeconds];//for slider label time label
        
    }
    
   // [self setTimer];
    [player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)players successfully:(BOOL)flag
{
    UIView* startRecordingView= [self.view viewWithTag:303];
    UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
    startRecordingImageView.image=[UIImage imageNamed:@"Play"];
    [stopTimer invalidate];
    [sliderTimer invalidate];
    
    [[self.view viewWithTag:701] setHidden:NO];//edit button and image
    
    [[self.view viewWithTag:702] setHidden:NO];
    
    [[self.view viewWithTag:703] setHidden:NO];//edit button and image
    
    [[self.view viewWithTag:704] setHidden:NO];

    audioRecordSlider.value = player.duration;
    int currentTime=player.duration;
    int minutes=currentTime/60;
    int seconds=currentTime%60;
    currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    if (minutes>99)//foe more than 99 min show time in 3 digits
    {
        currentDuration.text=[NSString stringWithFormat:@"%03d:%02d",minutes,seconds];//for slider label time label
        
    }

   
}


#pragma mark: Audio Compression and Conversion

-(void)setCompressAudio
{
    
//    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
//    NSString *source=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@copy.caf",self.recordedAudioFileName]];
//
    // NSString *source = [[NSBundle mainBundle] pathForResource:@"sourceALAC" ofType:@"caf"];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    destinationFilePath= [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",self.recordedAudioFileName]];
    //destinationFilePath = [[NSString alloc] initWithFormat: @"%@/output.caf", documentsDirectory];
//    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
//    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
    NSError* error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAudioProcessing error:&error];
    
    if (error)
    {
        printf("Setting the AVAudioSessionCategoryAudioProcessing Category failed! %ld\n", (long)error.code);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //NSLog(@"Reachable");
                           [self hideHud];
                       });

        return;
    }
    
    
    
    // run audio file code in a background thread
    [self convertAudio];

}
- (bool)convertAudio
{

    NSError* error1;
    
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
    
    NSString *source=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@copy.caf",self.recordedAudioFileName]];
    
//    OSStatus error = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate);
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath] && [[NSFileManager defaultManager] fileExistsAtPath:source]) {// if reocrded new then only remove old
        [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:&error1];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:source]) {
        bool copied =  [[NSFileManager defaultManager] copyItemAtPath:source toPath:destinationFilePath error:&error1];

         bool removed =    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error1];
    }
    
    
//    if (error) {
//
//        dispatch_async(dispatch_get_main_queue(), ^
//                       {
//
//                           [self hideHud];
//                       });
//        return false;
//    }
//    else
//    {
       
        NSArray* pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   AUDIO_FILES_FOLDER_NAME,
                                   [NSString stringWithFormat:@"%@.caf", self.recordedAudioFileName],
                                   nil];
        self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
        [self hideHud];
        return true;
//    }
    
}


//-(NSString*)getDateAndTimeString
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = DATE_TIME_FORMAT;
//    recordCreatedDateString = [formatter stringFromDate:[NSDate date]];
//    return recordCreatedDateString;
//}

-(void)saveAudioRecordToDatabase
{
    if (!edited)
    {
        app=[APIManager sharedManager];
        NSString* recordedAudioFileNamem4a=[NSString stringWithFormat:@"%@.caf",self.recordedAudioFileName];
        NSString* filePath=[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]] stringByAppendingPathComponent:recordedAudioFileNamem4a];
        uint64_t freeSpaceUnsignLong= [[APIManager sharedManager] getFileSize:filePath];
        long fileSizeinKB=freeSpaceUnsignLong;
        
        [self prepareAudioPlayer];//initiate audio player with current recording to get currentAudioDuration
        
        recordCreatedDateString=[app getDateAndTimeString];//recording createdDate
        NSString* recordingDate=recordCreatedDateString;//recording updated date
        
        int dictationStatus=1;
        if (recordingPauseAndExit)
        {
            dictationStatus=2;
        }
        int transferStatus=0;
        int deleteStatus=0;
        NSString* deleteDate=@"";
        NSString* transferDate=@"";
        
        //int duration= ceil(player.duration);
        NSString *currentDuration1=[NSString stringWithFormat:@"%f",player.duration];
        NSString* fileSize=[NSString stringWithFormat:@"%ld",fileSizeinKB];
        int newDataUpdate=0;
        int newDataSend=0;
        int mobileDictationIdVal;
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
        DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //deptObj.departmentName=departmentNameLanel.text;
        //DepartMent *deptObj=[[NSUserDefaults standardUserDefaults] valueForKey:SELECTED_DEPARTMENT_NAME];
        //deptObj.departmentName;
        NSString* departmentName=[db getDepartMentIdFromDepartmentName:deptObj.departmentName];
        
        NSDictionary* audioRecordDetailsDict=[[NSDictionary alloc]initWithObjectsAndKeys:self.recordedAudioFileName,@"recordItemName",recordCreatedDateString,@"recordCreatedDate",recordingDate,@"recordingDate",transferDate,@"transferDate",[NSString stringWithFormat:@"%d",dictationStatus],@"dictationStatus",[NSString stringWithFormat:@"%d",transferStatus],@"transferStatus",[NSString stringWithFormat:@"%d",deleteStatus],@"deleteStatus",deleteDate,@"deleteDate",fileSize,@"fileSize",currentDuration1,@"currentDuration",[NSString stringWithFormat:@"%d",newDataUpdate],@"newDataUpdate",[NSString stringWithFormat:@"%d",newDataSend],@"newDataSend",[NSString stringWithFormat:@"%d",mobileDictationIdVal],@"mobileDictationIdVal",departmentName,@"departmentName",nil];
        
        [db insertRecordingData:audioRecordDetailsDict];
        
        if (recordingPauseAndExit)
        {
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
    
    else
        if (!stopped)
        {
            [self updateDictationStatus:@"RecordingPause"];
        }
    
    
}

#pragma mark:TableView Datasource and Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Database* db=[Database shareddatabase];
    departmentNamesArray=[db getDepartMentNames];
    return departmentNamesArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    UILabel* tabelViewDepartmentLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, self.view.frame.size.width - 60.0f, 18)];
    UIButton* radioButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 18, 18)];
    tabelViewDepartmentLabel.text = [departmentNamesArray objectAtIndex:indexPath.row];
    tabelViewDepartmentLabel.tag=indexPath.row+200;
    tabelViewDepartmentLabel.textColor = [UIColor darkTextColor];
    radioButton.tag=indexPath.row+100;
    
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
//    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([existingDepartmentName isEqualToString:tabelViewDepartmentLabel.text])
    {

        [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        
    }
    else
        [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
    [cell addSubview:radioButton];
    [cell addSubview:tabelViewDepartmentLabel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    cell=[tableView cellForRowAtIndexPath:indexPath];
    UILabel* departmentNameLanel= [cell viewWithTag:indexPath.row+200];
    UIButton* radioButton=[cell viewWithTag:indexPath.row+100];
    //NSLog(@"%ld",indexPath.row);
   // NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
    DepartMent *deptObj = [[DepartMent alloc]init];
   long deptId= [[[Database shareddatabase] getDepartMentIdFromDepartmentName:departmentNameLanel.text] longLongValue];

    deptObj.Id=deptId;
    //deptObj.Id=indexPath.row;
    deptObj.departmentName = departmentNameLanel.text;
    
    existingDepartmentName = departmentNameLanel.text;
    
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:deptObj];

    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:SELECTED_DEPARTMENT_NAME];
    
    
  //  [[NSUserDefaults standardUserDefaults] setValue:departmentNameLanel.text forKey:SELECTED_DEPARTMENT_NAME];
    [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    [tableView reloadData];
    //[self performSelector:@selector(hideTableView) withObject:nil afterDelay:0.2];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {


        cell.backgroundColor = [UIColor whiteColor];

}
-(void)cancel:(id)sender
{
    //    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    long deptId= [[[Database shareddatabase] getDepartMentIdFromDepartmentName:departmentLabel.text] longLongValue];
    //
    //    deptObj.Id=deptId;
    //    //deptObj.Id=indexPath.row;
    //    deptObj.departmentName=departmentLabel.text;
    //    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:deptObj];
//    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
//    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//    NSLog(@"%ld",deptObj.Id);
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME_COPY];
    DepartMent *deptObj1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    existingDepartmentName = deptObj1.departmentName;
//    NSLog(@"%ld",deptObj1.Id);
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SELECTED_DEPARTMENT_NAME];
    [popupView removeFromSuperview];
}

-(void)save:(id)sender
{

    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:SELECTED_DEPARTMENT_NAME_COPY];

    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    UILabel* transferredByLabel= [self.view viewWithTag:102];
    transferredByLabel.text=deptObj.departmentName;
    existingDepartmentName = deptObj.departmentName;

    [[Database shareddatabase] updateDepartment:deptObj.Id fileName:self.recordedAudioFileName];

    [popupView removeFromSuperview];
}



-(void)hideTableView
{
    
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:504] removeFromSuperview];//
}


- (IBAction)deleteRecording:(id)sender

{
    
    alertController = [UIAlertController alertControllerWithTitle:@"Delete"
                                                          message:DELETE_MESSAGE
                                                   preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Delete"
                                            style:UIAlertActionStyleDestructive
                                          handler:^(UIAlertAction * action)
                    {
                        //APIManager* app=[APIManager sharedManager];
                        NSString* dateAndTimeString=[app getDateAndTimeString];
                        [db updateAudioFileStatus:@"RecordingDelete" fileName:recordedAudioFileName dateAndTime:dateAndTimeString];

                        BOOL deleted= [app deleteFile:recordedAudioFileName];
                        
                        [AppPreferences sharedAppPreferences].recordNewOffline = NO;

                        if (deleted)
                        {
                            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismiss"];//for recordtabarControlr ref to dismiss current view
                            [self dismissViewControllerAnimated:YES completion:nil];

                        }
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
 
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)stopRecordingButtonClicked:(id)sender
{
    [self setStopRecordingView:sender];
    
}
- (IBAction)editAudioButtonPressed:(UIButton*)sender
{
    //Insert at the End: directly start recording and compose
    
    //Insert in Between: start recording and insert at slider position
    
    //overwrite: forst delete upto end(and then store),again start recfording and compose with stored recording
    
    //delete upto end: delete upto end and store the result
    
    updatedInsertionTime = 0;
    
    [self prepareAudioPlayer];
    
    alertController = [UIAlertController alertControllerWithTitle:@""
                                                          message:@"Select an action"
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    
   UIAlertAction* actionInsert = [UIAlertAction actionWithTitle:@"Insert at the End"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        
                        if (player.duration > RECORDING_LIMIT)
                        {
                            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:MAXIMUM_RECORDING_LIMIT_MESSAGE withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
                        }
                        else
                        {
                            edited = YES;
                        
                            editType = @"insert";

                            dispatch_async(dispatch_get_main_queue(), ^
                                       {
                                           //NSLog(@"Reachable");
                                           
                                           [self.view setUserInteractionEnabled:NO];
                                           
                                           int seconds = player.duration;
                                           int audioHour= seconds/(60*60);
                                           int audioHourByMod= seconds%(60*60);
                                           
                                           int audioMinutes = audioHourByMod / 60;
                                           int audioSeconds = audioHourByMod % 60;
                                           
                                           //int audioSeconds = (seconds) % 60;
                                           
                                           dictationTimerSeconds = 0; // reset the save dicattaion waiting by timer
                                           
                                           circleViewTimerHours = audioHour;
                                           circleViewTimerMinutes = audioMinutes;
                                           circleViewTimerSeconds = audioSeconds;
                                           
                                           cirecleTimerLAbel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];//for circleView timer label;//for circleView timer label
                                           
                                           [[self.view viewWithTag:701] setHidden:YES];//edit button and image
                                           
                                           [[self.view viewWithTag:702] setHidden:YES];
                                           
                                           [[self.view viewWithTag:703] setHidden:YES];//edit button and image
                                           
                                           [[self.view viewWithTag:704] setHidden:YES];
                                           
                                           [self startNewRecordingForEdit];
                                           
                                       });
                        
                            

                        }
                        
                    }]; //You can use a block here to handle a press on this button
    
    [alertController addAction:actionInsert];
    
    UIAlertAction* actionInsertInBetween = [UIAlertAction actionWithTitle:@"Insert in Between"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                if (player.duration > RECORDING_LIMIT)
                                                {
                                                     [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:MAXIMUM_RECORDING_LIMIT_MESSAGE withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
                                                }
                                                else
                                                {
                                                    editType = @"insertInBetween";
                                                    edited = YES;
                                                    [self.view setUserInteractionEnabled:NO];

                                                    [self deleteToEnd];
                                                }
                                                
                                                
                                            }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionInsertInBetween];
   

   UIAlertAction* actionOverWrite = [UIAlertAction actionWithTitle:@"Overwrite"
                                                                                     style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action)
                                                             {
                                                                 if (audioRecordSlider.value > RECORDING_LIMIT)
                                                                 {
                                                                      [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:MAXIMUM_RECORDING_LIMIT_MESSAGE withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
                                                                 }
                                                                 else
                                                                 {
                                                                     //totalSecondsOfAudio = audioRecordSlider.value;
                                                                     
                                                                     editType = @"overWrite";
                                                                 
                                                                     edited = YES;
                                                                
                                                                     [self.view setUserInteractionEnabled:NO];
                                                                 
                                                                     [self deleteToEnd];
                                                                 }
                                                                 

                                                             }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOverWrite];
    
    actionDelete = [UIAlertAction actionWithTitle:@"Delete up to End"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        if (player.duration == player.currentTime)
                        {
                            
                        }
                        else
                        {
                            edited = YES;
                            editType = @"delete";
                            [self.view setUserInteractionEnabled:NO];

                            [self deleteToEnd];
                        }
                        //totalSecondsOfAudio = audioRecordSlider.value;

                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionCancel];
    
    
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    //show alert differently for ipad
//    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIPopoverPresentationController *popPresenter = [alertController
                                                         popoverPresentationController];
        popPresenter.sourceView = sender;
        popPresenter.sourceRect = sender.bounds;
    }
   
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)deleteToEnd
{
    dictationTimerSeconds = 0; // reset the save dicattaion waiting by timer
    
    [sliderTimer invalidate];
    
    // backup: if get killed while saving the record
    AVMutableComposition* composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack* appendedAudioTrack =
    [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                             preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Grab the two audio tracks that need to be appended
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@.caf", self.recordedAudioFileName],
                               nil];
    
    NSURL* existingFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVURLAsset* originalAsset = [[AVURLAsset alloc]
                                 initWithURL:existingFileUrl options:nil];
    //                        AVURLAsset* newAsset = [[AVURLAsset alloc]
    //                                                initWithURL:recordedAudioURL options:nil];
    
    NSError* error = nil;
    
    // Grab the first audio track and insert it into our appendedAudioTrack
    NSArray *originalTrack = [originalAsset tracksWithMediaType:AVMediaTypeAudio];
    
    if (originalTrack.count <= 0)
    {
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
   
    CMTimeRange timeRange1 = CMTimeRangeMake(kCMTimeZero, originalAsset.duration);
    [appendedAudioTrack insertTimeRange:timeRange1
                                ofTrack:[originalTrack objectAtIndex:0]
                                 atTime:kCMTimeZero
                                  error:&error];
    
    float sliderValue = audioRecordSlider.value ;
//    int64_t totalTrackDuration = player.duration ;
    
    

    CMTime time =   [self getTotalCMTimeFromMilliSeconds:audioRecordSlider.value];
    
    CMTime time1 =   [self getTotalCMTimeFromMilliSeconds:player.duration - audioRecordSlider.value];

//    CMTime time1 =   CMTimeMake(totalTrackDuration, 1);
    
    CMTimeRange timeRange = CMTimeRangeMake(time, time1);
    //insertInBetween
    
   
    if (![editType isEqualToString:@"insertInBetween"])
    {

        if (sliderValue == 0)
        {
            
//            CMTime audioDuration = CMTimeMakeWithSeconds(0.6, 3);
            CMTime audioDuration = CMTimeMakeWithSeconds(0.1, 1000);

            CMTime audioDuration1 = CMTimeMakeWithSeconds(player.duration, 1);
            
            CMTimeRange timeRange = CMTimeRangeMake(audioDuration, audioDuration1);
            [appendedAudioTrack removeTimeRange:timeRange];
            
        }
        else
        {
            time = CMTimeMakeWithSeconds(audioRecordSlider.value, 1);
            time1 = CMTimeMakeWithSeconds(player.duration - audioRecordSlider.value, 1);
            timeRange = CMTimeRangeMake(time, time1);
            [appendedAudioTrack removeTimeRange:timeRange];
            
        }
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^
//                   {
                       // [self prepareAudioPlayer];
                       
    
    int totalMinutes=sliderValue/60;
    int total=  sliderValue;
    int totalFloatSeconds =  sliderValue;
    
    int totalSeconds= total%60;
    
    
    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",totalMinutes,totalSeconds];
    
    if (totalMinutes>99)//foe more than 99 min show time in 3 digits
    {
        totalDuration.text=[NSString stringWithFormat:@"%03d:%02d",totalMinutes,totalSeconds];//for slider label time label
        
    }
    audioRecordSlider.maximumValue=totalFloatSeconds;
    audioRecordSlider.value = totalFloatSeconds;
                       
//                   });
    
    
    
    if (error)
    {
        // do something
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        return;
    }
    
    // Create a new audio file using the appendedAudioTrack
    AVAssetExportSession* exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    if (!exportSession)
    {
        // do something
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]];
    //[[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]] error:&error];
    
    exportSession.outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]]];//composed audio url,later on this will be deleted
    // export.outputFileType = AVFileTypeWAVE;
    
//    exportSession.outputFileType = AVFileTypeWAVE;
    exportSession.outputFileType = AVFileTypeAppleM4A;

    //    AVFileTypeAppleM4A
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        // exported successfully?
        NSError* error;
        if (exportSession.status==AVAssetExportSessionStatusCompleted)
        {
            //first remove the existing file
            [[NSFileManager defaultManager] removeItemAtPath:destpath error:&error];
            //then move compossed file to existingAudioFile
            bool moved=  [[NSFileManager defaultManager] moveItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]] toPath:destpath error:&error];
            
            
            if (moved)
            {
                //remove the composed file copy
                [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]] error:&error];
                
                
                
                
                
                if ([editType isEqualToString:@"overWrite"] || [editType isEqualToString:@"insertInBetween"])
                {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       [self prepareAudioPlayer];
                                       
                                       
                                       //                [db updateAudioFileName:recordedAudioFileName duration:player.duration];
                                       if (!IMPEDE_PLAYBACK)
                                       {
                                           [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
                                       }
                                       
//                                       //NSLog(@"Reachable");
//                                       if (!IMPEDE_PLAYBACK)
//                                       {
//                                           [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
//                                       }

                                       int seconds = player.duration;
                                       
                                       int audioHour= seconds/(60*60);
                                       int audioHourByMod= seconds%(60*60);
                                       
                                       int audioMinutes = audioHourByMod / 60;
                                       int audioSeconds = audioHourByMod % 60;
                                       
                                       //int audioSeconds = (seconds) % 60;
                                       
                                       circleViewTimerHours = audioHour;
                                       circleViewTimerMinutes = audioMinutes;
                                       circleViewTimerSeconds = audioSeconds;

                                       cirecleTimerLAbel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];//for circleView timer label
                                       
                                       [[self.view viewWithTag:701] setHidden:YES];//edit button and image
                                       
                                       [[self.view viewWithTag:702] setHidden:YES];
                                       [[self.view viewWithTag:703] setHidden:YES];//edit button and image
                                       
                                       [[self.view viewWithTag:704] setHidden:YES];
                                       [self startNewRecordingForEdit];
                                       
                                   });
                    
                   
                }
                
                else
                    if ([editType isEqualToString:@"delete"])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                            [self prepareAudioPlayerForOriginalFileDuration];
                            
                            [db updateAudioFileName:recordedAudioFileName duration:player.duration];
                            
                            if (!IMPEDE_PLAYBACK)
                            {
                                [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
                            }
                            
                            [self audioPlayerDidFinishPlaying:player successfully:true];

                            [self.view setUserInteractionEnabled:YES];

                        });

                    }
                
            }
            
            
            
            
            
        }
        if (exportSession.status==AVAssetExportSessionStatusFailed)
        {
            [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
            
            NSLog(@"error = %@", exportSession.error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.view setUserInteractionEnabled:YES];
                
            });
           
        }
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusFailed:
                break;
            case AVAssetExportSessionStatusCompleted:
                
                // you should now have the appended audio file
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            default:
                break;
        }
        
    }];
    
    NSLog(@"error is: %@",error.localizedDescription);

}

//-(void)editRecording
//{
//
//    [self checkPermissionAndStartRecording];
//    [[self.view viewWithTag:98] removeFromSuperview];
//
//}

-(void)composeAudio
{
    
    NSError* error = nil;

    [recorder stop];
    
    // Make a track on which we are going to append two audio assets.
    AVMutableComposition* composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack* appendedAudioTrack =
    [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                             preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // 1. Grab the two audio tracks that need to be appended
    
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@.caf", self.recordedAudioFileName],
                               nil];
    
    NSArray* newFilePathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@editedCopy.caf", self.recordedAudioFileName],
                               nil];
    
    NSURL* existingFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVURLAsset* originalAsset = [[AVURLAsset alloc]
                                 initWithURL:existingFileUrl options:nil];
    
    NSURL* newFileUrl =  [NSURL fileURLWithPathComponents:newFilePathComponents];
    
    AVURLAsset* newAsset = [[AVURLAsset alloc]
                            initWithURL:newFileUrl options:nil];
    
  
    NSArray *originalTrack = [originalAsset tracksWithMediaType:AVMediaTypeAudio];
    
//    AVURLAsset *oldAudioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:tempOldFilePath] options:nil];

    
    if (originalTrack.count <= 0)
    {
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, originalAsset.duration);
    [appendedAudioTrack insertTimeRange:timeRange
                                ofTrack:[originalTrack objectAtIndex:0]
                                 atTime:kCMTimeZero
                                  error:&error];
    
    if (error)
    {
        NSLog(@"errorF = %@", error.localizedFailureReason);
        NSLog(@"errorD = %@", error.localizedDescription);
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    
    
    // 3. Grab the second audio track and insert it at the end of the first one
    
    NSArray *newTrack = [newAsset tracksWithMediaType:AVMediaTypeAudio];
    
    if (newTrack.count <= 0)
    {
        NSLog(@"error in new track = %@", error.localizedFailureReason);

        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        [self setCompressAudio];
//        editType = nil;
        return;
    }
    
    CMTime totalTime;
    if ([editType isEqualToString:@"overWrite"])// if overwrite then get slider time, and insert new recording at slider position
    {
       
        if (updatedInsertionTime == 0)
        {
            float_t sliderValue = 0.0;
            
            if (playerDurationWithMilliSeconds > 0.1) {
                sliderValue = playerDurationWithMilliSeconds - 0.03;// to adjust accuracy and file compose failure;
            }else{
                sliderValue = playerDurationWithMilliSeconds;// to adjust accuracy and file compose failure;
            }
            
            
            NSLog(@"overwrite updatedInsertionTime = %f", playerDurationWithMilliSeconds);
            
            if (sliderValue <= 0)
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:0]; // if slider pos. <= 0 then dont subtrat
                
            }
            else
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:sliderValue - 0.05]; // if slider pos. = 0 then dont subtrat
                
            }
            
        }
        else
        {
            NSLog(@"overwrite updatedInsertionTime = %f", updatedInsertionTime);

            if (updatedInsertionTime <= 0)
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:updatedInsertionTime];

            }
            else
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:updatedInsertionTime - 0.05];

            }


            
        }
        
    }
    else if ([editType isEqualToString:@"insertInBetween"])
    {
        if (updatedInsertionTime == 0)
        {
            float_t sliderValue = 0.0;
            
            if (playerDurationWithMilliSeconds > 0.1) {
                sliderValue = playerDurationWithMilliSeconds - 0.03;// to adjust accuracy and file compose failure;
            }else{
                sliderValue = playerDurationWithMilliSeconds;// to adjust accuracy and file compose failure;
            }

            if (sliderValue <= 0)
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:0]; // if slider pos. <= 0 then dont subtrat

            }
            else
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:sliderValue - 0.05]; // if slider pos. = 0 then dont subtrat

            }


            
        }
        else
        {
            
            if (updatedInsertionTime <= 0)
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:updatedInsertionTime];
                
            }
            else
            {
                totalTime = [self getTotalCMTimeFromMilliSeconds:updatedInsertionTime - 0.05];
                
            }

            
        }
    }
    else
    if ([editType isEqualToString:@"insert"])// if its insert then insert new recording at end of original recording
    {
        totalTime = originalAsset.duration;
//        totalTime =   originalAsset.duration;

    }
        else
        {
            totalTime =   originalAsset.duration;
            
        }
    
    
//    CMTime time1 = CMTimeMake(1, 1);
    timeRange = CMTimeRangeMake(kCMTimeZero, newAsset.duration);
    
    [appendedAudioTrack insertTimeRange:timeRange
                                ofTrack:[newTrack objectAtIndex:0]
                                 atTime:totalTime
                                  error:&error];
    
    float_t newTime = CMTimeGetSeconds(newAsset.duration);
    float_t oldTime = CMTimeGetSeconds(totalTime);

//    updatedInsertionTime = CMTimeGetSeconds(time);
    updatedInsertionTime = newTime + oldTime;
    NSLog(@"new time = %f", newTime);
    NSLog(@"old time = %f", oldTime);

//    NSLog(@"insertion time = %f", updatedInsertionTime);

    NSLog(@"insertion time = %f", updatedInsertionTime);
    if (error)
    {
        // do something
        NSLog(@"error in insertTimeRange = %@", error.localizedDescription);
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
//        editType = nil;

        return;
    }
    
   
    AVAssetExportSession* exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    if (!exportSession)
    {
        // do something
        NSLog(@"error in exportSession");

        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        
//        editType = nil;

        return;
    }
    
    // *purpose of below paths
    // 1) copy.caf : save one copy of composed file as ..copy.caf and use this copy as orginal one when user stop the recording
    // 2) .caf : save one copy of composed file as .. .caf and use this copy to compose newly recorded file
    // 3) editedCopy.caf : when compose complete, remove editedCopy
    // 4) co.caf : export the composed files at this path and then distribute the composed file copy to 1) and 2)
    NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
    
    NSString* originalFilePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
    
    NSString* recordedFilePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@editedCopy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];

    
    exportSession.outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]]];//composed audio url,later on this will be deleted
    // export.outputFileType = AVFileTypeWAVE;
    
    exportSession.outputFileType = AVFileTypeAppleM4A;
//    exportSession.outputFileType = AVFileTypeMPEG4;
 
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        // exported successfully?
        NSError* error;
        if (exportSession.status==AVAssetExportSessionStatusCompleted)
        {
           
            
//            editType = nil;
            //first remove the existing file
            [[NSFileManager defaultManager] removeItemAtPath:destpath error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:originalFilePath error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:recordedFilePath error:&error];

            //then move compossed file to existingAudioFile
            bool moved=  [[NSFileManager defaultManager] copyItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] toPath:destpath error:&error];// save file for compression(if user press stopp then this file(destpath will get compressed))
            
            [[NSFileManager defaultManager] copyItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] toPath:originalFilePath error:&error];// save file for next time composition(i.e.1st file and 2nd will be editedCopy which we will record);
            
            if (moved)
            {
                //remove the temporarily stored composed file copy
                BOOL removed =  [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:&error];
                
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self prepareAudioPlayerForOriginalFileDuration];
                
                                   [db updateAudioFileName:self.recordedAudioFileName duration:player.duration];
                                   
                                   if (!IMPEDE_PLAYBACK)
                                   {
                                       [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
                                   }
                               });
               
                
                if (edited && !paused)
                {
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       //NSLog(@"Reachable");
                                       [self stopEditedRecording];
                                   });
                    
                }
                else
                {
                
                    [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];

                }
                
               // [self prepareAudioPlayerForOriginalFileDuration];

                
            }
            
        }
        if (exportSession.status==AVAssetExportSessionStatusFailed)
        {
//            editType = nil;
            NSLog(@"exportSession.error = %@",exportSession.error.localizedDescription);
            NSLog(@"exportSession.error = %@",exportSession.error.localizedFailureReason);
            NSLog(@"exportSession.error = %@",exportSession.error.localizedRecoveryOptions);
            NSLog(@"exportSession.error = %@",exportSession.error.localizedRecoverySuggestion);



            [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
            
        }
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusFailed:
                 NSLog(@"exportSession.error = %@",exportSession.error.localizedDescription);
                break;
            case AVAssetExportSessionStatusCompleted:
                
                // you should now have the appended audio file
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            default:
                break;
        }
        
    }];
    
    NSLog(@"%@",error.localizedDescription);
}


-(NSArray*)getCMTimeValueAndScaleForMilliseconds:(float_t)milliSeconds
{
    int64_t value = 0;
    
    int32_t scale = 0;
    
    if (milliSeconds >= 0.5)
    {
        if (milliSeconds >= 0.6 && milliSeconds < 0.7)
        {//0.64
            value = 20;
            
            scale = 31;
        }
        else
            if (milliSeconds >= 0.7 && milliSeconds < 0.8)
            {//0.74
                value = 20;
                
                scale = 27;
            }
            else
                if (milliSeconds >= 0.8 && milliSeconds < 0.9)
                {//0.84
                    value = 66;
                    
                    scale = 78;
                }
                else
                    if (milliSeconds >= 0.9 && milliSeconds < 1)
                    {//0.94
                        value = 80;
                        
                        scale = 85;
                    }
                    else
                    {
                        // for 0.5 to 0.599
                        value = 20;
                        
                        scale = 37;
                    }
        
        
    }
    else
    {
        if (milliSeconds >= 0.1 && milliSeconds < 0.2)
        {//0.14
            value = 10;
            
            scale = 67;
        }
        else
            if (milliSeconds >= 0.2 && milliSeconds < 0.3)
            {//0.24
                value = 10;
                
                scale = 41;
            }
            else
                if (milliSeconds >= 0.3 && milliSeconds < 0.4)
                {//0.34
                    value = 10;
                    
                    scale = 29;
                }
                else
                    if (milliSeconds >= 0.4 && milliSeconds < 0.5)
                    {//0.44
                        value = 20;
                        
                        scale = 45;
                    }
        
    }
    
    NSArray* valueAndScaleArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%lld", value], [NSString stringWithFormat:@"%d", scale], nil];
    
    return valueAndScaleArray;
    
}

-(CMTime)getTotalCMTimeFromMilliSeconds:(float_t)totalMilliSeconds
{
    CMTime totalTime;
    
    int64_t seconds = floor(totalMilliSeconds);
    
    CMTime timeInSeconds =   CMTimeMake(seconds, 1);
    
    float_t milliSeconds = fmod(totalMilliSeconds, floor(totalMilliSeconds));
    
    int64_t value = 0;
    
    int32_t scale = 0;
    
    NSArray* valueAndScaleArray = [self getCMTimeValueAndScaleForMilliseconds:milliSeconds];
    
    value = [[valueAndScaleArray objectAtIndex:0] longLongValue];
    
    scale = [[valueAndScaleArray objectAtIndex:1] intValue];
    
    if (value == 0)
    {
        totalTime = timeInSeconds;
    }
    else
    {
        CMTime timeInMilliSeconds =   CMTimeMake(value, scale);
        
        totalTime = CMTimeAdd(timeInSeconds, timeInMilliSeconds);
    }
    
    return totalTime;
}

-(void)startNewRecordingForEdit
{
    [[self.view viewWithTag:98] removeFromSuperview];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    UIView* startRecordingView= [self.view viewWithTag:303];
    
    UIView* pauseRecordingView =  [self.view viewWithTag:302];
    
    UILabel* recordingStatusLabel= [self.view viewWithTag:100];
    
    UILabel* startLabel = [self.view viewWithTag:603];
    
    startLabel.text = @"Pause";
    
    startLabel.textColor = [UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    
    UIImageView* startRecordingImageView;
    
    UIImageView* animatedImageView= [self.view viewWithTag:1001];
    
    UIView* stopRecordingView = [self.view viewWithTag:301];
    
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
    
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    
    UILabel* RecordingLabel=[self.view viewWithTag:603];
    
    [animatedImageView setHidden:NO];
    
    [animatedImageView startAnimating];
    
    animatedImageView.image=[UIImage imageNamed:@"SoundWave-3"];
    
    [stopRecordingView setHidden:YES];
    
    recordingPausedOrStoped=YES;
    
    isRecordingStarted=NO;
    
    [stopRecordingView setHidden:NO];
    
    [pauseRecordingView setHidden:NO];
    
    [stopRecordingLabel setHidden:NO];
    
    [pauseRecordingLabel setHidden:NO];
    
    [RecordingLabel setHidden:NO];
    
    [cirecleTimerLAbel setHidden:NO];
    
    [stopNewImageView setHidden:NO];
    
    [stopNewButton setHidden:NO];
    
    [stopLabel setHidden:NO];
    
    [recordingStatusLabel setHidden:NO];
    
    [self editRecord]; // prepare separate recorder for editing with different recording filename(i.e. editedCopy for compose purpose)
    
    startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    
    recordingStatusLabel.text=@"Your audio is being recorded";
   
    double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight<481)
    {
        animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x-10, stopNewImageView.frame.origin.y + stopNewImageView.frame.size.height + 30, recordingStatusLabel.frame.size.width+20, 15)];
    }
    else
        animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x-10, stopNewImageView.frame.origin.y + stopNewImageView.frame.size.height + 40, recordingStatusLabel.frame.size.width+20, 30)];

    
    animatedImageView.animationDuration = 1.0f;
    
    animatedImageView.animationRepeatCount = 0;
    
    [animatedImageView startAnimating];
    
    animatedImageView.userInteractionEnabled=YES;
    
    animatedImageView.tag=1001;
    
    isRecordingStarted=YES;
    
    recordingPausedOrStoped = NO;
    
    paused=NO;
    
    stopped= NO;
    
    startRecordingImageView= [startRecordingView viewWithTag:403];
    
    startRecordingImageView.image=[UIImage imageNamed:@"PauseNew"];
    
    startRecordingImageView  = [startRecordingView viewWithTag:403];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-18, 18, 36)];
    
    [self setTimer];
    
    [self mdRecord];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                       [self.view setUserInteractionEnabled:YES];
                   });


    
}

- (IBAction)speechToTextButtonClicked:(id)sender
{
    if([AppPreferences sharedAppPreferences].userObj != nil)
    {
        NSString *currentiOSVersion = [[UIDevice currentDevice] systemVersion];
        float ver_float = [currentiOSVersion floatValue];
        if (ver_float < 10.0)
        {
              [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Higher iOS version required!" withMessage:@"Please update your device OS to iOS 10.0 or above to use Speech to Text feature." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
        else
        {
             SpeechRecognitionViewController* spvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SpeechRecognitionViewController"];
                      
                      spvc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:spvc animated:true completion:nil];
        }
        
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Login Required!" withMessage:@"Please login to use Speech to Text feature." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        
    }
}
@end
