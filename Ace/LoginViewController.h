//
//  ViewController.h
//  Ace
//
//  Created by mac on 26/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Constants.h"
#import "APIManager.h"
#import "AppPreferences.h"
#import "Database.h"
#import <WebKit/WebKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

{
    BOOL isLoadedFirstTime;
//    WKWebView *webView;
    
}
@property (weak, nonatomic) IBOutlet UITextField *pinCode1TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode2TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode3TextField;
@property (weak, nonatomic) IBOutlet UITextField *pinCode4TextField;
- (IBAction)submitButtonCilcked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) MBProgressHUD *hud;

@end

