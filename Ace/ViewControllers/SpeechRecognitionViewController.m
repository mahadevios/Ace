//
//  SpeechRecognitionViewController.m
//  Ace
//
//  Created by mac on 24/11/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import "SpeechRecognitionViewController.h"
#import "SelectFileViewController.h"
#import "UIColor+ApplicationColors.h"
#import "Database.h"
#import "APIManager.h"
#import "AppPreferences.h"
#import "Constants.h"
#import "DocFileDetails.h"
#import "PopUpCustomView.h"

@interface SpeechRecognitionViewController ()

@end

@implementation SpeechRecognitionViewController
@synthesize audioEngine,request,recognitionTask,speechRecognizer,isStartedNewRequest, transcriptionStatusView,timerSeconds,startTranscriptionButton,stopTranscriptionButton,timerLabel,transcriptionStatusLabel,transcriptionTextLabel,audioFileName,transFIleImageVIew,transStopImageView,transRecordImageView,startLabel,stopLabel,docFileLabel,docFileButton,alertController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.transcriptionTextLabel.lineBreakMode = NSLineBreakByWordWrapping;

    self.previousTranscriptedArray = [NSMutableArray new]; // store one minute text to append next request
    
    [self.previousTranscriptedArray addObject:@""];
    
    
    NSError* error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error];

    audioEngine = [[AVAudioEngine alloc] init];
    
    NSString* vrsLocale = [[NSUserDefaults standardUserDefaults] objectForKey:VRS_LOCALE];

    if (vrsLocale == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"en-GB" forKey:VRS_LOCALE];
        
        self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-GB"];
        
        self.localeLabel.text = @"en-GB";

    }
    else
    {
        self.locale = [[NSLocale alloc] initWithLocaleIdentifier:vrsLocale];

        self.localeLabel.text = vrsLocale;

    }
    
    
    speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:self.locale];
    
    request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    NSDictionary *audioCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                            [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                                                                            [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                                                                            [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                                                                            [NSNumber numberWithInt:128000], AVEncoderBitRateKey,
                                                                                             nil];
    
    NSURL* url = [self urlForFile:@"top1.wav"];
    
    audioFileName = [[AVAudioFile alloc] initForWriting:url settings:audioCompressionSettings error:nil];

    self.navigationItem.title = @"Speech Transcription(Beta)";
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    
    [self.tabBarController.tabBar setHidden:NO];

    self.navigationItem.hidesBackButton = true;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopVRSFromBackGround) name:NOTIFICATION_PAUSE_RECORDING
                                               object:nil];
    
    [self disableStopAndDocOption];

}
-(void)viewWillAppear:(BOOL)animated
{

    [self addTranscriptionStatusAnimationView];
    
    self.timerSeconds = 59;
    
    self.transcriptionTextView.translatesAutoresizingMaskIntoConstraints = true;
    [self.transcriptionTextView sizeToFit];
    self.transcriptionTextView.scrollEnabled = false;
    
    if (!isViewAppearedFirstTime)
    {
        self.transcriptionTextView.text = @"";

        isViewAppearedFirstTime = true;
    }

    self.tabBarController.tabBar.hidden = true;
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    
    self.transcriptionTextView.delegate = self;
}

-(void)stopVRSFromBackGround
{
    if (isTranscripting == true)
    {
        [self stopLiveAudioTranscription:nil];

    }
}
-(void)disableStopAndDocOption
{
    docFileLabel.alpha = 0.5;
    
    transFIleImageVIew.alpha = 0.5;
    
    [docFileButton setEnabled:false];
    
    
    stopLabel.alpha = 0.5;
    
    transStopImageView.alpha = 0.5;
    
    [stopTranscriptionButton setEnabled:false];
}

-(void)disableStartAndDocOption:(BOOL)disable
{
    if (disable == true)
    {
        transRecordImageView.alpha = 0.5;
        
        startLabel.alpha = 0.5;  //enable color
        
        [startTranscriptionButton setEnabled:false];
        
        
        [docFileButton setEnabled:false];
        
        transFIleImageVIew.alpha = 0.5;
        
        docFileLabel.alpha = 0.5;
    }
    else
    {
        transRecordImageView.alpha = 1.0;
        
        startLabel.alpha = 1.0;  //enable color
        
        [startTranscriptionButton setEnabled:true];
        
        
        [docFileButton setEnabled:true];
        
        transFIleImageVIew.alpha = 1.0;
        
        docFileLabel.alpha = 1.0;
    }
    
}

