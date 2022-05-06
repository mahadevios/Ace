//
//  TransferredOrDeletedAudioDetailsViewController.h
//  Ace
//
//  Created by mac on 29/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioSessionManager.h"
#import "PopUpCustomView.h"
//#import "ListViewController.h"
//#import "MyClass.h"
@class TransferredOrDeletedAudioDetailsViewController;             //define class, so protocol can see MyClass
@protocol MyClassDelegate <NSObject>   //define delegate protocol

- (void) myClassDelegateMethod: (TransferredOrDeletedAudioDetailsViewController *) sender;  //define delegate method to be implemented within another class
@end //end protocol

@interface TransferredOrDeletedAudioDetailsViewController : UIViewController<AVAudioPlayerDelegate,UISplitViewControllerDelegate,MyClassDelegate>

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
    UITableViewCell *cell;
    NSArray* departmentNamesArray;
    UITapGestureRecognizer* tap;
    
    NSMutableArray* departmentObjectArray;

}

@property(nonatomic)long listSelected;
@property(nonatomic)long selectedRow;
- (IBAction)backButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteDictationButton;
- (IBAction)playRecordingButtonPressed:(id)sender;
- (IBAction)deleteRecordinfButtonPressed:(id)sender;
- (IBAction)resendButtonClckied:(id)sender;
- (IBAction)moreButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
-(void)setAudioDetails;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic, weak) id <MyClassDelegate> delegate; //define MyClassDelegate as delegate

@end
