//
//  AudioDetailsViewController.h
//  Ace//  Created by mac on 28/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioSessionManager.h"
#import "PopUpCustomView.h"

@class AudioDetailsViewController;             //define class, so protocol can see MyClass
@protocol MyClassDelegate <NSObject>   //define delegate protocol

- (void) myClassDelegateMethod: (AudioDetailsViewController *) sender;  //define delegate method to be implemented within another class
@end //end protocol

@interface AudioDetailsViewController : UIViewController<AVAudioPlayerDelegate,UIGestureRecognizerDelegate>
{
    NSDictionary* result;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;
    BOOL deleted;
    NSDictionary* audiorecordDict;
    UISlider* audioRecordSlider;
    UIView* sliderPopUpView;
    UIView* popupView;
    PopUpCustomView* forTableViewObj;
    bool moreButtonPressed;
    UIView * overlay;
    UIBackgroundTaskIdentifier task;
    UITableViewCell *cell;
    NSArray* departmentNamesArray;
    UITapGestureRecognizer* tap;
    BOOL isDeleteEditTransferButtonsRemovedAfterTransfer;
    
    NSMutableArray* departmentObjectArray;
}
@property(nonatomic)long selectedRow;
@property(nonatomic,strong)NSString* selectedView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIButton *transferDictationButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteDictationButton;

@property (nonatomic, weak) id <MyClassDelegate> delegate; //define MyClassDelegate as delegate

- (IBAction)moreButtonClicked:(id)sender;


- (IBAction)editRecordingButtonPressed:(id)sender;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)deleteDictation:(id)sender;
- (IBAction)playRecordingButtonPressed:(id)sender;
- (IBAction)transferDictationButtonClicked:(id)sender;
@end
