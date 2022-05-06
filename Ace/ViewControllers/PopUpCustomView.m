//
//  PopUpCustomView.m
//  Ace
//
//  Created by mac on 06/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "PopUpCustomView.h"
#import "Constants.h"

@implementation PopUpCustomView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//- (UIView*)initWithFrame:(CGRect)frame andSubViews:(NSArray*)subViewNamesArray :(id)sender
//{
//    self = [super initWithFrame:frame];
//    self.tag=561;
//    self.backgroundColor=[UIColor whiteColor];
//    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPopView:)];
//    tap.delegate=sender;
//
//    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
//    [overlay addGestureRecognizer:tap];
//    overlay.tag=111;
//
//    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
//
//    if (self)
//    {
//        // Initialization code
//        // initilize all your UIView components
//        UIButton* userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
//        UIView* seperatorLineView;
//        for (int i=0; i<subViewNamesArray.count; i++)
//        {
//            //userSettingsButton.titleLabel.textAlignment=NSTextAlignmentCenter;
//
//            userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height, 150, 30)];
//            if (subViewNamesArray.count>1)
//            {
//                if (i==0)
//                {
//                    seperatorLineView=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, 1)];
//                    seperatorLineView.backgroundColor=[UIColor lightGrayColor];
//                }
//
//            }
//            if (i==1)
//            {
//                userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height+14, 160, 30)];
//
//            }
//            [userSettingsButton setTitle:[subViewNamesArray objectAtIndex:i] forState:UIControlStateNormal];
//            [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            userSettingsButton.titleLabel.font=[UIFont systemFontOfSize:14];
//            [userSettingsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//
//            NSString* selector=[NSString stringWithFormat:@"%@",[subViewNamesArray objectAtIndex:i]];
//            selector = [selector stringByReplacingOccurrencesOfString:@" " withString:@""];
//            [userSettingsButton addTarget:sender action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
//
//            //    [userSettingsButton setBackgroundColor:[UIColor colorWithRed:(i*155)/255.0 green:(i*155)/255.0 blue:(i*155)/255.0 alpha:1]];
//            [self addSubview:userSettingsButton];
//            self.layer.cornerRadius=2.0f;
//            //            selectSetting
//        }
//        if (subViewNamesArray.count>1)
//        [self addSubview:seperatorLineView];
//        [overlay addSubview:self];
//    }
//    return overlay;
//}

- (UIView*)initWithFrame:(CGRect)frame andSubViews:(NSArray*)subViewNamesArray :(id)sender
{
    self = [super initWithFrame:frame];
    self.tag=561;
    self.backgroundColor=[UIColor whiteColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPopView:)];
    tap.delegate=sender;
    
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [overlay addGestureRecognizer:tap];
    overlay.tag=111;
    
    double buttonHeight = 32;
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    if (self)
    {
        // Initialization code
        // initilize all your UIView components
        UIButton* userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
        UIView* seperatorLineView;
        userSettingsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height, frame.size.width, buttonHeight)];

        for (int i=0; i<subViewNamesArray.count; i++)
        {
            //userSettingsButton.titleLabel.textAlignment=NSTextAlignmentCenter;
            
            if (subViewNamesArray.count>1)
            {
                if (i < subViewNamesArray.count-1)
                {
                    seperatorLineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/subViewNamesArray.count*(i+1), frame.size.width, 1)];
                    seperatorLineView.backgroundColor = [UIColor lightGrayColor];
                    [self addSubview:seperatorLineView];
                }
                
            }
            if (i > 0)
            {
                userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.y+userSettingsButton.frame.size.height+10, frame.size.width, buttonHeight)];
                
            }
            [userSettingsButton setTitle:[subViewNamesArray objectAtIndex:i] forState:UIControlStateNormal];
            if ([subViewNamesArray[i] isEqualToString:@"Select Locale"])
            {
                [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                userSettingsButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];

            }
            else
            {
                [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                userSettingsButton.titleLabel.font=[UIFont systemFontOfSize:14];
            }
            
            [userSettingsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            NSString* selector=[NSString stringWithFormat:@"%@",[subViewNamesArray objectAtIndex:i]];
            selector = [selector stringByReplacingOccurrencesOfString:@" " withString:@""];
            selector = [selector stringByReplacingOccurrencesOfString:@"." withString:@""];
            selector = [selector stringByReplacingOccurrencesOfString:@"(" withString:@""];
            selector = [selector stringByReplacingOccurrencesOfString:@")" withString:@""];

            [userSettingsButton addTarget:sender action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
            
            //    [userSettingsButton setBackgroundColor:[UIColor colorWithRed:(i*155)/255.0 green:(i*155)/255.0 blue:(i*155)/255.0 alpha:1]];
            [self addSubview:userSettingsButton];
            self.layer.cornerRadius=2.0f;
            //            selectSetting
        }
//        if (subViewNamesArray.count>1)
//            [self addSubview:seperatorLineView];
        [overlay addSubview:self];
    }
    return overlay;
}