-(void)enableStopOption:(BOOL)enable
{
    if (enable == true)
    {
        self.transcriptionTextView.userInteractionEnabled = false;
        
        [stopTranscriptionButton setEnabled:true];
        
        transStopImageView.alpha = 1.0;
        
        stopLabel.alpha = 1.0;
    }
    else
    {
        self.transcriptionTextView.userInteractionEnabled = true;

        [stopTranscriptionButton setEnabled:false];
        
        transStopImageView.alpha = 0.5;
        
        stopLabel.alpha = 0.5;
    }
    
}

-(void)demoTimer
{
    demoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkState) userInfo:nil repeats:YES];
    
}
-(void)checkState
{
    NSLog(@"state is = %ld", (long)recognitionTask.state);
}


-(void)resetTranscription
{
    [self disableStopAndDocOption];

    [self startTranscriptionStatusViewAnimationToDown:false]; // animate trans status to upperside
    
    [startTranscriptionButton setTitle:@"Start Transcription" forState:UIControlStateNormal]; // chnage title dont remove this

    transRecordImageView.image = [UIImage imageNamed:@"TransRecord"];
    
    startLabel.text = @"Start";
    
    startTranscriptionButton.alpha = 1.0;
    
    [startTranscriptionButton setEnabled:true];
    
    isStartedNewRequest = false;
    
//    transcriptionTextLabel.text = @"";
    self.transcriptionTextView.text = @"";

    timerSeconds = 59;
    
    if (self.capture != nil && [self.capture isRunning])
    {
        [self.capture stopRunning];
    }
    
    [audioEngine stop];
    
    [request endAudio];

    //[recognitionTask cancel];
    
    [newRequestTimer invalidate];
    
    transcriptionStatusLabel.text = @"Go ahead, I'm listening!";
    
    timerLabel.text = @"00:59";

    [self.previousTranscriptedArray removeAllObjects]; // remove  prev. trans. text
    
    [self.previousTranscriptedArray addObject:@""];
    
//    [self hideRightBarButton:true];

}

-(void)hideRightBarButton:(BOOL)hide
{
    
    if (hide == true)
    {
//        [self.selectLocaleButton setEnabled:false];
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TransReset"] style:UIBarButtonItemStylePlain target:self action:@selector(resetTranscription)];

    }
    
}


-(void)addTranscriptionStatusAnimationView
{
    UIView* keyWindow = [UIApplication sharedApplication].keyWindow;
    
   
    transcriptionStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, -70, self.view.frame.size.width, 55)];
    
    transcriptionStatusView.tag = 3000;
    
   
    transcriptionStatusView.layer.cornerRadius = 4.0;
    
    transcriptionStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(transcriptionStatusView.frame.size.width*0.05, 10, transcriptionStatusView.frame.size.width*0.9, 30)];
    
    transcriptionStatusLabel.font = [UIFont systemFontOfSize:15];
    
    transcriptionStatusLabel.text = @"Go ahead, I'm listening!";
    
    transcriptionStatusLabel.textAlignment = NSTextAlignmentCenter;
    
    transcriptionStatusLabel.textColor = [UIColor whiteColor];
//    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(transcriptionStatusLabel.frame.origin.x, transcriptionStatusLabel.frame.origin.y+transcriptionStatusLabel.frame.size.height, transcriptionStatusLabel.frame.size.width, 50)];

    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(transcriptionStatusLabel.frame.origin.x, 35, transcriptionStatusLabel.frame.size.width, 20)];
    timerLabel.text = @"00:59";
    
    timerLabel.font = [UIFont systemFontOfSize:15];

    timerLabel.textAlignment = NSTextAlignmentCenter;
    
    timerLabel.textColor = [UIColor whiteColor];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        transcriptionStatusView.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height + 20, self.view.frame.size.width*0.8, 60);  // set animate view at bottom+20 of the view
        
        timerLabel.frame = CGRectMake(transcriptionStatusLabel.frame.origin.x, 35, transcriptionStatusLabel.frame.size.width, 55);
        
        transcriptionStatusView.backgroundColor = [UIColor whiteColor];
        
        self.startPauseDocBGView.layer.cornerRadius = 4.0;
        
        transcriptionStatusLabel.textColor = [UIColor whiteColor];
        
        timerLabel.textColor = [UIColor whiteColor];
        
        transcriptionStatusLabel.font = [UIFont systemFontOfSize:21];

        timerLabel.font = [UIFont systemFontOfSize:25];

    }
    else
    {
        transcriptionStatusView.backgroundColor = [UIColor appOrangeColor];
        
    }
    
    [transcriptionStatusView addSubview:transcriptionStatusLabel];
    
    [transcriptionStatusView addSubview:timerLabel];
    
    
    [keyWindow addSubview:transcriptionStatusView];
    
}

