//
//  SpeechRecognitionViewController.h
//  Ace
//
//  Created by mac on 24/11/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import "CommonDelegate.h"

@interface SpeechRecognitionViewController : UIViewController<SFSpeechRecognitionTaskDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,CommonDelegate,UITextViewDelegate>
{
    NSTimer* newRequestTimer;
    NSTimer* demoTimer;
    BOOL isTranscripting;
    BOOL isTrancriptFirstTimeFirstWord;
    BOOL isViewAppearedFirstTime;

    NSString* firstTimeManuallyEnteredText;
}
@property(nonatomic, strong)AVAudioEngine* audioEngine;
@property(nonatomic, strong)SFSpeechRecognizer* speechRecognizer;
@property(nonatomic, strong)SFSpeechAudioBufferRecognitionRequest* request;
@property(nonatomic, strong)SFSpeechURLRecognitionRequest* urlRequest;
@property (weak, nonatomic) IBOutlet UITextView *transcriptionTextView;

@property(nonatomic, strong)SFSpeechRecognitionTask* recognitionTask;
@property(nonatomic, strong)AVCaptureSession* capture;
@property(nonatomic, strong)NSMutableArray* previousTranscriptedArray;
@property(nonatomic, strong)UIView* transcriptionStatusView;
@property(nonatomic, strong)UILabel* timerLabel;
@property(nonatomic, strong)UILabel* transcriptionStatusLabel;
@property(nonatomic)BOOL isStartedNewRequest;
@property(nonatomic)int timerSeconds;
@property(nonatomic, strong)AVAudioFile* audioFileName;
@property(nonatomic, strong)UIAlertController* alertController;
//@property(nonatomic, strong)NSString* recFileName;
//@property(nonatomic)int recNum;
//@property(nonatomic)int numOfTrimFiles;
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *startPauseDocBGView;

- (IBAction)startLiveAudioTranscription:(id)sender;
- (IBAction)stopLiveAudioTranscription:(id)sender;
- (IBAction)createDocFileButtonClicked:(id)sender;

- (IBAction)segmentChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startTranscriptionButton;
@property (weak, nonatomic) IBOutlet UIButton *stopTranscriptionButton;
@property (weak, nonatomic) IBOutlet UIButton *docFileButton;

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *transcriptionTextLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet UIImageView *transRecordImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transStopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *transFIleImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
@property (weak, nonatomic) IBOutlet UILabel *docFileLabel;

- (IBAction)selectLocaleButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *localeLabel;

@property(nonatomic, strong)NSLocale* locale;
@property (weak, nonatomic) IBOutlet UIButton *selectLocaleButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