-(UIView*)initWithFrame:(CGRect)frame  sender:(id)sender
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(disMissPopView:)];
    
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [overlay addGestureRecognizer:tap];
    overlay.tag=121;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    UIView* borderView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x+10, frame.origin.y+10, frame.size.width-20, frame.size.height-60)];
    borderView.layer.borderWidth=1.0f;
    borderView.layer.cornerRadius=7.0f;
    borderView.layer.borderColor=[UIColor grayColor].CGColor;
    
    if (self)
    {
        UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, borderView.frame.size.width-20, 20)];
        label1.text=@"Set your recordings abbreviation";
        label1.font=[UIFont systemFontOfSize:14];
        UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(15, label1.frame.origin.y+label1.frame.size.height+10, borderView.frame.size.width-20, 20)];
        label2.text=@"(Max 5 characters)";
        label2.font=[UIFont systemFontOfSize:14];
        
        UITextField* abbreviationTextField=[[UITextField alloc]initWithFrame:CGRectMake(15, label2.frame.origin.y+label2.frame.size.height+10, borderView.frame.size.width-30, 40)];
        abbreviationTextField.layer.borderWidth=1.0f;
        abbreviationTextField.layer.cornerRadius=7.0f;
        abbreviationTextField.layer.borderColor=[UIColor grayColor].CGColor;
        abbreviationTextField.delegate=sender;
        abbreviationTextField.tag=122;
        abbreviationTextField.placeholder=@"Enter your abbreviation";
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        abbreviationTextField.leftView = paddingView;
        abbreviationTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-200, frame.size.height-36, 80, 20)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [cancelButton addTarget:sender action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* saveButton=[[UIButton alloc]initWithFrame:CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+16, frame.size.height-36, 80, 20)];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[saveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [saveButton addTarget:sender action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:cancelButton];
        [self addSubview:saveButton];
        [borderView addSubview:label1];
        [borderView addSubview:label2];
        [borderView addSubview:abbreviationTextField];
    }
    self.layer.cornerRadius=2.0f;
    
    [overlay addSubview:self];
    [overlay addSubview:borderView];
    return overlay;
    
}

-(UITableView*)tableView:(id)sender frame:(CGRect)frame
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:frame];
    UIView* sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 50)];
    
    UILabel* sectionTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 20, tableView.frame.size.width, 17)];
    [sectionTitleLabel setFont:[UIFont systemFontOfSize:16.0]];
    
    UIFont *currentFont = sectionTitleLabel.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    sectionTitleLabel.font = newFont;
    sectionTitleLabel.text=@"Select Department";
    sectionTitleLabel.textColor = [UIColor darkTextColor];
    [sectionHeaderView addSubview:sectionTitleLabel];
    
    tableView.tableHeaderView=sectionHeaderView;
    tableView.dataSource=sender;
    tableView.delegate=sender;
    UITableViewCell * cell=[[UITableViewCell alloc]init];
//    cell.backgroundColor = [UIColor whiteColor];
    [tableView addSubview:cell];
    tableView.layer.cornerRadius=2.0f;
    tableView.backgroundColor = [UIColor whiteColor];
    return tableView;
    
}