-(void)startTranscriptionStatusViewAnimationToDown:(BOOL)moveDown
{

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        
        //            self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.09, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);
        int moveDownDistance;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            if (moveDown == true)
            {
                moveDownDistance = -110;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.startPauseDocBGView.backgroundColor = [UIColor appOrangeColor];

                });
            }
            else
            {
                moveDownDistance = 110;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                    self.transcriptionStatusView.frame = CGRectMake(0, self.view.frame.size.height + moveDownDistance, self.view.frame.size.width, 55);
            });
            
        }
        else
        {
            if (moveDown == true)
            {
                moveDownDistance = 15;
            }
            else
            {
                moveDownDistance = -70;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.transcriptionStatusView.frame = CGRectMake(0, moveDownDistance, self.view.frame.size.width, 65);
            });
            
        }
       
       
        
    } completion:^(BOOL finished) {
        
        timerLabel.text = @"00:59";
    }];
}

-(void)popViewController:(id)sender
{
    if (isTranscripting)
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Transcripting.." withMessage:@"Please stop the transcription" withCancelText:@"Ok" withOkText:nil withAlertTag:1000];
    }
//    else if (transcriptionTextLabel.text.length>0)
    else if (self.transcriptionTextView.text.length>0)
    {
        alertController = [UIAlertController alertControllerWithTitle:@"Transcription not saved!"
                                                              message:@"Save transcription as text file?"
                                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* actionCreate = [UIAlertAction actionWithTitle:@"Save"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           
                                           [self createSubDocFileButtonClicked];
                                       }]; //You can use a block here to handle a press on this button
        
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Don't save"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           //                                           [self.navigationController.tabBarController setSelectedIndex:0];
                                           

                                           [transcriptionStatusView removeFromSuperview];
                                           
                                           [self dismissViewControllerAnimated:true completion:nil];
                                           
                                           //                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
        
        [alertController addAction:actionCreate];
        
        [alertController addAction:actionCancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        //                [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:true completion:nil];
        //        [self.navigationController.tabBarController setSelectedIndex:0];
        
    }
    
}
- (IBAction)backButtonPressed:(id)sender
{
    [self popViewController:sender];
}

- (IBAction)startLiveAudioTranscription:(UIButton*)sender
{
    
    if ([[sender titleForState:UIControlStateNormal]  isEqual: @"Start Transcription"] || [[sender titleForState:UIControlStateNormal]  isEqual: @"Resume"])
    {
        if ([[AppPreferences sharedAppPreferences] isReachable])
        {
            //self.stopTranscriptionButton.hidden = false;
            
            [UIApplication sharedApplication].idleTimerDisabled = YES;

            [self.transcriptionTextView resignFirstResponder];
            
            isTranscripting = true;
            
            [newRequestTimer invalidate];
            
            [self disableStartAndDocOption:true];
            
            [self enableStopOption:true];
            
            if ([[sender titleForState:UIControlStateNormal]  isEqual: @"Resume"])
            {
                isStartedNewRequest = true; // set true for resume and using dis append text in delegate
                
                timerSeconds = 59;  // reset after resume

            }

            
            [self authorizeAndTranscribe:sender];
            
            
            transcriptionStatusLabel.text = @"Go ahead, I'm listening";
            
            [self.backButton setUserInteractionEnabled:NO];
            
            [self.selectLocaleButton setUserInteractionEnabled:NO];
            
        }
        else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your internet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    else
    if ([[sender titleForState:UIControlStateNormal]  isEqual: @"Transcript File"])

    {
        if ([[AppPreferences sharedAppPreferences] isReachable])
        {
            [self authorizeAndTranscribe:sender];
        
        }
        else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your internet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
       
    }
    else
    {
        SelectFileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFileViewController"];
        
        vc.delegate = self;
        
         vc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
        
    
    
}

- (IBAction)stopLiveAudioTranscription:(id)sender
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    [self subStopLiveAudioTranscription];
    
    timerSeconds = 59;
 
}

-(void)subStopLiveAudioTranscription
{

    [self disableStartAndDocOption:false];
    
    [self enableStopOption:false];
    
    [startTranscriptionButton setTitle:@"Resume" forState:UIControlStateNormal];

    transRecordImageView.image = [UIImage imageNamed:@"TransResume"];
    
    startLabel.text = @"Resume";
    
    if (self.capture != nil && [self.capture isRunning])
    {
        [self.capture stopRunning];
    }
    
    [audioEngine stop];
    
    [request endAudio];

    [self startTranscriptionStatusViewAnimationToDown:false];   //remove animation
    
    audioFileName = nil; // to save the recorded file
    
    [self.backButton setUserInteractionEnabled:YES];
    
    [self.selectLocaleButton setUserInteractionEnabled:YES];

}

- (IBAction)segmentChanged:(UISegmentedControl*)sender
{
//    if(sender.selectedSegmentIndex == 0)
//    {
//        self.stopTranscriptionButton.hidden = true;
//        self.fileNameLabel.hidden = false;
//        [self.startTranscriptionButton setTitle:@"Select File" forState:UIControlStateNormal];
//
//    }
//    else
//    {
        self.stopTranscriptionButton.hidden = false;
      //  self.fileNameLabel.hidden = true;
      //  [self.startTranscriptionButton setTitle:@"Start Transcription" forState:UIControlStateNormal];
        
   // }
}


-(void) transcribeLiveAudio
{    

    [request endAudio];
    
    [recognitionTask cancel];
    
    recognitionTask = nil;
// with delegate
    request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];


    dispatch_async(dispatch_get_main_queue(), ^{

       
        //[self startCapture];
        [self recordUsingTap];
        [self startTranscriptionStatusViewAnimationToDown:true];
        [self setTimer];
        //[self demoTimer];
        
        speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:self.locale];

        recognitionTask = [speechRecognizer recognitionTaskWithRequest:self.request delegate:self];

    });
    

    
    //request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    


}

