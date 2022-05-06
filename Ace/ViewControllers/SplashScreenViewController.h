//
//  SplashScreenViewController.h
//  Ace
//
//  Created by mac on 31/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SplashScreenViewController : UIViewController
{
    BOOL APIcalled;
}
@property (weak, nonatomic) MBProgressHUD *hud;

@end
