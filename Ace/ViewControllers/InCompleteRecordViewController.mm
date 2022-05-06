//
//  InCompleteRecordViewController.m
//  Ace
//
//  Created by mac on 24/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//http://stackoverflow.com/questions/9846653/starting-avassetexportsession-in-the-background       //avmutable does not work in background

#import "InCompleteRecordViewController.h"
#import "DepartMent.h"
#define IMPEDE_PLAYBACK NO
//extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);

@interface InCompleteRecordViewController ()

@end

@implementation InCompleteRecordViewController
@synthesize player, recorder, recordedAudioFileName, recordedAudioURL,recordCreatedDateString,existingAudioFileName,existingAudioDate,existingAudioDepartmentName,playerAudioURL,hud,hud1,deleteButton,stopNewImageView,stopNewButton,stopLabel,animatedImageView,audioDurationInSeconds,isOpenedFromAudioDetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    popupView=[[UIView alloc]init];
    
    obj=[[PopUpCustomView alloc]init];
    
    [[self.view viewWithTag:701] setHidden:YES];
    
    [[self.view viewWithTag:702] setHidden:YES];
    
    [[self.view viewWithTag:703] setHidden:YES];
    
    [[self.view viewWithTag:704] setHidden:YES];

    
    db=[Database shareddatabase];
    
    if (!IMPEDE_PLAYBACK)
    {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseRecordingFromBackGround) name:NOTIFICATION_PAUSE_RECORDING
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideDeleteButton) name:NOTIFICATION_FILE_UPLOAD_API
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deleteRecordin) name:NOTIFICATION_DELETE_RECORDING
//                                               object:nil];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pausePlayerFromBackGround) name:NOTIFICATION_PAUSE_AUDIO_PALYER
                                               object:nil];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [AppPreferences sharedAppPreferences].isRecordView = NO;
    
    if (![APIManager sharedManager].userSettingsOpened)
    {
       if(isViewSetUpWhenFirstAppear == false)
       {
           
        i=0;
   
        audioDurationLAbel=[self.view viewWithTag:104];
        
        audioDurationLAbel.text=self.audioDuration;
        
        timerHour = self.audioDurationInSeconds/(60*60);
        int audioHourByMod= self.audioDurationInSeconds%(60*60);
        
        timerMinutes = audioHourByMod / 60;
        
        timerSeconds = audioHourByMod % 60;
        
        audioDurationLAbel.text=[NSString stringWithFormat:@"%02d:%02d:%02d",timerHour,timerMinutes,timerSeconds];
    
        UIView* startRecordingView1= [self.view viewWithTag:203];
        
        [self performSelector:@selector(addView:) withObject:startRecordingView1 afterDelay:0.02];
        
        //set and show recording file name when view will appear
        NSDate *date = [[NSDate alloc] init];
        
        NSTimeInterval seconds = [date timeIntervalSinceReferenceDate];
        
        long milliseconds = seconds*1000;
        
        recordedAudioFileName = [NSString stringWithFormat:@"%ld", milliseconds];
    
        UIView* startRecordingView= [self.view viewWithTag:303];
        
        UIImageView* counterLabel= [startRecordingView viewWithTag:503];
        
        [counterLabel setHidden:NO];
        
        UILabel* fileNameLabel= [self.view viewWithTag:101];
        
        fileNameLabel.text=[NSString stringWithFormat:@"%@",existingAudioFileName];
        
        recordedAudioFileName=[NSString stringWithFormat:@"%@",recordedAudioFileName];

        NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:destpath])
        {
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath:destpath error:&error];
        }
        else{
            
            destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:destpath])
                   {
                       NSError* error;
                       [[NSFileManager defaultManager] removeItemAtPath:destpath error:&error];
                   }
            
        }
               
        
    
        UILabel* transferredByLabel= [self.view viewWithTag:102];
        
          
        transferredByLabel.text = existingAudioDepartmentName;
    
        UILabel* dateLabel= [self.view viewWithTag:103];
        
        dateLabel.text=existingAudioDate;
    
        [[self.view viewWithTag:504] setHidden:YES];
        
        recordingPausedOrStoped=YES;
        
        
        animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"SoundWave-1"],
                                         [UIImage imageNamed:@"SoundWave-2"],
                                         [UIImage imageNamed:@"SoundWave-3"],
                                         nil];
       
        animatedImageView.animationDuration = 1.0f;
        
        animatedImageView.animationRepeatCount = 0;
        
        animatedImageView.image=[UIImage imageNamed:@"SoundWave-3"];

        animatedImageView.userInteractionEnabled=YES;
        
        
        double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
        
        [self.view addSubview: animatedImageView];
        
        if (screenHeight<481)
        {
            UIImageView* animatedImageViewCopy;
            
            animatedImageViewCopy = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.1, animatedImageView.frame.origin.y-50,  self.view.frame.size.width*0.85, 15)];
            
            animatedImageViewCopy.animationImages = [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"SoundWave-1"],
                                                 [UIImage imageNamed:@"SoundWave-2"],
                                                 [UIImage imageNamed:@"SoundWave-3"],
                                                 nil];
            
            animatedImageViewCopy.animationDuration = 1.0f;
            
            animatedImageViewCopy.animationRepeatCount = 0;
            
            animatedImageViewCopy.image=[UIImage imageNamed:@"SoundWave-3"];
            
            animatedImageViewCopy.userInteractionEnabled=YES;
            
            animatedImageView.tag=0;

            animatedImageViewCopy.tag=1001;
            
            animatedImageViewCopy.backgroundColor = [UIColor redColor];
           
            [animatedImageView setHidden:YES];
            
            [self.view addSubview:animatedImageViewCopy];
        }
        else
        {
            animatedImageView.tag=1001;
        }

        NSString* dictationTimeString= [[NSUserDefaults standardUserDefaults] valueForKey:SAVE_DICTATION_WAITING_SETTING];
        
        NSArray* minutesAndValueArray= [dictationTimeString componentsSeparatedByString:@" "];
       
        if (minutesAndValueArray.count < 1)
        {
            return;
        }
        minutesValue= [[minutesAndValueArray objectAtIndex:0]intValue];
        
        
        UIImageView*  startRecordingImageView= [startRecordingView viewWithTag:403];
        
        startRecordingImageView.image=[UIImage imageNamed:@"PauseNew"];
        
        
        startRecordingImageView  = [startRecordingView viewWithTag:403];
        
        [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-18, 18, 36)];

        NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
    
        [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:SELECTED_DEPARTMENT_NAME_COPY];
        
        totalSecondsOfAudio = self.audioDurationInSeconds;
        
        [self prepareAudioPlayer];
           
        isViewSetUpWhenFirstAppear = true;
        
           playerDurationWithMilliSeconds = player.duration- 0.03;// to adjust accuracy and file compose failure;
       }

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
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    if( [APIManager sharedManager].userSettingsClosed)
    {
        [APIManager sharedManager].userSettingsOpened=NO;
    }
//
    if (![APIManager sharedManager].userSettingsOpened)
    {

    }
    
}



-(void)pauseRecordingFromBackGround
{
    
    isRecordingStarted=YES;
    
    recordingPauseAndExit=YES;
    
    [recorder stop];
    
    UIView* startRecordingView = [self.view viewWithTag:303];
    
    UIImageView* startRecordingImageView = [startRecordingView viewWithTag:403];
    
    [stopTimer invalidate];
    
    UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
    
    recordOrPauseLabel.text = @"Resume";
    
    UIImageView* animatedImageView1= [self.view viewWithTag:1001];
    
    [animatedImageView1 stopAnimating];
    
    animatedImageView1.image=[UIImage imageNamed:@"SoundWave-3"];
    
    if ( [startRecordingImageView.image isEqual:[UIImage imageNamed:@"PauseNew"]] &&  !recordingPausedOrStoped)
    {
        
        [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
        
        recordingPausedOrStoped=YES;
        
        UIApplication*    appl = [UIApplication sharedApplication];
        
        task = [appl beginBackgroundTaskWithExpirationHandler:^{
            [appl endBackgroundTask:task];
            task = UIBackgroundTaskInvalid;
        }];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [self performSelectorOnMainThread:@selector(showHud) withObject:nil waitUntilDone:NO];
            
            [self composeAudio];
        
        [self updateDictationStatus:@"RecordingPause"];
//        });
        startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];

    }
    
    
    
}