//-(void)createTaskRequest
//{
//    request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
//
//    recognitionTask = [speechRecognizer recognitionTaskWithRequest:request delegate:self];
//
//}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    [self.request appendAudioSampleBuffer:sampleBuffer];
    
//    NSError* error;
//    bool isWr = [audioFileName writeFromBuffer:sampleBuffer error:&error];
//
//    [self.request appendAudioPCMBuffer:sampleBuffer];
    
//    if (timerSeconds == 1)
//    {
 //       audioFileName = nil;
//    }
//    NSError* error;
//
//    NSURL* audioExportURL = [self urlForFile:@"sample234.m4a"];
//    AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:audioExportURL fileType:AVFileTypeAppleM4A error:&error];
//
//    AudioChannelLayout channelLayout;
//    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
//    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
//    NSDictionary *audioCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
//                                              [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
//                                              [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
//                                              [NSNumber numberWithInt:128000], AVEncoderBitRateKey,
//                                               nil];
//
//    AVAssetWriterInput *writerAudioInput;
//
//
//
//    writerAudioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:audioCompressionSettings];
//
//    writerAudioInput.expectsMediaDataInRealTime = YES;
//
//    if ([writer canAddInput:writerAudioInput]) {
//        [writer addInput:writerAudioInput];
//    } else {
//        NSLog(@"ERROR ADDING AUDIO");
//    }
//
//    [writer startWriting];
//
//    CMTime time = kCMTimeZero;
//
//    [writer startSessionAtSourceTime:time];
//
//    if([writerAudioInput isReadyForMoreMediaData])
//    {
//       bool isAppended = [writerAudioInput appendSampleBuffer:sampleBuffer];
//
//        NSLog(@"%d",isAppended);
//    }
//    AVAssetWriterStatus status = [writer status];
//
//    NSLog(@"%@", writer.error.localizedFailureReason);
//    NSLog(@"%@", writer.error.localizedDescription);
//
//    NSLog(@"%ld",status);

}


