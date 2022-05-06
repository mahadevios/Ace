//
//  AppointmentDetailsViewController.h
//  Ace
//
//  Created by mac on 25/03/20.
//  Copyright © 2020 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientDetails.h"
#import "APIManager.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "RecordViewController.h"
#import "SafariSupportViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AppointmentDetailsViewController;
@protocol ApointmentDelegate <NSObject>   //define delegate protocol

- (void) myClassDelegateMethod: (AppointmentDetailsViewController *) sender;  //define delegate method to be implemented within another class
@end //end protocol

@interface AppointmentDetailsViewController : UIViewController
{
   UIAlertController *alertController;
   UIAlertAction *actionUpdate;
   UIAlertAction *actionCancel;
   NSString* selectedAppointmentStatus;
    BOOL callOptionShownOnce;
    MBProgressHUD *hud;
    BOOL aptDetailsSet;
    SafariSupportViewController* sf;
}
- (IBAction)changeAptStatusButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeAptStatusButton;
@property (weak, nonatomic) IBOutlet UILabel *aptStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *nhsNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *skypeButton;

@property (weak, nonatomic) IBOutlet UILabel *mrnNoLabel;
@property (nonatomic)int selectedRow;
@property (nonatomic)BOOL isOpenedThroughButton;
@property (nonatomic, weak) id <ApointmentDelegate> delegate; //define MyClassDelegate as delegate
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (nonatomic, strong) PatientDetails* patientDetails;
- (IBAction)backButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)whatsappButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *whatsappButton;
- (IBAction)facetimeButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *facetimeButton;
- (IBAction)phoneCallButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *phoneCallButton;
- (IBAction)recordButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *skypeIdLabel;

@property (weak, nonatomic) IBOutlet UIButton *learniphiVideoCallButton;
@property (nonatomic, strong) NSString* patientMeetingUrlString;
- (IBAction)learniphiVideoCallButtonClicked:(id)sender;

-(IBAction)skypeCallButtonClicked:(id)sender;
@end

NS_ASSUME_NONNULL_END