-(void)hideDeleteButton
{
    if (recorder.isRecording)
    {
        [[self.view viewWithTag:701] setHidden:YES];
        
        [[self.view viewWithTag:702] setHidden:YES];

    }
    else
    {
        [[self.view viewWithTag:701] setHidden:NO];
        
        [[self.view viewWithTag:702] setHidden:NO];

    }
    
}


#pragma mark: Hud Methods

-(void)hideHud
{
    [hud hideAnimated:YES];
    
}
-(void)hideHud1
{
    [hud1 hideAnimated:YES];
    
}
-(void)showHud
{
    
    [hud hideAnimated:NO];
    
    hud.minSize = CGSizeMake(150.f, 100.f);
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.label.text = @"Saving audio...";
    
    hud.detailsLabel.text = @"Please wait";
    
}

#pragma mark: DismissPopUpTableView
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)presentRecordView
{
    [player stop];
    
    [AppPreferences sharedAppPreferences].selectedTabBarIndex=3;
    
    [AppPreferences sharedAppPreferences].recordNew=YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"dismiss"];

    [self dismissViewControllerAnimated:NO completion:nil];

   // [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"] animated:YES completion:nil];
}

#pragma mark:Navigation bar items actions

- (IBAction)deleteButtonPressed:(id)sender
{
    
    
    alertController = [UIAlertController alertControllerWithTitle:@"Delete"
                                                          message:DELETE_MESSAGE
                                                   preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Delete"
                                            style:UIAlertActionStyleDestructive
                                          handler:^(UIAlertAction * action)
                    {
                        NSString* dateAndTimeString=[app getDateAndTimeString];
                        
                        if (self.isOpenedFromAudioDetails)
                        {
                            [AppPreferences sharedAppPreferences].dismissAudioDetails = YES;// to dismiss audio details so that user will not be able to retransfer the audio
                        }
                        [db updateAudioFileStatus:@"RecordingDelete" fileName:existingAudioFileName dateAndTime:dateAndTimeString];
                        
                        [app deleteFile:[NSString stringWithFormat:@"%@backup",existingAudioFileName]];
                        
                        BOOL deleted1= [app deleteFile:existingAudioFileName];
                        
                        if (deleted1)
                        {
                            
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
        if (recordingPauseAndExit)
        {
            NSError* error1;
            
            NSString* tempCopyPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:tempCopyPath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:tempCopyPath error:&error1];
            }
            else{
                tempCopyPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
                [[NSFileManager defaultManager] removeItemAtPath:tempCopyPath error:&error1];
            }
           
                                      
            [self performSelector:@selector(disMis) withObject:nil afterDelay:0.5];
            
        }
        else
        {
            NSError* error1;
            
            NSString* tempCopyPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
                       
                       if ([[NSFileManager defaultManager] fileExistsAtPath:tempCopyPath])
                       {
                           [[NSFileManager defaultManager] removeItemAtPath:tempCopyPath error:&error1];
                       }
                       else{
                           tempCopyPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
                           [[NSFileManager defaultManager] removeItemAtPath:tempCopyPath error:&error1];
                       }
                      
            
            [self disMis];
        }
}
-(void)disMis
{
//    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"dismis"];
    
    [AppPreferences sharedAppPreferences].recordNew = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [player stop];
}
- (IBAction)moreButtonPressed:(id)sender
{
    
    if ([[self.view viewWithTag:98] isDescendantOfView:self.view])
    {
        NSArray* subViewArray=[NSArray arrayWithObjects:@"User Settings", nil];
        
        editPopUp=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, self.view.frame.origin.y+40, 160, 40) andSubViews:subViewArray :self];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:editPopUp];
    }
    else
    {
        NSArray* subViewArray=[NSArray arrayWithObjects:@"Change Department", nil];
        
        editPopUp=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, self.view.frame.origin.y+40, 160, 40) andSubViews:subViewArray :self];
        
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
       
       [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark: Timer Methods

-(void)setTimer
{
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(updateTimer)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)updateTimer
{
//    NSLog(@"%f",recorder.currentTime);
    ++dictationTimerSeconds;
    //++totalSecondsOfAudio;
    if (player.duration + recorder.currentTime >RECORDING_LIMIT)
    {
        recordingRestrictionLimitCrossed = true;
        
        [self setStopRecordingView:nil];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:RECORDING_SAVED_MESSAGE withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
        recordingRestrictionLimitCrossed = false;
        
        return;
    }
    if (dictationTimerSeconds==(60*minutesValue-1))
    {
        recordingPausedOrStoped=YES;
        
        UIImageView* animatedView= [self.view viewWithTag:1001];
        
        UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
        
        recordOrPauseLabel.text = @"Resume";
        
        [animatedView stopAnimating];
        
        animatedView.image=[UIImage imageNamed:@"SoundWave-3"];
        
        hud.minSize = CGSizeMake(150.f, 100.f);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        
        hud.label.text = @"Saving audio...";
        
        hud.detailsLabel.text = @"Please wait";
        
        [self pauseRecording];
        
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    ++timerSeconds;
    
    if (timerSeconds==60)
    {
        timerSeconds=0;
        ++timerMinutes;
    }
    
    if (timerMinutes==60)
    {
        timerSeconds=0;
        timerMinutes=0;
        ++timerHour;
    }
    
    audioDurationLAbel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",timerHour,timerMinutes,timerSeconds];
    
    
//    if(![self.view viewWithTag:701].hidden && recorder.isRecording)
//    {
//        [[self.view viewWithTag:701] setHidden:YES];
//        
//        [[self.view viewWithTag:702] setHidden:YES];
//        
//        [[self.view viewWithTag:703] setHidden:YES];
//        
//        [[self.view viewWithTag:704] setHidden:YES];
//    }
    
}

//addCircleViews
#pragma mark: Add custom CircleViews

-(void)addView:(UIView*)sender
{
    
    if (sender.tag==203)//Greater width for middle circle
    {
        double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
        
        if (screenHeight==480)
        {
            [self setRoundedView:sender toDiameter:sender.frame.size.width];
            
        }
        else
        [self setRoundedView:sender toDiameter:sender.frame.size.width+20];
    }
    else
        [self setRoundedView:sender toDiameter:sender.frame.size.width];
    
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    if (!isOpenedFromAudioDetails)
    {
        circleView=[[UIView alloc]init];
    
        CGRect newFrame;
    
        if (roundedView.tag==203)
        {
            double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
        
            if (screenHeight==480)
            {
                newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y-10, newSize, newSize);
            }
            else
                newFrame = CGRectMake(roundedView.frame.origin.x-10, roundedView.frame.origin.y-10, newSize, newSize);
        
        }
        else
            newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    
        circleView.frame = newFrame;
    
        circleView.layer.cornerRadius = newSize / 2.0;
    
        circleView.tag=roundedView.tag+100;
    
        UIButton* viewClickbutton=[[UIButton alloc]init];
    
        viewClickbutton.frame=CGRectMake(0, 0, newSize, newSize);//button:subview of view hence 0,0
    
        UIImageView* startStopPauseImageview=[[UIImageView alloc]init];
    
        if (roundedView.tag==203)
        {

            startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-15, (circleView.frame.size.height/2)-16, 30, 32);
        
            startStopPauseImageview.tag=roundedView.tag+200;
        
            startStopPauseImageview.image=[UIImage imageNamed:@"ResumeNew"];
        
//            circleView.layer.borderColor = [UIColor whiteColor].CGColor;
//
//            circleView.layer.borderWidth = 3.0f;
        
//            circleView.backgroundColor=[UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1];
            circleView.backgroundColor=[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1];

            audioDurationLAbel= [self.view viewWithTag:104];

            audioDurationLAbel.textAlignment=NSTextAlignmentCenter;
        
        
            [viewClickbutton addTarget:self action:@selector(setStartRecordingView:) forControlEvents:UIControlEventTouchUpInside];
        
        }
    
        //----------------------------------//
    
        [circleView addSubview:viewClickbutton];
    
        [circleView addSubview:startStopPauseImageview];
    
    
        [self.view addSubview:circleView];
    
    }
    else
    {
        circleView=[[UIView alloc]init];
        
        CGRect newFrame;
        
        if (roundedView.tag==203)
        {
            double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
            
            if (screenHeight==480)
            {
                newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y-10, newSize, newSize);
            }
            else
                newFrame = CGRectMake(roundedView.frame.origin.x-10, roundedView.frame.origin.y-10, newSize, newSize);
            
        }
        else
            newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
        
        circleView.frame = newFrame;
        
        circleView.layer.cornerRadius = newSize / 2.0;
        
        circleView.tag=roundedView.tag+100;
        
        UIButton* viewClickbutton=[[UIButton alloc]init];
        
        viewClickbutton.frame=CGRectMake(0, 0, newSize, newSize);//button:subview of view hence 0,0
        
        UIImageView* startStopPauseImageview=[[UIImageView alloc]init];
        
        if (roundedView.tag==203)
        {
            
            startStopPauseImageview.frame=CGRectMake((circleView.frame.size.width/2)-15, (circleView.frame.size.height/2)-16, 30, 32);
            
            startStopPauseImageview.tag=roundedView.tag+200;
            
            startStopPauseImageview.image=[UIImage imageNamed:@"Play"];
            
//            circleView.layer.borderColor = [UIColor whiteColor].CGColor;
//
//            circleView.layer.borderWidth = 3.0f;
            
//            circleView.backgroundColor=[UIColor blackColor];
            circleView.backgroundColor = [UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1];
//            circleView.layer.borderColor = [UIColor appColor].CGColor;
//            circleView.layer.borderWidth = 1.0;
            audioDurationLAbel= [self.view viewWithTag:104];
            
            audioDurationLAbel.textAlignment=NSTextAlignmentCenter;
            
            
            [viewClickbutton addTarget:self action:@selector(setStartRecordingView:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel* RecordingLabel = [self.view viewWithTag:603];
            
            [RecordingLabel setHidden:YES];
            
            [stopNewImageView setHidden:YES];
            
            [stopNewButton setHidden:YES];
            
            [stopLabel setHidden:YES];
            
            [[self.view viewWithTag:99] setHidden:YES]; //remove recording status label
            
            
            UIImageView* animatedView= [self.view viewWithTag:1001];

            [animatedView setHidden:YES];
            
            
        }
        
        //----------------------------------//
        
        [circleView addSubview:viewClickbutton];
        
        [circleView addSubview:startStopPauseImageview];
        
        
        [self.view addSubview:circleView];

        [self showEditingView];
    }
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
            
            if ( [startRecordingImageView.image isEqual:[UIImage imageNamed:@"PauseNew"]])
            {
                
                UIImageView* animatedView= [self.view viewWithTag:1001];
                
                [animatedView stopAnimating];
                
                animatedView.image=[UIImage imageNamed:@"SoundWave-3"];
                
                hud.minSize = CGSizeMake(150.f, 100.f);
                
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.mode = MBProgressHUDModeIndeterminate;
                
                hud.label.text = @"Saving audio...";
                
                hud.detailsLabel.text = @"Please wait";
                
                [self pauseRecording];
                
                UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
                
                recordOrPauseLabel.text = @"Resume";
                
                recordingPausedOrStoped=YES;
                
                [stopTimer invalidate];
                
                startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];
                
                [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
            }
            
            else
            {
                
                
                recordingPauseAndExit=NO;
                
                recordingPausedOrStoped=NO;
                
                UIImageView* animatedView= [self.view viewWithTag:1001];
                
                [animatedView startAnimating];
                
                [stopTimer invalidate];

                [self setTimer];

                [self audioRecord];
                
                UILabel* recordOrPauseLabel = [self.view viewWithTag:603];
                
                recordOrPauseLabel.text = @"Pause";
                
                
                [self startRecorderAfterPrepareed];
                
                if (self.isOpenedFromAudioDetails)
                {
                    [AppPreferences sharedAppPreferences].dismissAudioDetails = YES;// to dismiss audio details so that user will not be able to retransfer the audio
                }
                [UIApplication sharedApplication].idleTimerDisabled = YES;
                
                [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-18, 18, 36)];
                
                startRecordingImageView.image=[UIImage imageNamed:@"PauseNew"];
                
            }
        }
        
        else
        {
            startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1];
            
            UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
            
            [startRecordingImageView setHidden:NO];
            
            [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-9, 18, 18)];
            
            if ([startRecordingImageView.image isEqual:[UIImage imageNamed:@"Play"]] || !player.isPlaying)
            {
                sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(keepUpdatingSliderTimeWhileAudioPlaying:) userInfo:nil repeats:YES]; // slider timer
                