-(void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task
{
    
}

-(void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task
{
   
}

-(void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task
{
  
    
    [[AppPreferences sharedAppPreferences] showHudWithTitle:@"Transcribing.." detailText:@"Please wait"];
    
}

-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully
{
  
    
    isTranscripting = false;

    [recognitionTask cancel];
    
    [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
    
    [self.previousTranscriptedArray replaceObjectAtIndex:0 withObject: self.transcriptionTextView.text];

    [self disableStartAndDocOption:false];
    
    isTrancriptFirstTimeFirstWord = false;
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"sample" object:nil];//to pause and remove audio player

}

-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult
{
   
   
    if(recognitionResult.isFinal)
    {
         [recognitionTask cancel];
        
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

        [self.backButton setUserInteractionEnabled:YES];
        
        [self.selectLocaleButton setUserInteractionEnabled:YES];
    }
   
}

-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription
{
  
    
    if (transcription != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
//                           if (isStartedNewRequest == true) // if resume
//                           { // if it is a start of a new request(resume) then get the existing text and allocate that text to label
//                               if (!isTrancriptFirstTimeFirstWord)
//                               {
//                                   isTrancriptFirstTimeFirstWord = true;
//
//                                   firstTimeManuallyEnteredText = self.transcriptionTextView.text;
//
//                                   NSLog(@"1");
//                                   NSLog(@"1 firstTimeManuallyEnteredText = %@", firstTimeManuallyEnteredText);
//                                   NSLog(@"1 transcription.formattedString = %@", transcription.formattedString);
//
//                                   self.transcriptionTextView.text = [firstTimeManuallyEnteredText stringByAppendingString:[NSString stringWithFormat:@" %@",transcription.formattedString]];
//
//                                   NSLog(@"1 addition = transcription.formattedString = %@", self.transcriptionTextView.text);
//
//                                   [self.previousTranscriptedArray replaceObjectAtIndex:0 withObject:self.transcriptionTextView.text];
//
//                               }
//                               else
//                               {
//                                   NSString* text = [self.previousTranscriptedArray objectAtIndex:0];
//
//                                   NSLog(@"2");
//                                   NSLog(@"2 text = %@", text);
//                                   NSLog(@"2 transcription.formattedString = %@", transcription.formattedString);
//
//                                   self.transcriptionTextView.text = [text stringByAppendingString:[NSString stringWithFormat:@" %@",transcription.formattedString]];
//
//                                   NSLog(@"2 addition = transcription.formattedString = %@", self.transcriptionTextView.text);
//
//                               }
//
//
//                           }
//                           else
//                           { // for first time when clicked on start and not on resume
                           
                               if (!isTrancriptFirstTimeFirstWord)
                               {
                                   firstTimeManuallyEnteredText = self.transcriptionTextView.text;
                               
                                  [self.previousTranscriptedArray replaceObjectAtIndex:0 withObject:transcription.formattedString];
                                   
                                   self.transcriptionTextView.text =  [NSString stringWithFormat:@"%@ %@", firstTimeManuallyEnteredText, [self.previousTranscriptedArray objectAtIndex:0]];
                                   
                                   isTrancriptFirstTimeFirstWord = true;
                               }
                               else
                               {
                                   [self.previousTranscriptedArray replaceObjectAtIndex:0 withObject:transcription.formattedString];

                                   self.transcriptionTextView.text =  [NSString stringWithFormat:@"%@ %@", firstTimeManuallyEnteredText, [self.previousTranscriptedArray objectAtIndex:0]];
                               }
                            
                               
                               
//                           }
                           
                       
                           
                           CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
                           
                           CGSize expectedLabelSize = [self.transcriptionTextView.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
                           
//                           CGSize customizeExpectedLabelSize = expectedLabelSize;
                           expectedLabelSize.height = expectedLabelSize.height + 70;
                           expectedLabelSize.width = self.view.frame.size.width * 0.95;

                           self.scrollVIew.contentSize = expectedLabelSize;
                           
                           self.transcriptionTextView.contentSize = expectedLabelSize;
                           
                           CGRect frame = self.transcriptionTextView.frame;
                           frame.size.height = self.transcriptionTextView.contentSize.height;
                           frame.size.width = self.view.frame.size.width * 0.95;

                           self.transcriptionTextView.frame = frame;

                       });
    }
}





-(void)authorizeAndTranscribe:(UIButton*)sender
{
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status)
            {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    
                    
                    
//                    if ([[sender titleForState:UIControlStateNormal]  isEqual: @"Start Transcription"] || [[sender titleForState:UIControlStateNormal]  isEqual: @"Resume"])
//                    {
                        //[self transcribePreRecordedAudio];
                        [self transcribeLiveAudio];
                        
//                    }
//                    else
//                        if ([[sender titleForState:UIControlStateNormal]  isEqual: @"Transcript File"])
//                        {
//                            //                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            [self transcribePreRecordedAudio];
//
//                            //                        });
//                        }
//
                    
                    
                    //[self transcribePreRecordedAudio];
                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    
                    break;
                default:
                    break;
            }
        });
    }];
    
}

-(void)setTimer
{
    newRequestTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    
}

-(void)updateTime:(id) sender
{
    if ([AppPreferences sharedAppPreferences].isReachable)
    {
        if (timerSeconds == -10)
        {
            isTranscripting = false;
            
            [recognitionTask cancel];
            
            [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
        }
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                           
                           if (timerSeconds == 0)
                           {
                               
                               [recognitionTask isFinishing];
                               
                               [self subStopLiveAudioTranscription];
                               
                               [recognitionTask finish];
                               
                               [startTranscriptionButton setTitle:@"Resume" forState:UIControlStateNormal];
                               
                               transRecordImageView.image = [UIImage imageNamed:@"TransResume"];
                               
                               startLabel.text = @"Resume";
                               
                               transcriptionStatusLabel.text = @"Press Resume to continue";
                               
                               audioFileName = nil; // to save the recorded file
                               
                           }
                           else
                           {
                               
                               --timerSeconds;
                               
                               timerLabel.text = [NSString stringWithFormat:@"00:%02d",timerSeconds];
                           }
                           
                       });
        
    }
    else
    {
        [newRequestTimer invalidate];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:NO_INTERNET_TITLE_MESSAGE withMessage:NO_INTERNET_DETAIL_MESSAGE withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        
        [self stopLiveAudioTranscription:nil];
    }
   
   
    
}


