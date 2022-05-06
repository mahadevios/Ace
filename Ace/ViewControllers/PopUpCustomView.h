//
//  PopUpCustomView.h
//  Ace
//
//  Created by mac on 06/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PopUpCustomView : UIView
{
    UIView* overlay;
    UITapGestureRecognizer* tap;
}
- (UIView*)initWithFrame:(CGRect)frame andSubViews:(NSArray*)subViewNamesArray :(id)sender;
- (UIView*)initWithFrame:(CGRect)frame  sender:(id)sender;
-(UITableView*)tableView:(id)sender frame:(CGRect)frame;
- (UIView*)initWithFrame:(CGRect)frame senderNameForSlider :(id)sender player:(AVAudioPlayer*)player;
- (UIView*)initWithFrame:(CGRect)frame offlineFrame:(CGRect)offlineFrame senderForInternetMessage :(id)sender;

@end