//                player.currentTime = audioRecordSlider.value;
                
                [self prepareAudioPlayer];
                
                
                [self playRecording];
                
                startRecordingImageView.image=[UIImage imageNamed:@"Pause"];
                
                [[self.view viewWithTag:701] setHidden:YES];
                
                [[self.view viewWithTag:702] setHidden:YES];
                
                [[self.view viewWithTag:703] setHidden:YES];
                
                [[self.view viewWithTag:704] setHidden:YES];
                
            }
            else
            {
                [sliderTimer invalidate];

                [player pause];
                
                [sliderTimer invalidate];
                
               // [stopTimer invalidate]; //audio duration label timer
                
                startRecordingImageView.image=[UIImage imageNamed:@"Play"];
                
                [[self.view viewWithTag:701] setHidden:NO];
                
                [[self.view viewWithTag:702] setHidden:NO];
                
                [[self.view viewWithTag:703] setHidden:NO];
                
                [[self.view viewWithTag:704] setHidden:NO];
            }
            
            
        }
        
    }
    
}

-(void)setStopRecordingView:(UIButton*)sender
{
   
    if (![[NSUserDefaults standardUserDefaults] boolForKey:CONFIRM_BEFORE_SAVING_SETTING] || recordingRestrictionLimitCrossed)
    {
       // [ performSelectorOnMainThread:@selector(showHud) withObject:nil waitUntilDone:YES];
        [recorder stop];
        
        UIImageView* animatedImageView1 = [self.view viewWithTag:1001];
        
        [animatedImageView1 stopAnimating];
        
        [animatedImageView1 setHidden:YES];

        animatedImageView1.image=[UIImage imageNamed:@"SoundWave-3"];
        
        UILabel* RecordingLabel = [self.view viewWithTag:603];
        
        [RecordingLabel setHidden:YES];
        
        [stopNewImageView setHidden:YES];
        
        [stopNewButton setHidden:YES];
        
        [stopLabel setHidden:YES];
        
        [[self.view viewWithTag:99] setHidden:YES]; //remove recording status label
        

        hud.minSize = CGSizeMake(150.f, 100.f);
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        
        hud.label.text = @"Saving audio...";
        
        hud.detailsLabel.text = @"Please wait";
        
        [stopTimer invalidate];

        [AppPreferences sharedAppPreferences].dismissAudioDetails = NO;

        
        [self stopRecordingViewSettingSupport];
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

                            animatedImageView = [self.view viewWithTag:1001];

                            [animatedImageView stopAnimating];
                            
                            animatedImageView.image=[UIImage imageNamed:@"SoundWave-3"];
                            
                            UILabel* RecordingLabel = [self.view viewWithTag:603];
                            
                            [RecordingLabel setHidden:YES];
                            
                            [stopNewImageView setHidden:YES];
                            
                            [stopNewButton setHidden:YES];
                            
                            [stopLabel setHidden:YES];
                            
                            [[self.view viewWithTag:99] setHidden:YES]; //hide recording status label
                            
                            [animatedImageView setHidden:YES];

                            hud.minSize = CGSizeMake(150.f, 100.f);
                           
                            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                           
                            hud.mode = MBProgressHUDModeIndeterminate;
                           
                            hud.label.text = @"Saving audio...";
                           
                            hud.detailsLabel.text = @"Please wait";
                            
                            [stopTimer invalidate];

                            [AppPreferences sharedAppPreferences].dismissAudioDetails = NO;

                            
                            [self stopRecordingViewSettingSupport];
                            
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


-(void)showEditingView
{

    UIView* stopRecordingView = [self.view viewWithTag:301];
    
    UIView* pauseRecordingView =  [self.view viewWithTag:302];
   
    UIView* startRecordingView =  [self.view viewWithTag:303];
    
    [stopRecordingView setHidden:YES];
    
    [pauseRecordingView setHidden:YES];
    
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
    
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    
    UILabel* RecordingLabel=[self.view viewWithTag:603];
    
    recordingPausedOrStoped=YES;
    
    [stopRecordingView setHidden:YES];
    
    [pauseRecordingView setHidden:YES];
    
    [stopRecordingLabel setHidden:YES];
    
    [pauseRecordingLabel setHidden:YES];
    
    [RecordingLabel setHidden:YES];
    
    
    
    startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1];
    
    UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
    
    [startRecordingImageView setHidden:NO];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-9, 18, 18)];
    
    startRecordingImageView.image=[UIImage imageNamed:@"Play"];
    
    [self stopRecording];
    
    double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight<481)
    {
        circleView.frame = CGRectMake(circleView.frame.origin.x, circleView.frame.origin.y-20, circleView.frame.size.width, circleView.frame.size.height);
    }
    
    recordingStopped=YES;
    

    [self performSelector:@selector(addAnimatedView) withObject:nil afterDelay:0.0];



}

