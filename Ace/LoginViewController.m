//http://www.appcoda.com/customize-navigation-status-bar-ios-7/

// PKI


//pixel to point conversion: http://endmemo.com/sconvert/pixelpoint.php

//provisioning profile ***: http://sharpmobilecode.com/making-sense-of-ios-provisioning/

//add provisioning profile**: http://docs.telerik.com/platform/appbuilder/cordova/code-signing-your-app/configuring-code-signing-for-ios-apps/create-ad-hoc-provisioning-profile

//property getter setter strong weak http://stackoverflow.com/questions/843632/is-there-a-difference-between-an-instance-variable-and-a-property-in-objecti

//strong reference concept ray wenderlich https://www.raywenderlich.com/5677/beginning-arc-in-ios-5-part-1

// about nsurlsession https://realm.io/news/gwendolyn-weston-ios-background-networking/

//about nsurlsession http://stackoverflow.com/questions/20390428/handleeventsforbackgroundurlsession-never-called-when-a-downloadtask-finished

// background session http://stackoverflow.com/questions/31802656/what-happens-to-nsurlsessiontasks-if-app-is-killed

//** background session cancelled http://stackoverflow.com/questions/20159471/ios-does-force-quitting-the-app-disables-background-upload-using-nsurlsession?rq=1

// resume upload https://forums.developer.apple.com/thread/10239

//audio trim http://stackoverflow.com/questions/30321791/how-to-trim-music-library-file-and-save-it-document-directry
//  ViewController.m
//  Ace
//
//  Created by mac on 26/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "LoginViewController.h"
#import "DepartMent.h"
#import "MainTabBarViewController.h"
#import "NSData+AES256.h"
#import "Keychain.h"
#import "SelectDepartmentViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize pinCode1TextField,pinCode2TextField,pinCode3TextField,pinCode4TextField;
@synthesize hud;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [pinCode1TextField becomeFirstResponder];
  
    if ([[NSUserDefaults standardUserDefaults] boolForKey:LOGIN_USING_FACE_TOUCH_ID]) {
        NSString* userPin = [[NSUserDefaults standardUserDefaults] valueForKey:USER_PIN];

        if ([userPin isEqualToString:@""] || userPin == NULL) {
            
        }else{
           // [self checkAuthentication];
        }
    }
   
}

//-(void) addWebView
//{
//    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
//    webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
//    webView.navigationDelegate = self;
//    NSURL *nsurl=[NSURL URLWithString:@"https://cfscommunicator.com/#/login/GuestUserWithMeeting?meetingCode=438659271"];
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    [webView loadRequest:nsrequest];
//    [self.view addSubview:webView];
//}

