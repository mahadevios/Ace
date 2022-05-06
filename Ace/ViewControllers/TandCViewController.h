//
//  TandCViewController.h
//  Ace
//
//  Created by mac on 27/11/18.
//  Copyright © 2018 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TandCViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate, UITextViewDelegate, WKNavigationDelegate>
{
    bool checkBoxSelected ;
    BOOL isScrollViewLoadedOnce;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *insideView;
@property (weak, nonatomic) IBOutlet UILabel *TCcontentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tcLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insideViewHeight;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
- (IBAction)checkBoxButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tcSubmitButton;
- (IBAction)tcSubmitButtonClicked:(id)sender;
@property (weak, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITextView *privacyPolicyLinkTextVIew;
@property(nonatomic, strong) WKWebView* wkWebView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end

NS_ASSUME_NONNULL_END