-(void)stopRecordingViewSettingSupport
{
    UIView* stopRecordingView = [self.view viewWithTag:301];
    
    UIView* pauseRecordingView =  [self.view viewWithTag:302];
    
   

    
    UIView* startRecordingView =  [self.view viewWithTag:303];
    
    [stopRecordingView setHidden:YES];
    
    [pauseRecordingView setHidden:YES];
    
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
   
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    
    UILabel* RecordingLabel=[self.view viewWithTag:603];
    
    recordingPausedOrStoped=YES;
    
    [stopRecordingView setHidden:YES];
   
    [pauseRecordingView setHidden:YES];
    
    [stopRecordingLabel setHidden:YES];
   
    [pauseRecordingLabel setHidden:YES];
   
    [RecordingLabel setHidden:YES];
    
    startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:143/255.0 blue:255/255.0 alpha:1];
    
    UIImageView* startRecordingImageView= [startRecordingView viewWithTag:403];
    
    [startRecordingImageView setHidden:NO];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-9, 18, 18)];
    
    startRecordingImageView.image=[UIImage imageNamed:@"Play"];
    
    [self stopRecording];
    
    double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight<481)
    {
        circleView.frame = CGRectMake(circleView.frame.origin.x, circleView.frame.origin.y-20, circleView.frame.size.width, circleView.frame.size.height);
    }

    recordingStopped=YES;
    
    [self updateAudioRecordToDatabase:@"RecordingComplete"];

    if (!recordingPauseAndExit)
    {
//        [self performSelector:@selector(composeAudio) withObject:nil afterDelay:0.0];

        [self composeAudio];
       // [self prepareAudioPlayer];
    }
    else
    {
        playerDurationWithMilliSeconds = player.duration- 0.03;// to adjust accuracy and file compose failure;

        [self setCompressAudio];

    }
  
}


-(void)pauseRecording
{
    dictationTimerSeconds = 0;
    
    recordingPauseAndExit=YES;
    
    [recorder pause];
    
    [recorder stop];
    
    [stopTimer invalidate];
    
    
    UIView* startRecordingView= [self.view viewWithTag:303];
    
    UIImageView* startRecordingImageView;
    
    startRecordingImageView  = [startRecordingView viewWithTag:403];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-15, (startRecordingView.frame.size.height/2)-16, 30, 32)];
    
    startRecordingImageView.image=[UIImage imageNamed:@"ResumeNew"];
    
    [self composeAudio];
    
    [self updateAudioRecordToDatabase:@"RecordingPause"];
    
}

-(void)stopRecording
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    dictationTimerSeconds = 0;
    
    [audioDurationLAbel setHidden:YES];
    
    [recorder stop];
    
    app=[APIManager sharedManager];
    
    [self updateAudioRecordToDatabase:@"RecordingComplete"];
    
    app.awaitingFileTransferCount= [db getCountOfTransfersOfDicatationStatus:@"RecordingComplete"];
    
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

- (IBAction)stopRecordingButtonClicked:(id)sender
{
    [self setStopRecordingView:sender];
    
//    playerDurationWithMilliSeconds = player.duration;

}