- (void)startCapture
{
    NSError *error;
    self.capture = [[AVCaptureSession alloc] init];
    AVCaptureDevice *audioDev = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (audioDev == nil){
        NSLog(@"Couldn't create audio capture device");
        return ;
    }
    
    // create mic device
    AVCaptureDeviceInput *audioIn = [AVCaptureDeviceInput deviceInputWithDevice:audioDev error:&error];
    if (error != nil){
        NSLog(@"Couldn't create audio input");
        return ;
    }
    
    // add mic device in capture object
    if ([self.capture canAddInput:audioIn] == NO){
        NSLog(@"Couldn't add audio input");
        return ;
    }
    [self.capture addInput:audioIn];
    // export audio data
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [audioOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    if ([self.capture canAddOutput:audioOutput] == NO){
        NSLog(@"Couldn't add audio output");
        return ;
    }
    [self.capture addOutput:audioOutput];
    [audioOutput connectionWithMediaType:AVMediaTypeAudio];

    [self.capture startRunning];
}


-(void)setFileName:(NSString *)fileName
{
    //self.fileNameLabel.text = fileName;
    
    [self.startTranscriptionButton setTitle:@"Transcript File" forState:UIControlStateNormal];
    
}

-(void)recordUsingTap
{
    AVAudioInputNode* inputNode = audioEngine.inputNode;
    
    [inputNode removeTapOnBus:0];
    
    [inputNode installTapOnBus:0 bufferSize:2048 format:[inputNode inputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when)
     {
         
         if (buffer == nil)
         {
             [recognitionTask cancel];
         }
         [self.request appendAudioPCMBuffer:buffer];
         
     }];
    
    [audioEngine prepare];
    
    NSError* error;
    
    [audioEngine startAndReturnError:&error];
    
}

-(NSURL*)urlForFile:(NSString*)fileName
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSURL* url = [NSURL fileURLWithPath:filePath];
    
    return url;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createDocFileButtonClicked:(id)sender
{
//    if (transcriptionTextLabel.text.length < 1)
    if (self.transcriptionTextView.text.length < 1)

    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:@"Transcription text is empty" withCancelText:@"Cancel" withOkText:@"Ok" withAlertTag:1000];
    }
    else
    {
        alertController = [UIAlertController alertControllerWithTitle:@"Create Text File?"
                                                              message:@"Are you sure you want to create a text file?"
                                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* actionCreate = [UIAlertAction actionWithTitle:@"Create"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        
                        [self createSubDocFileButtonClicked];
                    }]; //You can use a block here to handle a press on this button
        
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action)
                                       {
                                           
                                       }];
        
        [alertController addAction:actionCreate];
        
        [alertController addAction:actionCancel];

        [self presentViewController:alertController animated:YES completion:nil];
    
    }
       
    
}

-(void)createSubDocFileButtonClicked
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                       BOOL isWritten = [self createDocFile];
                       
                       if (isWritten == true)
                       {
                           [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Text File Created" withMessage:@"Text file created successfully." withCancelText:@"Ok" withOkText:nil withAlertTag:1000];
                           
                           [self resetTranscription];
                       }
                       
                   });
    
}

-(BOOL)createDocFile
{
    long todaysSerialNumberCount;
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* todaysDate = [dateFormatter stringFromDate:[NSDate new]];
    
    NSString* storedTodaysDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"TodaysDateForVSR"];
    
    
    if ([todaysDate isEqualToString:storedTodaysDate])
    {
        todaysSerialNumberCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"todaysDocSerialNumberCount"] longLongValue];
        
        todaysSerialNumberCount++;
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",todaysSerialNumberCount] forKey:@"todaysDocSerialNumberCount"];

    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:todaysDate forKey:@"TodaysDateForVSR"];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"todaysDocSerialNumberCount"];
        NSString* countString=[[NSUserDefaults standardUserDefaults] valueForKey:@"todaysDocSerialNumberCount"];
        todaysSerialNumberCount = [countString longLongValue];
        
        todaysSerialNumberCount++;
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",todaysSerialNumberCount] forKey:@"todaysDocSerialNumberCount"];

    }
    
    todaysDate=[todaysDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString* fileNamePrefix;
    
    fileNamePrefix=[[NSUserDefaults standardUserDefaults] valueForKey:@"FileNamePrefix"];
    
    NSString* docFileName=[NSString stringWithFormat:@"%@%@-%02ldVRS",fileNamePrefix,todaysDate,todaysSerialNumberCount];
    
    BOOL isWritten = [self checkAndCreateDocFile:docFileName];
    
    if (isWritten == true)
    {
        DocFileDetails* docFileDetails = [DocFileDetails new];
        
        docFileDetails.docFileName = docFileName;
        
        docFileDetails.audioFileName = docFileName;
        
        docFileDetails.uploadStatus = NOUPLOAD;
        
        docFileDetails.deleteStatus = NODELETE;
        
        docFileDetails.createdDate = [[APIManager sharedManager] getDateAndTimeString];
        
        docFileDetails.uploadDate = @"";
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];
        DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        docFileDetails.departmentName = deptObj.departmentName;
        
       
        
        [[Database shareddatabase] addDocFileInDB:docFileDetails];
    }
    
    return isWritten;

}

