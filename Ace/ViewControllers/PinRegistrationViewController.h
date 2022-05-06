//
//  PinRegistrationViewController.h
//  Ace
//
//  Created by mac on 29/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PinRegistrationViewController : UIViewController<UITextFieldDelegate>
{
    
    NSString* title;
    NSString* message;
    UIAlertController *alertController;
    UIAlertAction *actionOk;
}
@property (weak, nonatomic) IBOutlet UITextField *pinCode1TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode2TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode3TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode4TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode5TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode6TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode7TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode8TextField;
- (IBAction)submitButtonClicked:(id)sender;

- (IBAction)caneclButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) MBProgressHUD *hud;

@end