- (UIView*)initWithFrame:(CGRect)frame senderNameForSlider :(id)sender player:(AVAudioPlayer*)player
{
    self = [super initWithFrame:frame];
    self.backgroundColor=[UIColor darkGrayColor];
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPlayerView:)];
    tap.delegate=sender;
    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [overlay addGestureRecognizer:tap];
    overlay.tag=222;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    if (self)
    {
        // Initialization code
        // initilize all your UIView components
        self.tag=223;
        UISlider* audioRecordSlider=[[UISlider alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05,self.frame.size.height*0.1 , self.frame.size.width*0.9, 30)];
        [audioRecordSlider addTarget:sender action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        //audioRecordSlider.minimumValue = 0.0;
        audioRecordSlider.continuous = YES;
        audioRecordSlider.tag=224;
        
        UILabel* dateAndTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.04, self.frame.size.height*0.5, self.frame.size.width*0.5, 20)];
        //audioRecordSlider.maximumValue=player.duration;
        [dateAndTimeLabel setFont:[UIFont systemFontOfSize:12]];
        dateAndTimeLabel.textColor=[UIColor whiteColor];
        dateAndTimeLabel.tag=225;
        
        UILabel* recordingLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.04, self.frame.size.height*0.7, self.frame.size.width*0.5, 20)];
        recordingLabel.text=@"Your recording";
        [recordingLabel setFont:[UIFont systemFontOfSize:12]];
        recordingLabel.textColor=[UIColor whiteColor];
        
        UIImageView* playAndPauseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(audioRecordSlider.frame.size.width-8, self.frame.size.height*0.6, 15, 15)];
        playAndPauseImageView.image=[UIImage imageNamed:@"Pause"];
        playAndPauseImageView.tag=226;

        UIButton* playAndPauseButton=[[UIButton alloc]initWithFrame:CGRectMake(audioRecordSlider.frame.size.width-10, self.frame.size.height*0.6, 40, 40)];
        
        [playAndPauseButton addTarget:sender action:@selector(playOrPauseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dateAndTimeLabel];
        [self addSubview:recordingLabel];
        [self addSubview:playAndPauseButton];
        [self addSubview:playAndPauseImageView];

        [self addSubview:audioRecordSlider];
    }
    [overlay addSubview:self];

    return overlay;
}


