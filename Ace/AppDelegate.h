//
//  AppDelegate.h
//  Ace
//
//  Created by mac on 26/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    bool isFileAvailable;
    NSURL *exportURL;
    int nextCount;
    NSString *destinationFilePath;
    CFURLRef sourceURL;
    CFURLRef destinationURL;
    OSType   outputFormat;
    NSString* audioFilePath;
    Float64  sampleRate;
    AVAudioPlayer* player;
   void (^_completionHandler)(UIBackgroundFetchResult);

}
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) MBProgressHUD *hud;
@property(nonatomic)BOOL gotResponse;
@property(nonatomic,strong)NSString* audioFilePathString;
@property(nonatomic,strong)NSString* fileName;
@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)(void);

@end

