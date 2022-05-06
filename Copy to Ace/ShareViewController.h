//
//  ShareViewController.h
//  Copy to Cube
//
//  Created by mac on 27/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, InterfaceOrientationType) {
    InterfaceOrientationTypePortrait,
    InterfaceOrientationTypeLandscape
};
@interface ShareViewController : SLComposeServiceViewController<UITextFieldDelegate>

{
    NSDictionary* result;
    UIAlertController *alertController;
    UIAlertAction *actionSave;
    UIAlertAction *actionCancel;
    //bool isFileAvailable;
    NSURLSession *mySession;
    NSURL *url;
    NSString* fileNameForViewString;
    UILabel* fileNameLabel;
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
}
- (InterfaceOrientationType)orientation;

@property(nonatomic,strong)NSString* audioFilePathString;
@property(nonatomic,strong)NSString* fileName;
@property(nonatomic,strong)NSString* fileNamePathExtension;
@property(nonatomic)BOOL isFileAvailable;
@property(nonatomic,strong)UIView* navigationView;
@property(nonatomic,strong)UIButton* cpyAudioFileButton;
@property(nonatomic,strong)UILabel* titleLabel;


@end