-(BOOL)checkAndCreateDocFile:(NSString*)docFileName
{
    NSError* error;
    
    NSString* folderPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:DOC_VRS_FILES_FOLDER_NAME]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    NSString* docFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",DOC_VRS_FILES_FOLDER_NAME,docFileName]];
    
    docFilePath = [docFilePath stringByAppendingFormat:@".txt"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:docFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:docFilePath error:nil];
    }
    
//    BOOL isWritten1 = [[self.transcriptionTextLabel.text dataUsingEncoding:NSUTF8StringEncoding] writeToFile:docFilePath atomically:true];
    BOOL isWritten1 = [[self.transcriptionTextView.text dataUsingEncoding:NSUTF8StringEncoding] writeToFile:docFilePath atomically:true];

    return isWritten1;
}


- (IBAction)selectLocaleButtonClicked:(UIButton*)sender
{
    NSArray* subViewArray;
    
    double popViewHeight;
    double popViewWidth = 160;

    subViewArray=[NSArray arrayWithObjects:@"Select Locale",@"English (Great Britain)",@"English (USA)",@"English (India)",@"English (Australia)", nil];

    popViewHeight = 205; // 41 for each including top and bottom space

    double navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    double popUpViewXPosition = self.view.frame.size.width - popViewWidth;
    double popUpViewYPosition = navigationBarHeight + 20;
    
    UIView* overlayView = [[PopUpCustomView alloc]initWithFrame:CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight) andSubViews:subViewArray :self];
    
    UIView* popUpView = [overlayView viewWithTag:561];
    
    popUpView.frame = CGRectMake(popUpViewXPosition+(popViewWidth/2), popUpViewYPosition, 0, 0);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:overlayView];
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        
        
        popUpView.frame = CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)dismissPopView:(id)sender
{
    
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
}

-(void)EnglishGreatBritain
{
    self.localeLabel.text = @"en-GB";

    [[NSUserDefaults standardUserDefaults] setObject:self.localeLabel.text forKey:VRS_LOCALE];

    self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-GB"];

    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }

}

-(void)EnglishUSA
{
    self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];

    self.localeLabel.text = @"en-US";

    [[NSUserDefaults standardUserDefaults] setObject:self.localeLabel.text forKey:VRS_LOCALE];

    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }

}

-(void)EnglishIndia
{
    self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-IN"];

    self.localeLabel.text = @"en-IN";

    [[NSUserDefaults standardUserDefaults] setObject:self.localeLabel.text forKey:VRS_LOCALE];

    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }
    
}

-(void)EnglishAustralia
{
    self.localeLabel.text = @"en-AU";
    
    self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-AU"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.localeLabel.text forKey:VRS_LOCALE];

    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }
    
}