-(void)viewWillAppear:(BOOL)animated
{
//    [self addWebView];
    NSString* macId = [[NSUserDefaults standardUserDefaults] valueForKey:@"MacId"];
    
    //self.navigationItem.title=@"Pin Login";
    //[self.navigationController.navigationBar setTitleTextAttributes:
    //@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
    // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //[self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color
    //    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-Bold" size:30.0],NSFontAttributeName, nil];
    //
    //    self.navigationController.navigationBar.titleTextAttributes = size;
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"System-Bold" size:20]}];
    //
    //@{NSForegroundColorAttributeName:[UIColor orangeColor]}
    
    pinCode1TextField.delegate=self;
    pinCode2TextField.delegate=self;
    pinCode3TextField.delegate=self;
    pinCode4TextField.delegate=self;
    
    pinCode1TextField.layer.cornerRadius=4.0f;
    pinCode1TextField.layer.masksToBounds=YES;
    pinCode1TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode1TextField.layer.borderWidth= 1.0f;
    
    pinCode2TextField.layer.cornerRadius=4.0f;
    pinCode2TextField.layer.masksToBounds=YES;
    pinCode2TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode2TextField.layer.borderWidth= 1.0f;
    
    pinCode3TextField.layer.cornerRadius=4.0f;
    pinCode3TextField.layer.masksToBounds=YES;
    pinCode3TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode3TextField.layer.borderWidth= 1.0f;
    
    pinCode4TextField.layer.cornerRadius=4.0f;
    pinCode4TextField.layer.masksToBounds=YES;
    pinCode4TextField.layer.borderColor=[[UIColor grayColor]CGColor];
    pinCode4TextField.layer.borderWidth= 1.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validatePinResponseCheck:) name:NOTIFICATION_VALIDATE_PIN_API
                                               object:nil];
    
   
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [pinCode4TextField resignFirstResponder];
    [pinCode1TextField resignFirstResponder];

}
//-(void)validatePinResponseCheck:(NSNotification*)dictObj;
//{
//    NSDictionary* responseDict=dictObj.object;
//
//    NSString* responseCodeString=  [responseDict valueForKey:RESPONSE_CODE];
//
//    NSString* responsePinString=  [responseDict valueForKey:@"pinvalidflag"];
//
//    if ([responseCodeString intValue]==401 && [responsePinString intValue]==0)
//    {
//        [hud hideAnimated:YES];
//
//        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Incorrect PIN entered" withMessage:@"Please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//        pinCode1TextField.text=@"";
//        pinCode2TextField.text=@"";
//        pinCode3TextField.text=@"";
//        pinCode4TextField.text=@"";
//        [pinCode1TextField becomeFirstResponder];
//    }
//
//    if ([responseCodeString intValue]==200 && [responsePinString intValue]==1)
//    {
//
//        [hud hideAnimated:YES];
//
//        if([AppPreferences sharedAppPreferences].userObj == nil)
//        {
//            [AppPreferences sharedAppPreferences].userObj = [[User alloc] init];
//        }
//
//        NSString* pin=[NSString stringWithFormat:@"%@%@%@%@",pinCode1TextField.text,pinCode2TextField.text,pinCode3TextField.text,pinCode4TextField.text];
//
//        [AppPreferences sharedAppPreferences].userObj.userPin = pin;
//
//
//
//        NSArray* departmentArray=  [responseDict valueForKey:@"DepartmentList"];
//
//        NSMutableArray* deptForDatabaseArray=[[NSMutableArray alloc]init];
//
//        for (int i=0; i<departmentArray.count; i++)
//        {
//            DepartMent* deptObj=[[DepartMent alloc]init];
//
//            NSDictionary* deptDict= [departmentArray objectAtIndex:i];
//
//            deptObj.Id= [[deptDict valueForKey:@"ID"]longLongValue];
//
//            deptObj.departmentName=[deptDict valueForKey:@"DeptName"];
//
//            [deptForDatabaseArray addObject:deptObj];
//        }
//
//        Database *db=[Database shareddatabase];
//
//        [db insertDepartMentData:deptForDatabaseArray];
//
//
//        //get user firstname,lastname and userId for file prefix
//
//        NSString* fileNamePrefix = [responseDict valueForKey:@"FileNamePrefix"];
//
//        [[NSUserDefaults standardUserDefaults] setValue:fileNamePrefix forKey:@"FileNamePrefix"];
//
//        [pinCode4TextField resignFirstResponder];
//
//        [self dismissViewControllerAnimated:NO completion:nil];
//
//
//        MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
//
//        [[UIApplication sharedApplication] keyWindow].rootViewController = nil;
//
//        [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
//
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadedFirstTime"])
//        {
//
//            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SelectDepartmentViewController"] animated:NO completion:nil];
//
//        }
//        else
//            [self dismissViewControllerAnimated:NO completion:nil];
//
//    }
//
//
//}

