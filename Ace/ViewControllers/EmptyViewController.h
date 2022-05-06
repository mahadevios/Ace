//
//  EmptyViewController.h
//  Ace
//
//  Created by mac on 22/05/18.
//  Copyright © 2018 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyViewController : UIViewController<UIDocumentInteractionControllerDelegate,UIWebViewDelegate>


@property(nonatomic, strong) NSString* usedByVCName;
@property(nonatomic, strong) NSString* docxFileToShowPath;
@property(nonatomic) long dataToShowCount;
@property(nonatomic, strong) UIWebView* webView;
@property(nonatomic, strong) UITextView* textFileContentTextView;
@property(nonatomic, strong) UIView* navigationView;
@property(nonatomic, strong) UILabel* navigationTitleLabel;
-(void)showDocxFile:(NSString*)docxFileToShowPath;

@end
