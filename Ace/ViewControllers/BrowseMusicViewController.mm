//
//  BrowseMusicViewController.m
//  Ace
//
//  Created by mac on 19/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//
//https://www.raywenderlich.com/6015/beginning-icloud-in-ios-5-tutorial-part-1
//https://www.appcoda.com/icloud-programming-ios-intro-tutorial/
//https://developer.apple.com/library/content/documentation/DataManagement/Conceptual/DocumentBasedAppPGiOS/ManageDocumentLifeCycle/ManageDocumentLifeCycle.html

//https://www.raywenderlich.com/12816/icloud-and-uidocument-beyond-the-basics-part-3

//http://stackoverflow.com/questions/21456210/icloud-integration-for-uploading-and-downloading-files

//https://developer.apple.com/videos/play/wwdc2015/234/

//extension creation https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html#//apple_ref/doc/uid/TP40014214-CH5-SW1

//$(OBJROOT)/SharedPrecompiledHeaders
#import "BrowseMusicViewController.h"
extern OSStatus DoConvertFile(CFURLRef sourceURL, CFURLRef destinationURL, OSType outputFormat, Float64 outputSampleRate);

@interface BrowseMusicViewController ()

@end

@implementation BrowseMusicViewController
@synthesize player;
- (void)viewDidLoad
{
//    [super viewDidLoad];
//    self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
//    self.audioData=nil;
    
    // Do any additional setup after loading the view.
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
#pragma mark Browse Audio from Device

-(void)PickAudioForIndex_iPhone
{
//    
//    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"]) {
//        //device is simulator
//        UIAlertView *alert1;
//        alert1 = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no Audio file in the Device" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//        alert1.tag=2;
//        [alert1 show];
//        //[alert1 release],alert1=nil;
//    }else{
//        
//        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
//        mediaPicker.delegate = self;
//        mediaPicker.allowsPickingMultipleItems = NO; // this is the default
//        [self presentViewController:mediaPicker animated:YES completion:nil];
//        
//    }
    
}

//#pragma mark Media picker delegate methods
//
//-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
//    
//    // We need to dismiss the picker
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    // Assign the selected item(s) to the music player and start playback.
//    if ([mediaItemCollection count] < 1) {
//        return;
//    }
//    song = [[mediaItemCollection items] objectAtIndex:0];
//    [self handleExportTapped];
//     //[self convertToWav];
//}
//-(void) convertToWavForMusicPlayer
//{
//    
//    NSArray* pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               AUDIO_FILES_FOLDER_NAME,
//                               [NSString stringWithFormat:@"%@.m4a", [song valueForProperty:MPMediaItemPropertyAssetURL]],
//                               nil];
//    NSURL* assetURL = [NSURL fileURLWithPathComponents:pathComponents];
//    // NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
//    
//    
//    NSError *assetError = nil;
//    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
//                                                               error:&assetError]
//    ;
//    if (assetError) {
//        NSLog (@"error: %@", assetError);
//        return;
//    }
//    
//    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
//                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
//                                              audioSettings: nil];
//    if (! [assetReader canAddOutput: assetReaderOutput]) {
//        NSLog (@"can't add reader output... die!");
//        return;
//    }
//    [assetReader addOutput: assetReaderOutput];
//    
//    NSString *title = [song valueForProperty:MPMediaItemPropertyAssetURL];
//    NSArray *docDirs = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [docDirs objectAtIndex: 0];
//    NSString *wavFilePath = [[docDir stringByAppendingPathComponent :title]
//                             stringByAppendingPathExtension:@"wav"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil];
//    }
//    NSURL *exportURL = [NSURL fileURLWithPath:wavFilePath];
//    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
//                                                          fileType:AVFileTypeWAVE
//                                                             error:&assetError];
//    if (assetError)
//    {
//        NSLog (@"error: %@", assetError);
//        return;
//    }
//    
//    AudioChannelLayout channelLayout;
//    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
//    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
//    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
//                                    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
//                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
//                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
//                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
//                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
//                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
//                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
//                                    nil];
//    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
//                                                                              outputSettings:outputSettings];
//    if ([assetWriter canAddInput:assetWriterInput])
//    {
//        [assetWriter addInput:assetWriterInput];
//    }
//    else
//    {
//        NSLog (@"can't add asset writer input... die!");
//        return;
//    }
//    
//    assetWriterInput.expectsMediaDataInRealTime = NO;
//    
//    [assetWriter startWriting];
//    [assetReader startReading];
//    
//    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
//    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
//    [assetWriter startSessionAtSourceTime: startTime];
//    
//    __block UInt64 convertedByteCount = 0;
//    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
//    
//    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
//                                            usingBlock: ^
//     {
//         
//         while (assetWriterInput.readyForMoreMediaData)
//         {
//             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
//             if (nextBuffer)
//             {
//                 // append buffer
//                 [assetWriterInput appendSampleBuffer: nextBuffer];
//                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
//                 CMTime progressTime = CMSampleBufferGetPresentationTimeStamp(nextBuffer);
//                 
//                 CMTime sampleDuration = CMSampleBufferGetDuration(nextBuffer);
//                 if (CMTIME_IS_NUMERIC(sampleDuration))
//                     progressTime= CMTimeAdd(progressTime, sampleDuration);
//                 float dProgress= CMTimeGetSeconds(progressTime) / CMTimeGetSeconds(songAsset.duration);
//                 NSLog(@"%f",dProgress);
//                 int pro=dProgress;
//                 if (pro==1)
//                 {
//                     
//                 }
//             }
//             else
//             {
//                 
//                 [assetWriterInput markAsFinished];
//                 //              [assetWriter finishWriting];
//                 [assetReader cancelReading];
//                 
//             }
//         }
//     }];
//    
//    
//}
//-(void)setCompressAudio
//{
//    CFURLRef sourceURL;
//    CFURLRef destinationURL;
//    NSString* filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *source=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"WaveFile"]];
//    
////     destinationFilePath= [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",self.recordedAudioFileName]];
//    // NSString *source = [[NSBundle mainBundle] pathForResource:@"sourceALAC" ofType:@"caf"];
//    
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString* destinationFilePath= [documentsDirectory  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"compressed"]];
//    //destinationFilePath = [[NSString alloc] initWithFormat: @"%@/output.caf", documentsDirectory];
//    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
//    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
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
//    OSType   outputFormat;
//    Float64  sampleRate;
//    
//    
//    destinationFilePath= [documentsDirectory  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"compressed"]];
//    outputFormat = kAudioFormatLinearPCM;
//    
//    //  sampleRate = 44100.0;
//    sampleRate = 0;
//    
//    OSStatus error1 = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate);
//    NSError* error2;
//    
//    if (error) {
//        // delete output file if it exists since an error was returned during the conversion process
//        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath]) {
//            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:nil];
//        }
//        NSString* destinationPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.wav",@"compressed"]];
//        [[NSFileManager defaultManager] moveItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@copy.wav",@"compressed"]] toPath:destinationPath error:&error];
//        printf("DoConvertFile failed! %d\n", (int)error1);
//        
//        return;
//        // return false;
//    }
//    else
//    {
//        //NSLog(@"Converted");
//        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@copy.wav",@"compressed"]] error:&error2];
//        NSArray* pathComponents = [NSArray arrayWithObjects:
//                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                                   
//                                   [NSString stringWithFormat:@"%@.wav",@"compressed"],
//                                   nil];
//        //self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
//        //        [self saveAudioRecordToDatabase];
//        return;
//    }
//    
//    // run audio file code in a background thread
//    // [self convertAudio];
//    
//}
//
//-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
//    
//    // User did not select anything
//    // We need to dismiss the picker
//    
//    [self dismissViewControllerAnimated:YES completion:nil ];
//}
//
//- (IBAction)backButtonPressed:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)browseFromMusicButtonClicked:(id)sender
//{
//    [self PickAudioForIndex_iPhone];
//}
//
//- (IBAction)playAudioButtonClicked:(id)sender
//{
//    [self showAudio];
//}
//
//#pragma mark conveniences
//
//NSString* myDocumentsDirectory(){
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    return [paths objectAtIndex:0];;
//    
//}
//
//void myDeleteFile (NSString* path){
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSError *deleteErr = nil;
//        [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteErr];
//        if (deleteErr) {
//            NSLog (@"Can't delete %@: %@", path, deleteErr);
//        }
//    }
//    
//}
//
//-(void)handleExportTapped{
//    
//    // get the special URL
//    if (! song) {
//        return;
//    }
//    
//    //[self startLoaderWithLabel:@"Preparing for upload..."];
//    
//    NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
//    
//    NSLog (@"Core Audio %@ directly open library URL %@",
//           coreAudioCanOpenURL (assetURL) ? @"can" : @"cannot",
//           assetURL);
//    
//    NSLog (@"compatible presets for songAsset: %@",
//           [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
//    
//    
//    /* approach 1: export just the song itself
//     */
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
//                                      initWithAsset: songAsset
//                                      presetName: AVAssetExportPresetAppleM4A];
//    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
//    exporter.outputFileType = @"com.apple.m4a-audio";
//    
//    NSString* exportFile=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.m4a",AUDIO_FILES_FOLDER_NAME,[song valueForKey:MPMediaItemPropertyTitle]]];
//    //NSString *exportFile = [myDocumentsDirectory() stringByAppendingPathComponent:[NSStrin]];
//    // end of approach 1
//    
//    // set up export (hang on to exportURL so convert to PCM can find it)
//    myDeleteFile(exportFile);
//    //[exportURL release];
//    exportURL = [NSURL fileURLWithPath:exportFile];
//    exporter.outputURL = exportURL;
//    
//    // do the export
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        int exportStatus = exporter.status;
//        switch (exportStatus) {
//            case AVAssetExportSessionStatusFailed: {
//                // log error to text view
//                NSError *exportError = exporter.error;
//                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
//                //errorView.text = exportError ? [exportError description] : @"Unknown failure";
//                //errorView.hidden = NO;
//                //[self stopLoader];
//                //[self showAlertWithMessage:@"There ia an error!"];
//                break;
//            }
//            case AVAssetExportSessionStatusCompleted: {
//                NSLog (@"AVAssetExportSessionStatusCompleted");
//                //fileNameLabel.text = [exporter.outputURL lastPathComponent];
//                // set up AVPlayer
//                //[self setUpAVPlayerForURL: exporter.outputURL];
//                ///////////////// get audio data from url
//                
//                //[self stopLoader];
//                //[self showAlertWithMessage:@"There ia an error!"];
//                
//                NSURL *audioUrl = exportURL;
//                NSLog(@"Audio Url=%@",audioUrl);
//                self.audioData = [NSData dataWithContentsOfURL:audioUrl];
//                
//                break;
//            }
//            case AVAssetExportSessionStatusUnknown: {
//                NSLog (@"AVAssetExportSessionStatusUnknown");
//                //[self stopLoader];
//                //[self showAlertWithMessage:@"There ia an error!"];
//                break;
//            }
//            case AVAssetExportSessionStatusExporting: {
//                NSLog (@"AVAssetExportSessionStatusExporting");
//                //[self stopLoader];
//                //[self showAlertWithMessage:@"There ia an error!"];
//                break;
//            }
//            case AVAssetExportSessionStatusCancelled: {
//                NSLog (@"AVAssetExportSessionStatusCancelled");
//                //[self stopLoader];
//                //[self showAlertWithMessage:@"There ia an error!"];
//                break;
//            }
//            case AVAssetExportSessionStatusWaiting: {
//                NSLog (@"AVAssetExportSessionStatusWaiting");
//                //[self stopLoader];
//                //[self showAlertWithMessage:@"There ia an error!"];
//                break;
//            }
//            default: {
//                NSLog (@"didn't get export status");
//                //[self stopLoader];
//                //[self showAlertWithMessage:@"There ia an error!"];
//                break;
//            }
//        }
//    }];
//    
//    
//    
//}
//
//
//// generic error handler from upcoming "Core Audio" book (thanks, Kevin!)
//// if result is nonzero, prints error message and exits program.
//
//static void CheckResult(OSStatus result, const char *operation)
//{
//    
//    if (result == noErr) return;
//    
//    char errorString[20];
//    // see if it appears to be a 4-char-code
//    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(result);
//    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
//        errorString[0] = errorString[5] = '\'';
//        errorString[6] = '\0';
//    } else
//        // no, format it as an integer
//        sprintf(errorString, "%d", (int)result);
//    
//    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
//    
//    exit(1);
//    
//}
//
//#pragma mark core audio test
//
//BOOL coreAudioCanOpenURL (NSURL* url){
//    
//    OSStatus openErr = noErr;
//    AudioFileID audioFile = NULL;
//    openErr = AudioFileOpenURL((__bridge CFURLRef) url,
//                               kAudioFileReadPermission ,
//                               0,
//                               &audioFile);
//    if (audioFile) {
//        AudioFileClose (audioFile);
//    }
//    return openErr ? NO : YES;
//    
//}
//
//
//
//
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
//    if (nextCount<audioNamesArray.count)
//    {
//    //BOOL exist=[defaultManager fileExistsAtPath:audioFolderPath];
//    NSString* audioFilePathString=[audioNamesArray objectAtIndex:nextCount];
//        nextCount++;
//    //NSString* audioFilePathString=[sharedDefaults objectForKey:@"waveFileName"];
//    
//    
//    //audioFilePathString=[audioFilePathString stringByDeletingPathExtension];
//    
//    // audioFilePathString=[audioFilePathString stringByAppendingPathExtension:@"wav"];
//    NSURL* newurl=[NSURL URLWithString:audioFolderPath];
//    
//    NSString* audioFilePath=[newurl.path stringByAppendingPathComponent:audioFilePathString];
//    
//    NSData* audioData=[NSData dataWithContentsOfFile:audioFilePath];
//    
//    
//    NSLog(@"%@",[sharedDefaults objectForKey:@"assetUrl"]);
//        
////        dispatch_async(dispatch_get_main_queue(), ^
////                       {
//                           //NSLog(@"Reachable");
//                           NSError* error;
//
//                           player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
//        
//        
//                      // });
//    
//    }
//    
//}
//
//
//-(void) convertToWav
//{
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:SHARED_GROUP_IDENTIFIER];
//    
//    NSString* sharedAudioFolderPathString=[sharedDefaults objectForKey:@"audioFolderPath"];
//    
//    NSMutableArray* sharedAudioNamesArray=[NSMutableArray new];
//    
//    sharedAudioNamesArray=[sharedDefaults objectForKey:@"audioNamesArray"];
//    
//    
//    NSString* sharedAudioFileNameString=[sharedAudioNamesArray lastObject];
//    
//    NSURL* sharedAudioFolderPathUrl=[NSURL URLWithString:sharedAudioFolderPathString];
//    
//    
//    NSString* sharedAudioFilePathString=[sharedAudioFolderPathUrl.path stringByAppendingPathComponent:sharedAudioFileNameString];
//    
//    
//    NSData* sharedAudioFileData=[NSData dataWithContentsOfFile:sharedAudioFilePathString];
//    
//    NSString* homePathString=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[sharedAudioNamesArray lastObject]];
//    
//    NSError* err;
//    
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:homePathString])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:homePathString error:&err];
//    }
//    BOOL write1= [sharedAudioFileData writeToFile:homePathString atomically:YES];
//    
//    //    NSArray* pathComponents = [NSArray arrayWithObjects:
//    //                               NSHomeDirectory(),
//    //                               @"Documents",
//    //                               @"convertToWave.m4a",
//    //                               nil];
//    
//    
//    NSURL* newAssetUrl = [NSURL fileURLWithPath:homePathString];
//    
//    NSError *assetError = nil;
//    
//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:newAssetUrl options:nil];
//    
//    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
//                                                               error:&assetError]
//    ;
//    NSString* assetString=[NSString stringWithFormat:@"%@",assetError];
//    
//    [sharedDefaults setObject:assetString forKey:@"assetUrl"];
//    if (assetError) {
//        NSLog (@"error: %@", assetError);
//        return;
//    }
//    
//    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
//                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
//                                              audioSettings: nil];
//    if (! [assetReader canAddOutput: assetReaderOutput]) {
//        NSLog (@"can't add reader output... die!");
//        return;
//    }
//    [assetReader addOutput: assetReaderOutput];
//    
//    
//    if (assetError) {
//        NSLog (@"error: %@", assetError);
//        
//        return;
//    }
//    
//    NSString* audioFilePath=[homePathString stringByDeletingPathExtension];
//    
//    audioFilePath=[audioFilePath stringByAppendingPathExtension:@"wav"];
//    
//    NSString *wavFilePath = audioFilePath;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath])
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil];
//    }
//    NSURL *exportURL = [NSURL fileURLWithPath:wavFilePath];
//    
//    
//    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
//                                                          fileType:AVFileTypeWAVE
//                                                             error:&assetError];
//    if (assetError)
//    {
//        NSLog (@"error: %@", assetError);
//        return;
//    }
//    
//    AudioChannelLayout channelLayout;
//    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
//    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
//    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
//                                    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
//                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
//                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
//                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
//                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
//                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
//                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
//                                    nil];
//    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
//                                                                              outputSettings:outputSettings];
//    if ([assetWriter canAddInput:assetWriterInput])
//    {
//        [assetWriter addInput:assetWriterInput];
//    }
//    else
//    {
//        NSLog (@"can't add asset writer input... die!");
//        return;
//    }
//    
//    assetWriterInput.expectsMediaDataInRealTime = NO;
//    
//    [assetWriter startWriting];
//    [assetReader startReading];
//    
//    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
//    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
//    [assetWriter startSessionAtSourceTime: startTime];
//    
//    __block UInt64 convertedByteCount = 0;
//    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
//    
//    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
//                                            usingBlock: ^
//     {
//         
//         while (assetWriterInput.readyForMoreMediaData)
//         {
//             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
//             if (nextBuffer)
//             {
//                 // append buffer
//                 [assetWriterInput appendSampleBuffer: nextBuffer];
//                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
//                 CMTime progressTime = CMSampleBufferGetPresentationTimeStamp(nextBuffer);
//                 
//                 CMTime sampleDuration = CMSampleBufferGetDuration(nextBuffer);
//                 if (CMTIME_IS_NUMERIC(sampleDuration))
//                     progressTime= CMTimeAdd(progressTime, sampleDuration);
//                 float dProgress= CMTimeGetSeconds(progressTime) / CMTimeGetSeconds(songAsset.duration);
//                 NSLog(@"%f",dProgress);
//                 int pro=dProgress;
//                 if (pro==1)
//                 {
//                     
//                 }
//             }
//             else
//             {
//                 
//                 [assetWriterInput markAsFinished];
//                 //              [assetWriter finishWriting];
//                 [assetReader cancelReading];
//                 
//             }
//         }
//     }];
//    [sharedDefaults synchronize];
//    
//}
//-(void)setCompressAudio
//{
//    CFURLRef sourceURL;
//    CFURLRef destinationURL;
//    NSString* filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *source=[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"WaveFile"]];
//
//    //     destinationFilePath= [[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:AUDIO_FILES_FOLDER_NAME]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",self.recordedAudioFileName]];
//    // NSString *source = [[NSBundle mainBundle] pathForResource:@"sourceALAC" ofType:@"caf"];
//
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//
//    NSString* destinationFilePath= [documentsDirectory  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"compressed"]];
//    //destinationFilePath = [[NSString alloc] initWithFormat: @"%@/output.caf", documentsDirectory];
//    destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
//    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
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
//    OSType   outputFormat;
//    Float64  sampleRate;
//
//
//    destinationFilePath= [documentsDirectory  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",@"compressed"]];
//    outputFormat = kAudioFormatLinearPCM;
//
//    //  sampleRate = 44100.0;
//    sampleRate = 0;
//
//    OSStatus error1 = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate);
//    NSError* error2;
//
//    if (error) {
//        // delete output file if it exists since an error was returned during the conversion process
//        if ([[NSFileManager defaultManager] fileExistsAtPath:destinationFilePath]) {
//            [[NSFileManager defaultManager] removeItemAtPath:destinationFilePath error:nil];
//        }
//        NSString* destinationPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.wav",@"compressed"]];
//        [[NSFileManager defaultManager] moveItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@copy.wav",@"compressed"]] toPath:destinationPath error:&error];
//        printf("DoConvertFile failed! %d\n", (int)error1);
//
//        return;
//        // return false;
//    }
//    else
//    {
//        //NSLog(@"Converted");
//        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@copy.wav",@"compressed"]] error:&error2];
//        NSArray* pathComponents = [NSArray arrayWithObjects:
//                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//
//                                   [NSString stringWithFormat:@"%@.wav",@"compressed"],
//                                   nil];
//        //self.recordedAudioURL=[NSURL fileURLWithPathComponents:pathComponents];
//        //        [self saveAudioRecordToDatabase];
//        return;
//    }
//
//    // run audio file code in a background thread
//    // [self convertAudio];
//    
//}


@end