- (UIView*)initWithFrame:(CGRect)frame offlineFrame:(CGRect)offlineFrame senderForInternetMessage :(id)sender
{
    self = [super initWithFrame:frame];
//    self.backgroundColor=[UIColor redColor];
//    self.backgroundColor = [UIColor colorWithRed:47/255.0 green:79/255.0 blue:79/255.0 alpha:1];
//    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:64/255.0 blue:52/255.0 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:62/255.0 blue:51/255.0 alpha:1];


    self.layer.cornerRadius = 10.0;
    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; // black ovelrayview
    
//    UIView* offlineView = [[UIView alloc] initWithFrame:offlineFrame]; // black ovelrayview
//
//    offlineView.backgroundColor = [UIColor redColor];
//
//    UIButton* goOfflineButton = [[UIButton alloc]initWithFrame:CGRectMake((offlineView.frame.size.width/2) - 30, offlineView.frame.size.height*0.25, 60, 40)];
//
//    [goOfflineButton setFont:[UIFont systemFontOfSize:13]];
//
//    [goOfflineButton setTitle:@"Go Offline" forState:UIControlStateNormal];
//
//    [goOfflineButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//
//    [goOfflineButton addTarget:sender action:@selector(goOfflineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//
//    [offlineView addSubview:goOfflineButton];
    
    overlay.tag=222;
    
    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    NSString* alertCount=[[NSUserDefaults standardUserDefaults] valueForKey:INCOMPLETE_TRANSFER_COUNT_BADGE]; // we dont have, is user logged in first time or not, so we are using in_tr_co_ba user default value to check it. if that value found not nil means user have visited the home tab hence he was logged in
    
    

    if (self)
    {
        // Initialization code
        // initilize all your UIView components
        self.tag=223;
        
//        UILabel* dateAndTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.2, self.frame.size.width*0.9, 20)];
        
        UILabel* noInternetConnectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.15, self.frame.size.width*0.9, 20)];
        //audioRecordSlider.maximumValue=player.duration;
        noInternetConnectionLabel.text=@"No Internet Connection";
        [noInternetConnectionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        noInternetConnectionLabel.textColor=[UIColor whiteColor];
        noInternetConnectionLabel.tag=224;
        noInternetConnectionLabel.textAlignment = NSTextAlignmentCenter;
        
//
//        UIButton* playAndPauseButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*0.25 - 30, self.frame.size.height*0.5, 60, 30)];
        
//                UIButton* playAndPauseButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*0.25 - 30, self.frame.size.height*0.5, 60, 30)];
        
        if(alertCount == nil)
        {
            UIButton* retryButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*0.50 - 50, self.frame.size.height*0.5, 100, 40)];
            
            retryButton.tag=225;
            [retryButton setTitle:@"Retry" forState:UIControlStateNormal];
            [retryButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [retryButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [retryButton setBackgroundColor:[UIColor whiteColor]];
            [retryButton setTitleColor:[UIColor colorWithRed:17/255.0 green:146/255.0 blue:(CGFloat)78/255.0 alpha:1] forState:UIControlStateNormal];
            retryButton.layer.cornerRadius = 5.0;
            [retryButton addTarget:sender action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:noInternetConnectionLabel];
            [self addSubview:retryButton];
        }
        else{
            
            UIButton* retryButton;
            
            
                retryButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*0.30 - 50, self.frame.size.height*0.5, 100, 40)];
            

        
            retryButton.tag=225;
            [retryButton setTitle:@"Retry" forState:UIControlStateNormal];
            [retryButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [retryButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [retryButton setBackgroundColor:[UIColor whiteColor]];
            [retryButton setTitleColor:[UIColor colorWithRed:17/255.0 green:146/255.0 blue:(CGFloat)78/255.0 alpha:1] forState:UIControlStateNormal];
            retryButton.layer.cornerRadius = 5.0;
            [retryButton addTarget:sender action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
            
            //        UIButton* goOfflineButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*0.75 - 50, self.frame.size.height*0.5, 100, 30)];
            
            UIButton* goOfflineButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width*0.70 - 60, self.frame.size.height*0.5, 120, 40)];
            //        [goOfflineButton setFont:[UIFont systemFontOfSize:13]];
            [goOfflineButton setTitle:@"Go Offline" forState:UIControlStateNormal];
            [goOfflineButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [goOfflineButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
            [goOfflineButton setBackgroundColor:[UIColor whiteColor]];
            [goOfflineButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            goOfflineButton.layer.cornerRadius = 5.0;
            [goOfflineButton addTarget:sender action:@selector(goOfflineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:noInternetConnectionLabel];
            [self addSubview:retryButton];
            [self addSubview:goOfflineButton];
        }
    }
    [overlay addSubview:self];
//    [overlay addSubview:offlineView];
    return overlay;
}
- (UIView*)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}
//- (UIView*)initWithFrame:(CGRect)frame sender:(id)sender
//{
//    self = [super initWithFrame:frame];
//    self.backgroundColor=[UIColor whiteColor];
//    overlay= [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    tap=[[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(dismissPopView:)];
//    
//    overlay=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    [overlay addGestureRecognizer:tap];
//    overlay.tag=111;
//    
//    overlay.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
//    
//    if (self)
//    {
//        // Initialization code
//        // initilize all your UIView components
//        UIButton* userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 0, 0, 0)];
//       
//            //userSettingsButton.titleLabel.textAlignment=NSTextAlignmentCenter;
//            
//            userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height, 160, 30)];
//            if (i==1)
//            {
//                userSettingsButton=[[UIButton alloc]initWithFrame:CGRectMake(0, userSettingsButton.frame.origin.x+userSettingsButton.frame.size.height+8, 160, 30)];
//                
//            }
//            [userSettingsButton setTitle:[subViewNamesArray objectAtIndex:i] forState:UIControlStateNormal];
//            [userSettingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            userSettingsButton.titleLabel.font=[UIFont systemFontOfSize:14];
//            [userSettingsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//            
//            NSString* selector=[NSString stringWithFormat:@"%@",[subViewNamesArray objectAtIndex:i]];
//            selector = [selector stringByReplacingOccurrencesOfString:@" " withString:@""];
//            [userSettingsButton addTarget:sender action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchUpInside];
//            
//            //    [userSettingsButton setBackgroundColor:[UIColor colorWithRed:(i*155)/255.0 green:(i*155)/255.0 blue:(i*155)/255.0 alpha:1]];
//            [self addSubview:userSettingsButton];
//            self.layer.cornerRadius=2.0f;
//            //            selectSetting
//      
//        [overlay addSubview:self];
//    }
//    return overlay;
//
//
//
//
//}

@end
