//
//  SafariSupportViewController.m
//  Ace
//
//  Created by mac on 08/04/20.
//  Copyright © 2020 Xanadutec. All rights reserved.
//

#import "SafariSupportViewController.h"

@interface SafariSupportViewController ()

@end

@implementation SafariSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!self.browserOpenedOnce) {
        self.browserOpenedOnce = YES;
        svc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.doctorMeetingUrlString]];
           svc.delegate = self;
        
           [UIApplication sharedApplication].idleTimerDisabled = YES;
           [self presentViewController:svc animated:YES completion:nil];
    }
    else{
        svc = nil;
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [self dismissViewControllerAnimated:NO completion:nil];
    }
   
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