-(void)addAnimatedView
{
    
    [self prepareAudioPlayer];
    
   UIView* animatedView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    animatedView.tag=98;
    
    audioRecordSlider=[[UISlider alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.14,animatedView.frame.size.height*0.01 , animatedView.frame.size.width*0.7, 30)];
    
    [audioRecordSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    
    audioRecordSlider.tag=197;
    
    //audioRecordSlider.userInteractionEnabled=NO;
    
    UIButton* uploadAudioButton=[[UIButton alloc]initWithFrame:CGRectMake(animatedView.frame.size.width*0.1, animatedView.frame.size.height*0.2, animatedView.frame.size.width*0.8, 36)];
    
    uploadAudioButton.backgroundColor=[UIColor colorWithRed:91/255.0 green:131/255.0 blue:255/255.0 alpha:1];
    
    uploadAudioButton.userInteractionEnabled=YES;
    
    [uploadAudioButton setTitle:@"Upload Recording" forState:UIControlStateNormal];
    
    uploadAudioButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    
    uploadAudioButton.tag=198;
    
    //uploadAudioButton.userInteractionEnabled=NO;
    
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
    
    uploadLaterButton.tag=199;
    
    //uploadLaterButton.userInteractionEnabled=NO;
    
    UIButton* recordNewButton=[[UIButton alloc]initWithFrame:CGRectMake(uploadLaterButton.frame.origin.x+uploadLaterButton.frame.size.width+uploadAudioButton.frame.size.width*0.04, uploadAudioButton.frame.origin.y+uploadAudioButton.frame.size.height+10, uploadAudioButton.frame.size.width*0.48, 36)];
    
    recordNewButton.backgroundColor=[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    
    [recordNewButton setTitle:@"Record New" forState:UIControlStateNormal];
    
    recordNewButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    
    [recordNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    recordNewButton.layer.cornerRadius=5.0f;
    
    [recordNewButton addTarget:self action:@selector(presentRecordView) forControlEvents:UIControlEventTouchUpInside];
    
    recordNewButton.tag=196;
    
   // recordNewButton.userInteractionEnabled=NO;
    
    [self prepareAudioPlayer];
    
    audioRecordSlider.continuous = YES;
    
    audioRecordSlider.maximumValue = player.duration;
    
    audioRecordSlider.value= player.duration;
    
    int currentTime=player.duration;
    
    int minutes=currentTime/60;
    
    int seconds=currentTime%60;

    currentDuration=[[UILabel alloc]initWithFrame:CGRectMake(uploadAudioButton.frame.origin.x, animatedView.frame.size.height*0.1, 80, 20)];
    
    totalDuration=[[UILabel alloc]initWithFrame:CGRectMake(uploadAudioButton.frame.origin.x+uploadAudioButton.frame.size.width-80, animatedView.frame.size.height*0.1, 80, 20)];
    
    currentDuration.textAlignment=NSTextAlignmentLeft;
    
    totalDuration.textAlignment=NSTextAlignmentRight;

    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    
    currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    
    currentDuration.textColor = [UIColor blackColor];
    totalDuration.textColor = [UIColor blackColor];
    
    if (minutes>99)//foe more than 99 min show time in 3 digits
    {
        currentDuration.text=[NSString stringWithFormat:@"%03d:%02d",minutes,seconds];//for slider label time label
        
    }
    
    [animatedView addSubview:audioRecordSlider];
    
    [animatedView addSubview:uploadAudioButton];
    
    [animatedView addSubview:uploadLaterButton];
    
    [animatedView addSubview:recordNewButton];
    
    [animatedView addSubview:currentDuration];
    
    [animatedView addSubview:totalDuration];
    
    animatedView.backgroundColor=[UIColor whiteColor];
    
    [[self.view viewWithTag:701] setHidden:NO];
    
    [[self.view viewWithTag:702] setHidden:NO];
    
    [[self.view viewWithTag:703] setHidden:NO];
    
    [[self.view viewWithTag:704] setHidden:NO];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         animatedView.frame = CGRectMake(0, self.view.frame.size.height*0.6, self.view.frame.size.width, self.view.frame.size.height/2);
                     }
                     completion:^(BOOL finished){
                     }];
    [self.view addSubview:animatedView];

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
    int minutes=currentTime/60;
    int seconds=currentTime%60;
    
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

-(void)keepUpdatingSliderTimeWhileAudioPlaying:(UISlider*)sender
{
    playerDurationWithMilliSeconds = player.currentTime - 0.03;// to adjust accuracy and file compose failure;

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



-(void)uploadAudio:(UIButton*)sender
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
                        [player stop];
                        
                        [[self.view viewWithTag:701] setHidden:YES];
                        
                        [[self.view viewWithTag:702] setHidden:YES];
                        
                        [[self.view viewWithTag:703] setHidden:YES];
                        
                        [[self.view viewWithTag:704] setHidden:YES];

                        if (self.isOpenedFromAudioDetails)
                        {
                             [AppPreferences sharedAppPreferences].dismissAudioDetails = YES;// to dismiss audio details so that user will not be able to retransfer the audio
                        }
                       
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            [db updateAudioFileStatus:@"RecordingFileUpload" fileName:self.existingAudioFileName];
                            
                            
                            [app uploadFileToServer:self.existingAudioFileName jobName:FILE_UPLOAD_API];
                            
                            dispatch_async(dispatch_get_main_queue(), ^
                                                                  {
                                                                      sender.userInteractionEnabled=NO;
                                                                      
                                                                      deleteButton.userInteractionEnabled=NO;
                                                                      
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

-(void)ChangeDepartment
{
    
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
    CGRect frame=CGRectMake(10.0f, self.view.center.y-150, self.view.frame.size.width - 20.0f, 200.0f);
    
    UITableView* tab= [obj tableView:self frame:frame];
    
    [popupView addSubview:tab];
    
    [popupView setFrame:[[UIScreen mainScreen] bounds]];
    
    UIView *buttonsBkView = [[UIView alloc] initWithFrame:CGRectMake(tab.frame.origin.x, tab.frame.origin.y + tab.frame.size.height, tab.frame.size.width, 70.0f)];
    
    buttonsBkView.backgroundColor = [UIColor whiteColor];
    
    [popupView addSubview:buttonsBkView];
    
    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-200, 20.0f, 80, 30)];
    
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* saveButton=[[UIButton alloc]initWithFrame:CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+16, 20.0f, 80, 30)];
    
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    
    [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
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
    BOOL isExistingFileIsCaf = NO;
    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayAndRecord];
    
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
   
    NSError* error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    NSArray* originalFilePathComponents = [NSArray arrayWithObjects:
                                  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                  AUDIO_FILES_FOLDER_NAME,
                                  [NSString stringWithFormat:@"%@.caf",existingAudioFileName],
                                  nil];
       
    NSURL* originalFileURL = [NSURL fileURLWithPathComponents:originalFilePathComponents];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[originalFileURL path]]) {
        isExistingFileIsCaf = YES;
    }
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@copy.caf",recordedAudioFileName],
                               nil];
    
    recordedAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
    
     NSString* tempCopyPath = [[NSString stringWithFormat:@"%@",filePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@copy.caf",recordedAudioFileName]];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
      
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
       
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    if (!isExistingFileIsCaf) {
        pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   AUDIO_FILES_FOLDER_NAME,
                                   [NSString stringWithFormat:@"%@copy.wav",recordedAudioFileName],
                                   nil];
        
        recordedAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        tempCopyPath = [[NSString stringWithFormat:@"%@",filePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@copy.wav",recordedAudioFileName]];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
          
        [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
           
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    }
   
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempCopyPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:tempCopyPath error:&error];
    }
    // settings for the recorder
    
    
   
    
    // initiate recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedAudioURL settings:recordSetting error:&error];
    
    [recorder prepareToRecord];
    
}

-(void)startRecorderAfterPrepareed
{
    
    [recorder record];
    
}

-(void)prepareAudioPlayer
{
    
    if (!IMPEDE_PLAYBACK)
    {
        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryPlayback];
    }
    
    [recorder stop];
    
    NSError *audioError;
    
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@.caf", existingAudioFileName],
                               nil];
    
    
    playerAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[playerAudioURL path]])
    {
        pathComponents = [NSArray arrayWithObjects:
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
        AUDIO_FILES_FOLDER_NAME,
        [NSString stringWithFormat:@"%@.wav", existingAudioFileName],
        nil];
        
        playerAudioURL = [NSURL fileURLWithPathComponents:pathComponents];

    }
    
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:playerAudioURL error:&audioError];
    
    audioRecordSlider.maximumValue = player.duration;
    
    player.currentTime = audioRecordSlider.value;
    
    player.delegate = self;
    
    [player prepareToPlay];
    
}


-(void)playRecording
{
    
    circleViewTimerSeconds=0;
    
    circleViewTimerMinutes=0;
    
    int totalMinutes=  player.duration/60;
    
    int total=  player.duration;
    
    int totalSeconds= total%60;
    
    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",totalMinutes,totalSeconds];
    
    if (totalMinutes>99)//foe more than 99 min show time in 3 digits
    {
        currentDuration.text=[NSString stringWithFormat:@"%03d:%02d",totalMinutes,totalSeconds];//for slider label time label
    }
   
    [player play];
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player1 successfully:(BOOL)flag
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
    
    audioRecordSlider.value = player1.duration;
    int currentTime=player1.duration;
    int minutes=currentTime/60;
    int seconds=currentTime%60;
    currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
    totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label

    if (minutes>99)//foe more than 99 min show time in 3 digits
    {
        currentDuration.text=[NSString stringWithFormat:@"%03d:%02d",minutes,seconds];//for slider label time label
        
    }

    
   // [[self player] stop];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Error while decoding: %@", [error localizedDescription] );
}

#pragma mark: Audio composition and Compression Methods

-(void)setCompressAudio
{
    
    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
    
    NSString *source=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",existingAudioFileName]];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:source]){
        source=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",existingAudioFileName]];
    }
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if ([[source pathExtension] isEqualToString:@"caf"]) {
        destinationFilePath= [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@compressed.caf",existingAudioFileName]];
    }else{
        destinationFilePath= [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@compressed.wav",existingAudioFileName]];
    }
    
    
    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
    
    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
    
    NSError* erro;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAudioProcessing error:&erro];
    
    if (erro)
    {
        printf("Setting the AVAudioSessionCategoryAudioProcessing Category failed! %ld\n", (long)erro.code);
        
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];

        return;
    }
    
    [self convertAudio];
    
}