-(void)validatePinResponseCheck:(NSNotification*)dictObj
{
    NSDictionary* responseDict=dictObj.object;
    
    NSString* responseCodeString=  [responseDict valueForKey:RESPONSE_CODE];
    
    NSString* responsePinString=  [responseDict valueForKey:@"pinvalidflag"];
    
    if ([responseCodeString intValue] == 2001 || [responseCodeString intValue] == -1001)
    {
        // received unexpected response, just remove the hud
        [hud hideAnimated:YES];
    }
    else
    if ([responseCodeString intValue]==401 && [responsePinString intValue]==0)
    {
        [hud hideAnimated:YES];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Incorrect PIN entered" withMessage:@"Please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        
        pinCode1TextField.text=@"";pinCode2TextField.text=@"";pinCode3TextField.text=@"";pinCode4TextField.text=@"";
       
        [pinCode1TextField becomeFirstResponder];
    }
    
    if ([responseCodeString intValue]==200 && [responsePinString intValue]==1)
    {
        
        [hud hideAnimated:YES];
        
        if([AppPreferences sharedAppPreferences].userObj == nil)
        {
            [AppPreferences sharedAppPreferences].userObj = [[User alloc] init];
        }
        
        NSString* pin=[NSString stringWithFormat:@"%@%@%@%@",pinCode1TextField.text,pinCode2TextField.text,pinCode3TextField.text,pinCode4TextField.text];
        
        if ([pin isEqualToString:@""] || pin == NULL) {
            NSString* userPin =  [[NSUserDefaults standardUserDefaults] valueForKey:USER_PIN];
            
            [AppPreferences sharedAppPreferences].userObj.userPin = userPin;
        }else{
            [AppPreferences sharedAppPreferences].userObj.userPin = pin;
            
            [[NSUserDefaults standardUserDefaults] setValue:pin forKey:USER_PIN];

        }
       
        NSString* userId =  [responseDict valueForKey:@"UserID"];

        [[NSUserDefaults standardUserDefaults] setValue:userId forKey:USER_ID_INT];
        
        NSArray* departmentArray=  [responseDict valueForKey:@"DepartmentList"];
        
        NSMutableArray* deptForDatabaseArray=[[NSMutableArray alloc]init];
        
        for (int i=0; i<departmentArray.count; i++)
        {
            DepartMent* deptObj=[[DepartMent alloc]init];
            
            NSDictionary* deptDict= [departmentArray objectAtIndex:i];
            
            deptObj.Id= [[deptDict valueForKey:@"ID"]longLongValue];
            
            deptObj.departmentName=[deptDict valueForKey:@"DeptName"];
            
            [deptForDatabaseArray addObject:deptObj];
        }
        
        Database *db=[Database shareddatabase];
        
        [db truncateTable_TableName:@"DepartmentList"];

        [db insertDepartMentData:deptForDatabaseArray];
       
        //get user firstname,lastname and userId for file prefix
        NSString* fileNamePrefix = [responseDict valueForKey:@"FileNamePrefix"];
        NSString* dictatorName = [responseDict valueForKey:@"Dname"];

        
        [[NSUserDefaults standardUserDefaults] setValue:dictatorName forKey:DICTATOR_NAME];
        [[NSUserDefaults standardUserDefaults] setValue:fileNamePrefix forKey:@"FileNamePrefix"];
        
        NSString* enableVRSForUser = [responseDict valueForKey:@"IsVRS"];

        if (enableVRSForUser == nil || [enableVRSForUser isEqualToString:@"0"] || [enableVRSForUser isEqualToString:@""]) {
//            [AppPreferences sharedAppPreferences].enableVRSForUser = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_VRS_ENABLE];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_VRS_ENABLE];
//            [AppPreferences sharedAppPreferences].enableVRSForUser = YES;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view endEditing:true];

            [pinCode4TextField resignFirstResponder];

        });
        
//        [self dismissViewControllerAnimated:NO completion:nil];
        
        
//        MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
//        
//        [[UIApplication sharedApplication] keyWindow].rootViewController = nil;
//        
//        [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadedFirstTime"])
        {
           SelectDepartmentViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectDepartmentViewController"];
            
              viewController.modalPresentationStyle = UIModalPresentationFullScreen;
                              
              [self presentViewController:viewController animated:NO completion:nil];
//            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SelectDepartmentViewController"] animated:NO completion:nil];
            
        }
        else
            [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    
    
}
- (void) checkAndDismissViewController
{
    id viewController = [self topViewController];
    if([viewController isKindOfClass:[LoginViewController class]]){
        //do something
        [viewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (UIViewController *)topViewController
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}



//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    // Prevent crashing undo bug – see note below.
//    if(range.length + range.location > textField.text.length)
//    {
//        return NO;
//    }
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//
//    if (newLength==1)
//    {
//        [self performSelector:@selector(resignFirstResponder:) withObject:textField afterDelay:0.02];
//
//    }
//
//    return newLength <= 1;
//}
//
//-(void)resignFirstResponder:(UITextField*)textfield
//{
//    if (textfield==pinCode1TextField && textfield.text.length > 0)
//    {
//        [pinCode2TextField becomeFirstResponder];
//    }
//    else
//        if (textfield==pinCode2TextField && textfield.text.length > 0)
//        {
//            [pinCode3TextField becomeFirstResponder];
//
//        }
//        else
//            if (textfield==pinCode3TextField && textfield.text.length > 0)
//            {
//                [pinCode4TextField becomeFirstResponder];
//
//            }
//
//
//}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField == pinCode1TextField)
    {
        [pinCode2TextField becomeFirstResponder];
    }
    else if (textField == pinCode2TextField)
    {
        [pinCode3TextField becomeFirstResponder];
    }
    else if (textField == pinCode3TextField)
    {
        [pinCode4TextField becomeFirstResponder];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // This allows numeric text only, but also backspace for deletes
    if (string.length > 0 && ![[NSScanner scannerWithString:string] scanInt:NULL])
        return NO;
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    // This 'tabs' to next field when entering digits
    if (newLength == 1) {
        if (textField == pinCode1TextField)
        {
            [self performSelector:@selector(setNextResponder:) withObject:pinCode2TextField afterDelay:0.05];
        }
        else if (textField == pinCode2TextField)
        {
            [self performSelector:@selector(setNextResponder:) withObject:pinCode3TextField afterDelay:0.05];
        }
        else if (textField == pinCode3TextField)
        {
            [self performSelector:@selector(setNextResponder:) withObject:pinCode4TextField afterDelay:0.05];
        }
    }
    //this goes to previous field as you backspace through them, so you don't have to tap into them individually
    else if (oldLength > 0 && newLength == 0) {
        if (textField == pinCode4TextField)
        {
            [self performSelector:@selector(setNextResponder:) withObject:pinCode3TextField afterDelay:0.05];
        }
        else if (textField == pinCode3TextField)
        {
            [self performSelector:@selector(setNextResponder:) withObject:pinCode2TextField afterDelay:0.05];
        }
        else if (textField == pinCode2TextField)
        {
            [self performSelector:@selector(setNextResponder:) withObject:pinCode1TextField afterDelay:0.05];
        }
    }
    
    return newLength <= 1;
}

- (void)setNextResponder:(UITextField *)nextResponder
{
    [nextResponder becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonCilcked:(id)sender
{
    
    //  [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TandCViewController"] animated:NO completion:nil];
    NSString* title;
    NSString* message;
    UIAlertController *alertController;
    UIAlertAction *actionOk;
    if ([pinCode1TextField.text isEqual:@""] || [pinCode2TextField.text isEqual:@""]|| [pinCode3TextField.text isEqual:@""] || [pinCode4TextField.text isEqual:@""])
    {
        title=@"Incomplete PIN code!";
        message=@"Please enter PIN code properly";
        alertController = [UIAlertController alertControllerWithTitle:title
                                                              message:message
                                                       preferredStyle:UIAlertControllerStyleAlert];
        actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        pinCode1TextField.text=@"";pinCode2TextField.text=@"";pinCode3TextField.text=@"";pinCode4TextField.text=@"";
                        [pinCode1TextField becomeFirstResponder];
                    }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        NSString* pin=[NSString stringWithFormat:@"%@%@%@%@",pinCode1TextField.text,pinCode2TextField.text,pinCode3TextField.text,pinCode4TextField.text];
        
        if([AppPreferences sharedAppPreferences].userObj != nil)
        {
            if([[AppPreferences sharedAppPreferences].userObj.userPin isEqualToString:pin])
            {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadedFirstTime"])
                {
                    [pinCode4TextField resignFirstResponder];
                     SelectDepartmentViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectDepartmentViewController"];
                    
                      viewController.modalPresentationStyle = UIModalPresentationFullScreen;
                                      
                      [self presentViewController:viewController animated:NO completion:nil];
                }
                else
                {
                    [pinCode1TextField resignFirstResponder];[pinCode4TextField resignFirstResponder];
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
                
                return;
            }
            else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Incorrect PIN entered" withMessage:@"Please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
                
                pinCode1TextField.text=@"";pinCode2TextField.text=@"";pinCode3TextField.text=@"";pinCode4TextField.text=@"";
                
                [pinCode1TextField becomeFirstResponder];
                
                return;
            }
        }
        
        else
        {
            [self loginAndFetchData:@"Validating PIN..." pin:pin];
        }
        
    }
    
    
}

-(void) loginAndFetchData:(NSString*) loadingMessage pin:(NSString*)pin
{
    if ([AppPreferences sharedAppPreferences].isReachable)
    {
        
        hud.minSize = CGSizeMake(150.f, 100.f);
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = loadingMessage;
        hud.detailsLabel.text = @"Please wait";
        NSString*     macId=[Keychain getStringForKey:@"udid"];
        
        [[NSUserDefaults standardUserDefaults] setValue:macId forKey:@"MacId"];
        
        [pinCode4TextField resignFirstResponder];
        
        [[APIManager sharedManager] validatePinMacID:macId Pin:pin];
        
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your internet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}
- (IBAction)cancelButtonClicked:(id)sender
{
    pinCode1TextField.text=@"";pinCode2TextField.text=@"";pinCode3TextField.text=@"";pinCode4TextField.text=@"";
    
    [pinCode1TextField becomeFirstResponder];
    
    [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Hit home button to exit" withMessage:@"" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    
}

-(void) checkAuthentication
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *localizedReason = @"Authenticate using your finger";
//    [myContext setLocalizedCancelTitle:@"Enter PIN"];
    myContext.localizedFallbackTitle = @"Enter PIN";
//    [myContext setAccessibilityFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if (@available(iOS 11.0, *)) {
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            if (myContext.biometryType == LABiometryTypeFaceID) {
                localizedReason = @"Unlock using Face ID";
                NSLog(@"FaceId support");
                
                
                        } else if (myContext.biometryType == LABiometryTypeTouchID) {
                            localizedReason = @"Unlock using Touch ID";
                            NSLog(@"TouchId support");
                        } else {
                            NSLog(@"No Biometric support");
                        }
            
            
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:localizedReason
                                reply:^(BOOL success, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                    if (success) {
                        
                        NSString* userPin = [[NSUserDefaults standardUserDefaults] valueForKey:USER_PIN];
                        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLoadedFirstTime"] && [AppPreferences sharedAppPreferences].userObj.userPin!=NULL) // came from background hence simply dimiss after Face Success
                        {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        else{
                            [self loginAndFetchData:@"Fetching Data" pin:userPin];
                        }
                        NSLog(@"User is authenticated successfully");
                    } else {
                        switch (error.code) {
                            case LAErrorAuthenticationFailed:
                                NSLog(@"Authentication Failed");
                                break;
                                
                            case LAErrorUserCancel:
                                NSLog(@"User pressed Cancel button");
                                break;
                                
                            case LAErrorUserFallback:
                                NSLog(@"User pressed \"Enter Password\"");
                                break;
                                
                            default:
                                NSLog(@"Touch ID is not configured");
                                break;
                        }
                        NSLog(@"Authentication Fails");
                    }

                });
            }];
            
            
        } else {
            NSLog(@"Can not evaluate Touch ID");
        }
    } else {
        // Fallback on earlier versions
    }
}

@end
