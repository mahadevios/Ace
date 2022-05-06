//
//  RegistrationViewController.m
//  Ace
//
//  Created by mac on 12/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "RegistrationViewController.h"
#import "PinRegistrationViewController.h"
#import "APIManager.h"
#import "AppPreferences.h"
#import "Constants.h"
#import "Keychain.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize IDTextField,passwordTextfield, loginCodeTextField;
@synthesize submitButton,cancelButton,hud,window;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    submitButton.layer.cornerRadius=7.0f;
    cancelButton.layer.cornerRadius=7.0f;
    IDTextField.layer.cornerRadius=7.0f;
    passwordTextfield.layer.cornerRadius=7.0f;
    loginCodeTextField.layer.cornerRadius=7.0f;
    IDTextField.layer.borderColor=[UIColor grayColor].CGColor;
    passwordTextfield.layer.borderColor=[UIColor grayColor].CGColor;
    loginCodeTextField.layer.borderColor=[UIColor grayColor].CGColor;
    IDTextField.layer.borderWidth=1.0f;
    passwordTextfield.layer.borderWidth=1.0f;
    loginCodeTextField.layer.borderWidth=1.0f;
    IDTextField.delegate=self;
    passwordTextfield.delegate=self;
    loginCodeTextField.delegate=self;

    [IDTextField becomeFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uIdPwdResponseCheck:) name:NOTIFICATION_AUTHENTICATE_API
                                               object:nil];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uIdPwdResponseCheck:(NSNotification* )dictObj
{
    NSDictionary* dict=dictObj.object;
    NSString* responseCodeString=  [dict valueForKey:RESPONSE_CODE];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [hud hideAnimated:YES];

    if ([responseCodeString intValue]==-1001 || [responseCodeString intValue]==2001) // net loss and unexpected response, alert has been shown in downloadmetadata
    {
        // error occured
        
    }
    else
    if ([responseCodeString intValue]==200)
    {
        [[NSUserDefaults standardUserDefaults] setValue:trimmedIdTextField forKey:USER_ID];
        [[NSUserDefaults standardUserDefaults] setValue:trimmedPasswordTextfield forKey:USER_PASS];
        [[NSUserDefaults standardUserDefaults] setValue:trimmedLoginCodeTextfield forKey:USER_LOGIN_CODE];

         PinRegistrationViewController* regiController=(PinRegistrationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PinRegistrationViewController"];

               [passwordTextfield resignFirstResponder];

               regiController.modalPresentationStyle = UIModalPresentationFullScreen;

               [self presentViewController:regiController animated:NO completion:nil];
       
    }
    else
    if ([responseCodeString intValue]==401)
    {
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Authentication failed!" withMessage:@"Account id or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        
        IDTextField.text=nil;
        passwordTextfield.text=nil;
        
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Authentication failed!" withMessage:@"Login Code is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        
        IDTextField.text=nil;
        passwordTextfield.text=nil;
        loginCodeTextField.text=nil;
    }



}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitButtonClicked:(id)sender
{
    if (IDTextField.text.length==0 || passwordTextfield.text.length==0 || loginCodeTextField.text.length==0)
    {
        
        NSString* title;
        NSString* message;
        UIAlertController *alertController;
        UIAlertAction *actionOk;
                   title=@"Incomplete Data";
            message=@"Id or password cannot be null";
            alertController = [UIAlertController alertControllerWithTitle:title
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
            actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                        {
                            
                        }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        

    }
    else
    {
        if ([AppPreferences sharedAppPreferences].isReachable)
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.minSize = CGSizeMake(150.f, 100.f);
            
            hud.label.text = @"Validating...";
            hud.detailsLabel.text = @"Please wait";
            NSString*  macId=[Keychain getStringForKey:@"udid"];
            // code to trim the leading and trailing spaces in id and password of user
            NSLog(@"untrimmed id is -%@- and untrimmed password is -%@-",IDTextField.text, passwordTextfield.text);
            trimmedIdTextField = [IDTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //remove only the leading and trailing spaces from the password
            trimmedPasswordTextfield = [passwordTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            trimmedLoginCodeTextfield = [loginCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            [[APIManager sharedManager] authenticateUserMacID:macId password:trimmedPasswordTextfield username:trimmedIdTextField loginCode:trimmedLoginCodeTextfield];
        }
        else
        {
           [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your internet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
        
    }
}
- (IBAction)cancelButtonClicked:(id)sender
{
    IDTextField.text=@"";
    passwordTextfield.text=@"";
    [IDTextField becomeFirstResponder];
    [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Hit home button to exit" withMessage:@"" withCancelText:nil withOkText:@"OK" withAlertTag:1000];}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==IDTextField)
    {
        [passwordTextfield becomeFirstResponder];
    }
    else
        if (textField==passwordTextfield)
        {
            [loginCodeTextField becomeFirstResponder];
        }else
        [loginCodeTextField resignFirstResponder];
    
    return  YES;
}


@end