- (void)convertAudio
{

    
    NSError* error1;

      NSString* fileToRemovePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] ;
    
    if ([[destinationFilePath pathExtension] isEqualToString:@"wav"]) {
        
        fileToRemovePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
    }
    
  
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileToRemovePath])
               {
                    [[NSFileManager defaultManager] removeItemAtPath:fileToRemovePath error:&error1];
               }
      

        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self addAnimatedView];

                           [self prepareAudioPlayer];
                           
                           playerDurationWithMilliSeconds = player.duration - 0.03;// to adjust accuracy and file compose failure;
                           int currentTime= player.duration;
                           int minutes=currentTime/60;
                           int seconds=currentTime%60;
                           totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
                           currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
                           audioRecordSlider.value= player.duration;
                           currentDuration.text=[NSString stringWithFormat:@"%02d:%02d",minutes,seconds];//for slider label time label
                           [self hideHud];
                           
                           
                           [[self.view viewWithTag:701] setHidden:NO];
                           
                           [[self.view viewWithTag:702] setHidden:NO];
                                              
                           [[self.view viewWithTag:703] setHidden:NO];
                           
                           [[self.view viewWithTag:704] setHidden:NO];
                       });


}

-(void)composeAudio
{
    
    bsackUpAudioFileName = existingAudioFileName;
    
    AVMutableComposition* composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack* appendedAudioTrack =
    [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                             preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Grab the two audio tracks that need to be appended
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@.caf", self.existingAudioFileName],
                               nil];
    
    NSURL* existingFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[existingFileUrl path]]) {
        pathComponents = [NSArray arrayWithObjects:
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
        AUDIO_FILES_FOLDER_NAME,
        [NSString stringWithFormat:@"%@.wav", self.existingAudioFileName],
        nil];
        
        existingFileUrl = [NSURL fileURLWithPathComponents:pathComponents];

    }
    
    
    AVURLAsset* originalAsset = [[AVURLAsset alloc]
                                 initWithURL:existingFileUrl options:nil];
    AVURLAsset* newAsset = [[AVURLAsset alloc]
                            initWithURL:recordedAudioURL options:nil];
    
    NSError* error = nil;
    
    // Grab the first audio track and insert it into our appendedAudioTrack
    NSArray *originalTrack = [originalAsset tracksWithMediaType:AVMediaTypeAudio];
    
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
    
    // [appendedAudioTrack removeTimeRange:timeRange];
    if (error)
    {
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    // Grab the second audio track and insert it at the end of the first one
    NSArray *newTrack = [newAsset tracksWithMediaType:AVMediaTypeAudio];
    
    if (newTrack.count <= 0)
    {
        NSLog(@"error in new track of incomplete= %@", error.localizedFailureReason);
        NSLog(@"new asset duration = %f", CMTimeGetSeconds(newAsset.duration));
        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        [self setCompressAudio];
        return;
    }
    
    CMTime totalTime;
//    CMTime time;
    
    if ([editType isEqualToString:@"overWrite"])// if overwrite then get slider time, and insert new recording at slider position
    {
        
        if (updatedInsertionTime == 0)
        {
            float_t sliderValue = 0.0;
            
           
            sliderValue = playerDurationWithMilliSeconds;// to adjust accuracy and file compose failure;
            
            
            
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
                totalTime = [self getTotalCMTimeFromMilliSeconds:0];
                
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
            
          
            sliderValue = playerDurationWithMilliSeconds;// to adjust accuracy and file compose failure;
            
            
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
                totalTime = [self getTotalCMTimeFromMilliSeconds:0];
                
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
            
        }
        else
        {
             totalTime = originalAsset.duration;

        }
    
    
    
    timeRange = CMTimeRangeMake(kCMTimeZero, newAsset.duration);
    
    [appendedAudioTrack insertTimeRange:timeRange
                                ofTrack:[newTrack objectAtIndex:0]
                                 atTime:totalTime
                                  error:&error];
    
    if (error)
    {
        // do something
        NSLog(@"error in insertTimeRange of incomplete = %@", error.localizedDescription);

        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        return;
    }
    
    // Create a new audio file using the appendedAudioTrack
    
    AVAssetExportSession* exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    
    if (![[[existingFileUrl path] pathExtension] isEqualToString:@"caf"]) {
    exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetPassthrough];
        
    }
    if (!exportSession)
    {
        // do something
        
//        editType = nil;
        NSLog(@"error in exportSession of incomplete");

        [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        
        return;
    }
    
    float_t newTime = CMTimeGetSeconds(newAsset.duration);
    float_t oldTime = CMTimeGetSeconds(totalTime);
    
    //    updatedInsertionTime = CMTimeGetSeconds(time);
    updatedInsertionTime = newTime + oldTime;
    NSLog(@"new time = %f", newTime);
    NSLog(@"old time = %f", oldTime);
    
    //    NSLog(@"insertion time = %f", updatedInsertionTime);
    
    NSLog(@"insertion time = %f", updatedInsertionTime);
    
    NSString* destpath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
    
     NSString* outputUrlPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
    
    if (![[[existingFileUrl path] pathExtension] isEqualToString:@"caf"]) {
        
        destpath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
        
        outputUrlPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.wav",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
    }
    
    
   
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputUrlPath])
    {
        //if co.wav exist then remove to store new co.wav
        [[NSFileManager defaultManager] removeItemAtPath:outputUrlPath error:&error];
    }
    
    if ([[[existingFileUrl path] pathExtension] isEqualToString:@"caf"]) {
        exportSession.outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]]];//composed audio url,later on this will be deleted
        exportSession.outputFileType = AVFileTypeAppleM4A;

    }
    else{
        exportSession.outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.wav",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]]];//composed audio url,later on this will be deleted
        exportSession.outputFileType = AVFileTypeWAVE;

    }
    
    
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        // exported successfully?
        NSError* error;
        if (exportSession.status==AVAssetExportSessionStatusCompleted)
        {
            //first remove the existing file
            [[NSFileManager defaultManager] removeItemAtPath:destpath error:&error];
            //then move compossed file to existingAudioFile
            bool moved=  [[NSFileManager defaultManager] moveItemAtPath:outputUrlPath toPath:destpath error:&error];
            
//            editType = nil;

            if (moved)
            {
                
                //remove the recorded audio
                NSString* recordedAudioFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]];
                
                NSString* recordedCopyAudioFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.caf",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]];
                
                if (![[destpath pathExtension] isEqualToString:@"caf"]) {
                    recordedAudioFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]];
                    
                    recordedCopyAudioFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@copy.wav",AUDIO_FILES_FOLDER_NAME,recordedAudioFileName]];
                    
                }
                [[NSFileManager defaultManager] removeItemAtPath:recordedAudioFilePath error:&error];//delete first recorded file when view was appeared
                
                [[NSFileManager defaultManager] removeItemAtPath:recordedCopyAudioFilePath error:&error];//delete consecutive recorded files
                
                  dispatch_async(dispatch_get_main_queue(), ^
                                 {
                                     [self prepareAudioPlayer];
                                     
                                     [db updateAudioFileName:existingAudioFileName duration:player.duration];
                                     
                                     if (!IMPEDE_PLAYBACK)
                                     {
                                         [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
                                     }
                                    
                                     if (recordingStopped)
                                     {
                                         
                                         [self setCompressAudio];
                                         
                                         playerDurationWithMilliSeconds = player.duration - 0.03;// to adjust accuracy and file compose failure;
                                         
//                                         NSLog(@"duration = %f", player.duration);
                                         
                                          [db updateAudioFileName:existingAudioFileName duration:player.duration];
                                         
                                         if ([[NSUserDefaults standardUserDefaults] boolForKey:BACK_TO_HOME_AFTER_DICTATION])
                                         {
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }

                                     }
                                     else
                                     {
                                         [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
                                         
                                     }
                                 });
               
                
            }
            
        }
        if (exportSession.status==AVAssetExportSessionStatusFailed)
        {
//            editType = nil;
            
            (@"exportSession.error of incomplete= %@",exportSession.error.localizedDescription);

            [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
        }
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusFailed:
                
                NSLog(@"exportSession.error of incomplete= %@",exportSession.error.localizedDescription);

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
    
    //            NSLog(@"milliseconds = %f", milliSeconds);
    //
    //            NSLog(@"floor seconds = %lld", seconds);
    //
    //            NSLog(@"value = %lld", value);
    //
    //            NSLog(@"scale = %d", scale);
    
    //int64_t totalTrackDuration = player.duration;
    
    
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


-(void)updateAudioRecordToDatabase:(NSString*) status
{
       [db updateAudioFileName:existingAudioFileName dictationStatus:status];
    
}



#pragma mark:TableView Datasource and Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
    UILabel* tableViewDepartmentLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, self.view.frame.size.width - 60.0f, 18)];
    
    UIButton* radioButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 18, 18)];
    
    tableViewDepartmentLabel.text = [departmentNamesArray objectAtIndex:indexPath.row];
    
    tableViewDepartmentLabel.tag=indexPath.row+200;
    
    radioButton.tag=indexPath.row+100;
    

