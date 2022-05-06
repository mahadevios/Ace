//
//  SafariSupportViewController.h
//  Ace
//
//  Created by mac on 08/04/20.
//  Copyright © 2020 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface SafariSupportViewController : UIViewController<SFSafariViewControllerDelegate>
{
    SFSafariViewController *svc;
}
@property (nonatomic, strong) NSString* doctorMeetingUrlString;
@property (nonatomic, strong) NSString* patientMeetingUrlString;
@property (nonatomic) BOOL browserOpenedOnce;
@end

NS_ASSUME_NONNULL_END
