//
//  BrowseMusicViewController.h
//  Ace
//
//  Created by mac on 19/12/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface BrowseMusicViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MPMediaPickerControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,AVAudioSessionDelegate>
{
    MPMediaItem *song;
    NSURL *exportURL;
    int nextCount;
//AVAudioPlayer* player;
}

@property (nonatomic, strong) NSData *audioData;
@property (nonatomic,strong) MPMusicPlayerController* musicPlayer;
@property(nonatomic,strong)AVAudioPlayer* player;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)browseFromMusicButtonClicked:(id)sender;
- (IBAction)playAudioButtonClicked:(id)sender;

@end