//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
//
//    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([existingAudioDepartmentName isEqualToString:tableViewDepartmentLabel.text])
    {
        
        [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        
    }
    else
        [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
    
    [cell addSubview:radioButton];
    
    [cell addSubview:tableViewDepartmentLabel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=[tableView cellForRowAtIndexPath:indexPath];
    
    UILabel* departmentNameLanel= [cell viewWithTag:indexPath.row+200];
    
    UIButton* radioButton=[cell viewWithTag:indexPath.row+100];
    
    existingAudioDepartmentName = departmentNameLanel.text;
    
    DepartMent *deptObj = [[DepartMent alloc]init];
    
    long deptId= [[[Database shareddatabase] getDepartMentIdFromDepartmentName:departmentNameLanel.text] longLongValue];
    
    deptObj.Id=deptId;
    
    deptObj.departmentName=departmentNameLanel.text;
    
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:deptObj];
    
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:SELECTED_DEPARTMENT_NAME];
    
    [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    
    [tableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {


        cell.backgroundColor = [UIColor whiteColor];

}
-(void)cancel:(id)sender
{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME_COPY];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:SELECTED_DEPARTMENT_NAME];
    
    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    existingAudioDepartmentName = deptObj.departmentName;
    
    [popupView removeFromSuperview];
}

-(void)save:(id)sender
{
    
    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
    
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:SELECTED_DEPARTMENT_NAME_COPY];
    
    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
    UILabel* transferredByLabel= [self.view viewWithTag:102];
    
    transferredByLabel.text=deptObj.departmentName;
    
    existingAudioDepartmentName = deptObj.departmentName;
    
    [[Database shareddatabase] updateDepartment:deptObj.Id fileName:self.existingAudioFileName];
    
    
    if (self.isOpenedFromAudioDetails)
    {
       NSDictionary* audiorecordDict = [app.awaitingFileTransferNamesArray objectAtIndex:self.selectedRowOfAwaitingList];
        
        [audiorecordDict setValue:deptObj.departmentName forKey:@"Department"];
        
        [app.awaitingFileTransferNamesArray replaceObjectAtIndex:self.selectedRowOfAwaitingList withObject:audiorecordDict];
    }
    
    [popupView removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark: Audio Editing Methods

- (IBAction)editAudioButtonClicked:(UIButton*)sender
{
    
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
                                                          dictationTimerSeconds = 0; // for save dictation waiting by
                                                          timerHour = audioHour;
                                                          timerMinutes = audioMinutes;
                                                          timerSeconds = audioSeconds;
                                                          
                                                          audioDurationLAbel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];//for circleView timer label;//for circleView timer label
                                                          
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
                                              totalSecondsOfAudio = audioRecordSlider.value;
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
                        
                            totalSecondsOfAudio = audioRecordSlider.value;
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
   // [sliderTimer invalidate];
    dictationTimerSeconds = 0;  // for save dictation waiting by timer value
    // backup: if get killed while saving the record
    AVMutableComposition* composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack* appendedAudioTrack =
    [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                             preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // Grab the two audio tracks that need to be appended
    NSArray* pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               AUDIO_FILES_FOLDER_NAME,
                               [NSString stringWithFormat:@"%@.caf", self.existingAudioFileName],
                               nil];
    
    NSURL* existingFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[existingFileUrl path]]) {
        
        pathComponents = [NSArray arrayWithObjects:
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
        AUDIO_FILES_FOLDER_NAME,
        [NSString stringWithFormat:@"%@.wav", self.existingAudioFileName],
        nil];
        
        existingFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
        
    }
    
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
    
    int64_t sliderValue = audioRecordSlider.value;
