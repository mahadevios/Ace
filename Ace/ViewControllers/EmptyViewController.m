//
//  EmptyViewController.m
//  Ace
//
//  Created by mac on 22/05/18.
//  Copyright © 2018 Xanadutec. All rights reserved.
//

#import "EmptyViewController.h"
#import "AppPreferences.h"
#import "UIColor+ApplicationColors.h"

@interface EmptyViewController ()

@end

@implementation EmptyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.usedByVCName isEqualToString:@"VRSVC"])
    {
       
        
        [self setnavigationView];
        
        [self setEmptyVCForDocFileView:0];
    }
}

-(void)setnavigationView
{
    double secondVCWidth = self.view.frame.size.width - self.splitViewController.primaryColumnWidth;
    
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0,0, secondVCWidth, 64)];
    
    self.navigationView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];

//    self.navigationView.backgroundColor = [UIColor redColor];

    self.navigationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.navigationView.center.x-50, self.navigationView.frame.size.height/2 - 5, 100, 30)];
    
//    [self.navigationTitleLabel sizeToFit];
    
    self.navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navigationTitleLabel.textColor = [UIColor appOrangeColor];
    
    self.navigationTitleLabel.text = @"Text File";
    
    self.navigationTitleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y + 10, secondVCWidth, self.view.frame.size.height)];
    
    self.webView.delegate = self;
    
    self.textFileContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.navigationView.frame.size.height + 10, secondVCWidth, self.view.frame.size.height)];
    
    self.textFileContentTextView.userInteractionEnabled = NO;
    
    [self.navigationView addSubview:self.navigationTitleLabel];
    
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.textFileContentTextView];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationTitleLabel
//                                                                          attribute:NSLayoutAttributeCenterY
//                                                                          relatedBy:NSLayoutRelationEqual
//                                                                             toItem:self.navigationView
//                                                                          attribute:NSLayoutAttributeCenterY
//                                                                         multiplier:1.0
//                                                                           constant:0.0]];
    
}

-(void)setEmptyVCForDocFileView:(int)index
{
    if (self.splitViewController != nil && self.splitViewController.isCollapsed == false) // if not collapsed that is reguler width hnce ipad
    {
        if (self.dataToShowCount > 0)
        {
            
            [self showDocxFile:self.docxFileToShowPath];
        }
    }
}

-(void)showDocxFile:(NSString*)docxFileToShowPath
{

    
//    [[AppPreferences sharedAppPreferences] showHudWithTitle:@"Opening File" detailText:@"Please wait.."];
//
//    if ([self.view viewWithTag:1000] == nil)
//    {
//        [self.view addSubview:self.webView];
//
//        self.webView.tag = 1000;
//    }
//
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:docxFileToShowPath isDirectory:NO]]];

//    if ([self.view viewWithTag:2000] == nil)
//    {
//        [self.view addSubview:self.textFileContentTextView];
//
//        self.textFileContentTextView.tag = 2000;
//    }
    
    NSURL* url = [NSURL fileURLWithPath:docxFileToShowPath isDirectory:NO];
    
    self.textFileContentTextView.text = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    
    return self;
}

-(void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller
{
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
    
    //});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