-(void)SelectLocale
{
    
    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    if ([popUpView isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }

}

-(void) transcribePreRecordedAudio
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
    
    filePath = [filePath stringByAppendingPathExtension:@"m4a"];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                       NSURL* url = [[NSURL alloc] initFileURLWithPath:filePath];
                       
                       self.urlRequest = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
                       
                       
                       [speechRecognizer recognitionTaskWithRequest:self.urlRequest delegate:self];
                       
                   });
    
}
//- (void)trimAudio
//{
//
//
//
//    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.recFileName]];
//
//    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:self.recFileName ofType:@"mp3"];
//
//    NSURL* audioFileInput = [NSURL fileURLWithPath:bundlePath];
//
//    NSURL *audioFileOutput = [NSURL fileURLWithPath:dirPath];
//
//    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
//
//
//    NSError* err;
//
//    BOOL copied = [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:dirPath error:&err];
//
//    NSString* file2 = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.recFileName]];
//
//
//    AVAudioPlayer* player= [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileOutput error:&err];
//
//    float duration = player.duration;
//
//    self.numOfTrimFiles = duration/59;
//
//    for (float i = 0, j=1; i<=duration; i=i+59,j++)
//    {
//        float vocalStartMarker = i;
//
//        float vocalEndMarker = i+59;
//
//        int k = j;
//
//        file2 = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@%d",self.recFileName, k]];
//
//        file2 = [file2 stringByAppendingPathExtension:@"m4a"];
//
//        NSURL *audioFileOutput = [NSURL fileURLWithPath:file2];
//
//        [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
//
//        if (!audioFileInput || !audioFileOutput)
//        {
//
//        }
//
//        [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
//
//        AVAsset *asset = [AVAsset assetWithURL:audioFileInput];
//
//        AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
//                                                                                presetName:AVAssetExportPresetAppleM4A];
//
//        if (exportSession == nil)
//        {
//
//        }
//
//        CMTime startTime = CMTimeMake((int)(floor(vocalStartMarker * 100)), 100);
//        CMTime stopTime = CMTimeMake((int)(ceil(vocalEndMarker * 100)), 100);
//        CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
//
//        exportSession.outputURL = audioFileOutput;
//        exportSession.outputFileType = AVFileTypeAppleM4A;
//        exportSession.timeRange = exportTimeRange;
//
//        [exportSession exportAsynchronouslyWithCompletionHandler:^
//         {
//             if (AVAssetExportSessionStatusCompleted == exportSession.status)
//             {
//                 // It worked!
//                 NSLog(@"suuucess");
//             }
//             else if (AVAssetExportSessionStatusFailed == exportSession.status)
//             {
//                 NSLog(@"failed");
//
//                 // It failed...
//             }
//         }];
//
//    }
//
//}


//-(void)withoutDelegateTrans
//{
//    AVAudioInputNode* inputNode = audioEngine.inputNode;
//
//    [inputNode removeTapOnBus:0];
//    //AVAudioFormat* recordingFormat = [inputNode inputFormatForBus:0];
//
//    [inputNode installTapOnBus:0 bufferSize:2048 format:[inputNode inputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when)
//     {
//         [self.request appendAudioPCMBuffer:buffer];
//     }];
//
//    [audioEngine prepare];
//
//    NSError* error;
//
//    [audioEngine startAndReturnError:&error];
//
//    request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
//
//    [self startTranscriptionStatusViewAnimationToDown:true];
//
//    [self setTimer];
//
//    recognitionTask = [speechRecognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
//        SFTranscription* transcription = result.bestTranscription;
//
//        if (transcription != nil)
//        {
//            //NSLog(@"%@", transcription.formattedString);
//            dispatch_async(dispatch_get_main_queue(), ^
//                           {
//
//
//                               if (isStartedNewRequest == true)
//                               {
//                                   NSString* text = [self.previousTranscriptedArray objectAtIndex:0];
//
//                                   self.transcriptionTextLabel.text = [text stringByAppendingString:[NSString stringWithFormat:@" %@",transcription.formattedString]];
//
//                                   // [self.previousTranscriptedArray replaceObjectAtIndex:0 withObject: self.transcriptionTextLabel.text];
//
//
//                               }
//                               else
//                               {
//                                   [self.previousTranscriptedArray replaceObjectAtIndex:0 withObject:transcription.formattedString];
//                                   self.transcriptionTextLabel.text = [self.previousTranscriptedArray objectAtIndex:0];
//
//                               }
//
//                               CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
//
//
//                               CGSize expectedLabelSize = [self.transcriptionTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
//
//                               self.scrollVIew.contentSize = expectedLabelSize;
//
//                           });
//        }
//
//    }];
//
//
//
//}

-(void)textViewDidChange:(UITextView *)textView
{
    if (!isTranscripting)
    {
        CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
        
        CGSize expectedLabelSize = [self.transcriptionTextView.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
        
        //                           CGSize customizeExpectedLabelSize = expectedLabelSize;
        expectedLabelSize.height = expectedLabelSize.height + 70;
        expectedLabelSize.width = self.view.frame.size.width * 0.95;

        self.scrollVIew.contentSize = expectedLabelSize;
        
        self.transcriptionTextView.contentSize = expectedLabelSize;
        
        CGRect frame = self.transcriptionTextView.frame;
        
        frame.size.height = self.transcriptionTextView.contentSize.height;
        frame.size.width = self.view.frame.size.width * 0.95;

        self.transcriptionTextView.frame = frame;
    }
   
}

@end