//    int64_t totalTrackDuration = player.duration;
//    CMTime time =   CMTimeMake(sliderValue, 1);
//    CMTime time1 =   CMTimeMake(totalTrackDuration, 1);
    NSLog(@"audiorecordslider deletetoend = %f", audioRecordSlider.value);
    
    NSLog(@"player duration deletetoend = %f", player.duration);

    CMTime time =   [self getTotalCMTimeFromMilliSeconds:audioRecordSlider.value];
    
    CMTime time1 =   [self getTotalCMTimeFromMilliSeconds:player.duration - audioRecordSlider.value];
    
    CMTimeRange timeRange = CMTimeRangeMake(time, time1);
    
    
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
            if (CMTimeGetSeconds(time)>=0) {
                playerDurationWithMilliSeconds = CMTimeGetSeconds(time);
            }
            
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       // [self prepareAudioPlayer];
                       
                       
                       long totalMinutes=sliderValue/60;
                       long total=  sliderValue;
                       int totalSeconds= total%60;
                       totalDuration.text=[NSString stringWithFormat:@"%02d:%02d",totalMinutes,totalSeconds];
                       
                       if (totalMinutes>99)//foe more than 99 min show time in 3 digits
                       {
                           totalDuration.text=[NSString stringWithFormat:@"%03d:%02d",totalMinutes,totalSeconds];//for slider label time label
                           
                       }
                       audioRecordSlider.maximumValue = total;
                       audioRecordSlider.value = total;
                       
                   });
    
    
    
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
    
    NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.caf",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
    
    NSString* exportSessionpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.caf",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
    
    exportSession.outputFileType = AVFileTypeAppleM4A;

    if ([[existingFileUrl pathExtension] isEqualToString:@"wav"]) {
        
        destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.wav",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
        
        exportSessionpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@co.wav",AUDIO_FILES_FOLDER_NAME,existingAudioFileName]];
        
        exportSession = [AVAssetExportSession
        exportSessionWithAsset:composition
        presetName:AVAssetExportPresetPassthrough];
        
        exportSession.outputFileType = AVFileTypeWAVE;

    }
    
    
    bool isremoved = [[NSFileManager defaultManager] removeItemAtPath:exportSessionpath error:&error];
    
    exportSession.outputURL = [NSURL fileURLWithPath:exportSessionpath];//composed audio url,later on this will be deleted
    // export.outputFileType = AVFileTypeWAVE;
    
    //    AVFileTypeAppleM4A
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        // exported successfully?
        NSError* error;
        if (exportSession.status==AVAssetExportSessionStatusCompleted)
        {
            //first remove the existing file
            [[NSFileManager defaultManager] removeItemAtPath:destpath error:&error];
            //then move compossed file to existingAudioFile
            bool moved=  [[NSFileManager defaultManager] moveItemAtPath:exportSessionpath toPath:destpath error:&error];
            
            
            if (moved)
            {
                //remove the composed file copy
                [[NSFileManager defaultManager] removeItemAtPath:exportSessionpath error:&error];
                
                
//                audioRecordSlider.value = audioRecordSlider.maximumValue;
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self prepareAudioPlayer];
                
                                   [self audioPlayerDidFinishPlaying:player successfully:true];
                               });
                //                [db updateAudioFileName:recordedAudioFileName duration:player.duration];
                if (!IMPEDE_PLAYBACK)
                {
                    [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
                }
                
                
                if ([editType isEqualToString:@"overWrite"] || [editType isEqualToString:@"insertInBetween"])
                {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       //NSLog(@"Reachable");
                                       if (!IMPEDE_PLAYBACK)
                                       {
                                           [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
                                       }
                                       
                                       int seconds = player.duration;
                                       
                                       int audioHour= seconds/(60*60);
                                       int audioHourByMod= seconds%(60*60);
                                       
                                       int audioMinutes = audioHourByMod / 60;
                                       int audioSeconds = audioHourByMod % 60;
                                       
                                       //int audioSeconds = (seconds) % 60;
                                       
                                       timerHour = audioHour;
                                       timerMinutes = audioMinutes;
                                       timerSeconds = audioSeconds;
                                       
                                       audioDurationLAbel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",audioHour,audioMinutes,audioSeconds];//for circleView timer label
                                       
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
                        dispatch_async(dispatch_get_main_queue(), ^
                                       {
                                           
                                           [db updateAudioFileName:existingAudioFileName duration:player.duration];
                                           [self.view setUserInteractionEnabled:YES];
                                       });
                        
                    }
                
            }
            
            
            
            
            
        }
        if (exportSession.status==AVAssetExportSessionStatusFailed)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.view setUserInteractionEnabled:YES];
                
            });
            [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
           
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


-(void)startNewRecordingForEdit
{
    [[self.view viewWithTag:98] removeFromSuperview];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    UIView* startRecordingView= [self.view viewWithTag:303];
    
    UIView* pauseRecordingView =  [self.view viewWithTag:302];
    
    UILabel* recordingStatusLabel= [self.view viewWithTag:99];
    
    UILabel* startLabel = [self.view viewWithTag:603];
    
    startLabel.text = @"Pause";
    
    //startLabel.textColor = [UIColor colorWithRed:250/255.0 green:162/255.0 blue:27/255.0 alpha:1];
    
    UIImageView* startRecordingImageView;
    
    animatedImageView= [self.view viewWithTag:1001];
    
    [animatedImageView setHidden:NO];
    
    UIView* stopRecordingView = [self.view viewWithTag:301];
    
    UILabel* stopRecordingLabel=[self.view viewWithTag:601];
    
    UILabel* pauseRecordingLabel=[self.view viewWithTag:602];
    
    UILabel* RecordingLabel=[self.view viewWithTag:603];
    
    [animatedImageView startAnimating];
    
    animatedImageView.image=[UIImage imageNamed:@"SoundWave-3"];
    
    [stopRecordingView setHidden:YES];
    
    [recordingStatusLabel setHidden:NO];

    
    recordingPausedOrStoped=YES;
    
    isRecordingStarted=NO;
    
    recordingStopped = NO;
    
    [stopRecordingView setHidden:NO];
    
    [pauseRecordingView setHidden:NO];
    
    [stopRecordingLabel setHidden:NO];
    
    [pauseRecordingLabel setHidden:NO];
    
    [RecordingLabel setHidden:NO];
    
    [audioDurationLAbel setHidden:NO];
    
    [stopNewImageView setHidden:NO];
    
    [stopNewButton setHidden:NO];
    
    [stopLabel setHidden:NO];
    
    [self audioRecord]; // prepare separate recorder for editing with different recording filename(i.e. editedCopy for compose purpose)
    
    startRecordingView.backgroundColor=[UIColor colorWithRed:110/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    
    recordingStatusLabel.text=@"Your audio is being recorded";
    
    double screenHeight =  [[UIScreen mainScreen] bounds].size.height;
    
    if (screenHeight<481)
    {
        animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x-10, stopNewImageView.frame.origin.y + stopNewImageView.frame.size.height + 30, recordingStatusLabel.frame.size.width+20, 15)];
    }
    else
        animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x-10, stopNewImageView.frame.origin.y + stopNewImageView.frame.size.height + 40, recordingStatusLabel.frame.size.width+20, 30)];
    
    UILabel* updatedrecordingStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(recordingStatusLabel.frame.origin.x, animatedImageView.frame.origin.y + animatedImageView.frame.size.height + 10, recordingStatusLabel.frame.size.width, 30)];
    
    updatedrecordingStatusLabel.text=@"Your audio is being recorded";
    
    updatedrecordingStatusLabel.textColor = [UIColor lightGrayColor];
    
    updatedrecordingStatusLabel.textAlignment = NSTextAlignmentCenter;
    
    updatedrecordingStatusLabel.font = [UIFont systemFontOfSize:18];
    
    animatedImageView.animationDuration = 1.0f;
    
    animatedImageView.animationRepeatCount = 0;
    
    [animatedImageView startAnimating];
    
    animatedImageView.userInteractionEnabled=YES;
    
    animatedImageView.tag=1001;
    
    isRecordingStarted=YES;
    
    recordingPausedOrStoped = NO;
    
    recordingPauseAndExit=NO;
    
    recordingPausedOrStoped=NO;
    
    startRecordingImageView= [startRecordingView viewWithTag:403];
    
    startRecordingImageView.image=[UIImage imageNamed:@"PauseNew"];
    
    startRecordingImageView  = [startRecordingView viewWithTag:403];
    
    [startRecordingImageView setFrame:CGRectMake((startRecordingView.frame.size.width/2)-9, (startRecordingView.frame.size.height/2)-18, 18, 36)];
    
    [self setTimer];
    
    [self mdRecord];
    
    if (self.isOpenedFromAudioDetails)
    {
        [AppPreferences sharedAppPreferences].dismissAudioDetails = YES;// to dismiss audio details so that user will not be able to retransfer the audio
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view setUserInteractionEnabled:YES];

    });
    [self updateAudioRecordToDatabase:@"RecordingPause"];


    
}

//
//-(void)editRecord
//{    
//    if (!IMPEDE_PLAYBACK)
//    {
//        [AudioSessionManager setAudioSessionCategory:AVAudioSessionCategoryRecord];
//    }
//    NSString* filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]];
//    NSError* error;
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//    
//    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@editedCopy.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]] error:nil];
//    
//    NSArray* pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               AUDIO_FILES_FOLDER_NAME,
//                               [NSString stringWithFormat:@"%@editedCopy.wav", self.recordedAudioFileName],
//                               
//                               nil];
//    NSString* backUpPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@editedCopy.wav",AUDIO_FILES_FOLDER_NAME,self.recordedAudioFileName]];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:backUpPath]) {
//        [[NSFileManager defaultManager] removeItemAtPath:backUpPath error:nil];
//    }
//    self.recordedAudioURL = [NSURL fileURLWithPathComponents:pathComponents];
//    
//    // settings for the recorder
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];//kAudioFormatLinearPCM
//    [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];//8000
//    
//    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
//    
//    recorder = [[AVAudioRecorder alloc] initWithURL:self.recordedAudioURL settings:recordSetting error:&error];
//    [recorder prepareToRecord];
//    
//}


- (void) mdRecord
{
    [recorder record];
    
}

-(void)updateDictationStatus:(NSString*)dictationStatus
{
    
//    NSArray* pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               AUDIO_FILES_FOLDER_NAME,
//                               [NSString stringWithFormat:@"%@.wav", existingAudioFileName],
//                               nil];
//    self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self prepareAudioPlayer];

        [[Database shareddatabase] updateAudioFileName:existingAudioFileName dictationStatus:dictationStatus];
        
        [db updateAudioFileName:existingAudioFileName duration:player.duration];
        
    });
    
}

@end
