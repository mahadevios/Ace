//
//  DocFilesViewController.m
//  Ace
//
//  Created by mac on 20/11/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import "DocFilesViewController.h"
#import "Database.h"
#import "APIManager.h"
#import "AppPreferences.h"
#import "Constants.h"
#import "EditDocxViewController.h"
#import "CustomObjectForTableViewCell.h"
#import "ApprovalFile.h"

@interface DocFilesViewController ()

@end

@implementation DocFilesViewController
@synthesize overLayView,scrollView,commentTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateCompletedDocResponse:) name:NOTIFICATION_COMPLETED_DOC_LIST
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateFileDownloadResponse:) name:NOTIFICATION_FILE_DOWNLOAD_API
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateCommentResponse:) name:NOTIFICATION_SEND_COMMENT_API
                                               object:nil];
    self.navigationItem.title=@"Approval Queue";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonClicked:)];

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Last 5 days" style:UIBarButtonItemStylePlain target:self action:@selector(showFilterSettings:)];
    
//    [self setRightBarButtonItem:@"Last 5 Days"];

//    [self getCompletedFilesForDepartment];
    self.completedFilesResponseArray = [NSMutableArray new];
    
    popupView=[[UIView alloc]init];
    
    forTableViewObj=[[PopUpCustomView alloc]init];
    
//    changeDeptCalled =  true;
    
//    [self ChangeDepartment];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_DEPARTMENT_NAME];

    DepartMent *deptObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    selectedDepartment = deptObj.departmentName;
    
    [self setSearchController];
    [self.tabBarController.tabBar setHidden:YES];

    [self beginAppearanceTransition:true animated:true];
    
    self.splitViewController.delegate = self;
    
    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    
    self.definesPresentationContext = true;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
   // self.navigationController.navigationBar.translucent = NO;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
  
   
//    if (changeDeptCalled) {
//        changeDeptCalled = false;
//    }else{
        [self getCompletedFilesForDepartment];
    
    self.searchController.searchBar.text = @"";
//    }
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        self.splitViewController.delegate = self;
//        
//        [self beginAppearanceTransition:true animated:true];
//        
//        [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
//    }
    
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    // to avoid first responder yes when clicked on file upload yes
    if (!searchBecomeResponsderFromUploadAlert)
    {
        return YES;
    }
    else
    {
        searchBecomeResponsderFromUploadAlert = NO;
        return NO;
    }
    
}
-(void)setSearchController
{
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.searchBarBGView addSubview:self.searchController.searchBar];
//    if (UIScreen.mainScreen.traitCollection.userInterfaceStyle==UIUserInterfaceStyleDark){
//             self.searchController.searchBar.barTintColor = [UIColor whiteColor];
//             self.searchController.searchBar.searchTextField.textColor = [UIColor blackColor];
//        self.searchController.searchBar.searchTextField.leftView.tintColor = [UIColor blackColor];
//
//         }
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    //    self.tableView.tableHeaderView = self.searchController.searchBar;
//        self.navigationController.definesPresentationContext = YES;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    //    self.navigationController.definesPresentationContext = YES;
}


-(void)prepareForSearchBar
{
 
    self.completedFilesResponsePredicateArray = [[NSMutableArray alloc] initWithArray:self.completedFilesResponseArray];
//    self.transferredListPredicateArray = [APIManager sharedManager].transferredListArray;
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        [self.searchController.searchBar setShowsCancelButton:NO animated:NO];
    }
   
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    [searchController.searchBar setShowsCancelButton:YES animated:NO];
        
    
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        self.completedFilesResponseArray = [[NSMutableArray alloc] initWithArray:self.completedFilesResponsePredicateArray];
        [self.tableView reloadData];
        
    }
    else
    {
//        NSArray *commonArray = [[NSMutableArray alloc]init];
        
        NSArray *predicateResultArray = [[NSMutableArray alloc]init];
                
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"OriginalFileName CONTAINS [cd] %@", self.searchController.searchBar.text];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"PatientName CONTAINS [cd] %@", self.searchController.searchBar.text];
        NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"DictationUploadDate CONTAINS [cd] %@", self.searchController.searchBar.text];
//        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"department.departmentName CONTAINS [cd] %@", self.searchController.searchBar.text];
        
        NSPredicate *mainPredicate;
        
       
            
//            commonArray = [[Database shareddatabase] getListOfTransferredOrDeletedFiles:@"Transferred"];
//            transferDatePredicate = [NSPredicate predicateWithFormat:@"transferDate CONTAINS [cd] %@", self.searchController.searchBar.text];

            mainPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate2, predicate3]];

        
  
        
        predicateResultArray = [self.completedFilesResponsePredicateArray filteredArrayUsingPredicate:mainPredicate];
        
        
        self.completedFilesResponseArray = [NSMutableArray arrayWithArray:predicateResultArray];
       
        
        [self.tableView reloadData];
    }
    
}
-(void)updateSerachBarManually
{
    self.searchController.active = YES;
    self.searchController.searchBar.text = self.searchController.searchBar.text;
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    
    [searchBar resignFirstResponder];
    
    [self prepareDataSourceForTableView];
    
//    [self.searchController.searchBar setShowsCancelButton:NO];
    [self.searchController.searchBar setShowsCancelButton:NO animated:YES];
    [self.tableView reloadData];
}

-(void)prepareDataSourceForTableView
{
//        [APIManager sharedManager].transferredListArray = [[Database shareddatabase] getListOfTransferredOrDeletedFiles:@"Transferred"];
//
//        [APIManager sharedManager].deletedListArray = [[Database shareddatabase] getListOfTransferredOrDeletedFiles:@"Deleted"];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];

}




-(void) showDepartment
{
    NSArray* subViewArray=[NSArray arrayWithObjects:@"Change Department", nil];
    
    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, self.view.frame.origin.y+40, 160, 40) andSubViews:subViewArray :self];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:pop];
    
}

-(void)ChangeDepartment
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
    CGRect frame=CGRectMake(10.0f, self.view.center.y-150, self.view.frame.size.width - 20.0f, 200.0f);
    
    UITableView* tab= [forTableViewObj tableView:self frame:frame];
    
    [popupView addSubview:tab];
    
    //[popupView addGestureRecognizer:tap];
    [popupView setFrame:[[UIScreen mainScreen] bounds]];
    
    //[popupView addSubview:[self.view viewWithTag:504]];
    UIView *buttonsBkView = [[UIView alloc] initWithFrame:CGRectMake(tab.frame.origin.x, tab.frame.origin.y + tab.frame.size.height, tab.frame.size.width, 70.0f)];
    
    buttonsBkView.backgroundColor = [UIColor whiteColor];
    
    [popupView addSubview:buttonsBkView];
    
    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-200, 20.0f, 80, 30)];
    
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    //[cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* saveButton=[[UIButton alloc]initWithFrame:CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+16, 20.0f, 80, 30)];
    
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    
    [saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[saveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonsBkView addSubview:cancelButton];
    
    [buttonsBkView addSubview:saveButton];
    
    
    popupView.tag=504;
    
    [popupView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:popupView];
    
}

-(void)cancel:(id)sender
{
    [popupView removeFromSuperview];
    
//    [self.navigationController popViewControllerAnimated:true];
}

-(void)save:(id)sender
{
   
    if ([selectedDepartment isEqualToString:@""] || selectedDepartment == nil) {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:@"Please select department" withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
    }else{
        [popupView removeFromSuperview];
        
        [self getCompletedFilesForDepartment];
    }
    
    //call completed doc api
}

-(void)getCompletedFilesForDepartment
{
    self.completedFilesResponseArray = nil;
    
    self.uploadedFilesArray = nil;
    
    self.completedFilesForTableViewArray = nil;
    
    self.downloadingFilesDictationIdsArray = nil;
    
    self.completedFilesResponseArray = [NSMutableArray new];
    
    self.uploadedFilesArray = [NSMutableArray new];
    
    self.completedFilesForTableViewArray = [NSMutableArray new];
    
    self.downloadingFilesDictationIdsArray = [NSMutableArray new];
    
//    self.uploadedFilesArray = [[Database shareddatabase] getUploadedFileList];
    
//    NSArray* uploadedFilesDictationIdArray = [[Database shareddatabase] getUploadedFilesDictationIdList:true filterDate:filterDaysNumber];
    
//    NSString* uploadedFilesDictationIdString = [uploadedFilesDictationIdArray componentsJoinedByString:@","];
    
    //uploadedFilesDictationIdString = [uploadedFilesDictationIdString stringByAppendingString:@",6987636"];
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        [[AppPreferences sharedAppPreferences] showHudWithTitle:@"Loading Files..." detailText:@"Please wait"];
        
        NSString* departmentId = [[Database shareddatabase] getDepartMentIdFromDepartmentName:selectedDepartment];
        [[APIManager sharedManager] getCompletedDoc:departmentId];
//        [[APIManager sharedManager] sendDictationIds:uploadedFilesDictationIdString];
    }
    
}

- (void)moreButtonClicked:(id)sender
{
    [self ChangeDepartment];
//    NSArray* subViewArray=[NSArray arrayWithObjects:@"Change Department", nil];
//
//    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-160, self.view.frame.origin.y+40, 160, 40) andSubViews:subViewArray :self];
//
//    [[[UIApplication sharedApplication] keyWindow] addSubview:pop];
}

-(void)setRightBarButtonItem:(NSString*)barButtonTitleString
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Last 5 days" style:UIBarButtonItemStylePlain target:self action:@selector(showFilterSettings:)];
    NSArray* daysArray = [barButtonTitleString componentsSeparatedByString:@" "];
    NSString* dayString = [daysArray objectAtIndex:1];
//    self.navigationItem.rightBarButtonItem = nil;
    
//    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithTitle:barButtonTitleString style:UIBarButtonItemStylePlain target:self action:@selector(showFilterSettings:)];
    
    UIButton* rightBarCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 30)];
    

    [rightBarCustomButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    
    [rightBarCustomButton setTitle:barButtonTitleString forState:UIControlStateNormal];
    
    [rightBarCustomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
//    [rightBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                            [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName,
//                                            [UIColor darkGrayColor], NSForegroundColorAttributeName,
//                                            nil] forState:UIControlStateNormal];
    
    rightBarCustomButton.adjustsImageWhenHighlighted = NO;
    
    [rightBarCustomButton addTarget:self action:@selector(showFilterSettings:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBarCustomButton];
    
    self.navigationItem.rightBarButtonItem = barBtn;
    
}
-(void)popViewController:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.searchBarBGView removeFromSuperview];
    
    if (self.splitViewController.isCollapsed == true || self.splitViewController == nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:false completion:nil];
    }
    [self.tabBarController.tabBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchController removeFromParentViewController];
}
-(void)validateCompletedDocResponse:(NSNotification*)obj
{
    NSString* response = obj.object;
   
    [self.completedFilesResponseArray removeAllObjects];
    
//    [self.completedFilesForTableViewArray removeAllObjects];
    
    NSArray* aprovalList = [response valueForKey:@"ApprovalList"];
    
   
        for (int i=0; i<aprovalList.count; i++)
        {
//            PatientDateofBirth
            ApprovalFile* file = [ApprovalFile new];
            NSDictionary* dic = [aprovalList objectAtIndex:i];
    
            file.DictationID = [dic valueForKey:@"DictationID"];
            file.PatientDateofBirth = [dic valueForKey:@"PatientDateofBirth"];

            file.DictationUploadDate = [dic valueForKey:@"DictationUploadDate"];
            file.ErrorMsg = [dic valueForKey:@"ErrorMsg"];
            file.FileLockStatus = [dic valueForKey:@"FileLockStatus"];
            file.FileLockedToolTip = [dic valueForKey:@"FileLockedToolTip"];
            file.IsErrorMsg = [dic valueForKey:@"IsErrorMsg"];
            file.OriginalFileName = [dic valueForKey:@"OriginalFileName"];
            file.PatientName = [dic valueForKey:@"PatientName"];
            file.Signals = [dic valueForKey:@"Signals"];
            file.SignalsToolTip = [dic valueForKey:@"SignalsToolTip"];
            [self.completedFilesResponseArray addObject:file];
        }
//    AudioDetails* ad = [AudioDetails new];
//    
//    ad.fileName = @"test";
    
 

//
//    for (int i=0; i<completedFilesResponseArray.count; i++)
//    {
//        NSDictionary* dic = [completedFilesResponseArray objectAtIndex:i];
//
//        NSString* dictationId = [dic valueForKey:@"DictationID"];
//
//        [self.completedFilesResponseArray addObject:dictationId];
//    }
//
//    for (int i=0; i<self.uploadedFilesArray.count; i++)
//    {
//        AudioDetails* audioDetails = [self.uploadedFilesArray objectAtIndex:i];
//
//        NSString* dictationId = [NSString stringWithFormat:@"%d", audioDetails.mobiledictationidval];
//
//        if ([self.completedFilesResponseArray containsObject:dictationId])
//        {
//            [self.completedFilesForTableViewArray addObject:audioDetails];
//        }
//        else
//        {
//        }
//    }
    
    [self prepareForSearchBar];
    [self.tableView reloadData];

}


-(void)validateFileDownloadResponse:(NSNotification*)obj
{
    NSDictionary* response = obj.object;
    
    //NSString* byteCodeString = [response valueForKey:@"ByteDocForDownload"];
    
//    NSString* dictationId = [response valueForKey:@"DictationId"];
    //NSString* dictationId = @"8103552";

    NSString* dictationID = [response valueForKey:@"DictationID"];

    for (int i = 0; i< self.completedFilesForTableViewArray.count; i++)
    {
        AudioDetails* audioDetails = [self.completedFilesForTableViewArray objectAtIndex:i];
        
        if (audioDetails.mobiledictationidval == [dictationID intValue])
        {
            audioDetails.downloadStatus = DOWNLOADED;
            
            [self.completedFilesForTableViewArray replaceObjectAtIndex:i withObject:audioDetails];
            
            [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:i inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [[Database shareddatabase] updateDownloadingStatus:DOWNLOADED dictationId:[dictationID intValue]];
}

-(void)validateCommentResponse:(NSNotification*)notification
{    
    [self removeCommentView];

}
-(void)addMoreView:(TableViewButton*)sender
{
    CGRect rect = sender.frame;
    [self addPopView:sender];
}

-(void)addCommentView:(TableViewButton*)sender
{
    
//    overLayView = [[UIView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
//    [self.navigationController.navigationBar setHidden:true];
    
    overLayView = [[UIView alloc] initWithFrame:self.view.frame];

    overLayView.tag = 222;
    
    overLayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer* tapToDismissNotif = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    
    [overLayView addGestureRecognizer:tapToDismissNotif];
    
    tapToDismissNotif.delegate = self;
    
//    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, -100, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73)];
//
//    self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.09, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.1, -self.view.frame.size.height, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73)];
    
//    self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.09, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);
    
    scrollView.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    UIView* insideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 500)];
    
    insideView.backgroundColor = [UIColor whiteColor];
    
    scrollView.layer.cornerRadius = 4.0;
    
    insideView.layer.cornerRadius = 4.0;
    
    UILabel* referenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(insideView.frame.size.width/2 - 100, 10, 200, 35)];
    
    referenceLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"Approve"])
    {
        referenceLabel.text = @"Comment & Approve";
    }
    else
    {
        referenceLabel.text = @"Comment & For Approval";
    }
    referenceLabel.textColor = [UIColor appOrangeColor];
    
    UIImageView* referenceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(insideView.frame.size.width/2 - 60, 14, 17, 23)];
    
    referenceImageView.image = [UIImage imageNamed:@"Referral"];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, referenceLabel.frame.origin.y + referenceLabel.frame.size.height + 10, insideView.frame.size.width, 2)];
    
    lineView.backgroundColor = [UIColor appOrangeColor];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(insideView.frame.size.width*0.07, lineView.frame.origin.y + lineView.frame.size.height + 20, insideView.frame.size.width*0.86, 110)];
    
    //UIView* paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    
    //textField.leftView = paddingView;
    
    //textField.leftViewMode = UITextFieldViewModeAlways;
    
    commentTextView.font = [UIFont systemFontOfSize:14.0];
    
    commentTextView.delegate = self;
    
    TableViewButton* submitButton = [[TableViewButton alloc] initWithFrame:CGRectMake(commentTextView.frame.origin.x+commentTextView.frame.size.width*0.05, commentTextView.frame.origin.y + commentTextView.frame.size.height + 20, commentTextView.frame.size.width*0.9, 35)];
    
    submitButton.layer.cornerRadius = 4.0;
    
    submitButton.indexPathRow = sender.indexPathRow;
    
    submitButton.backgroundColor = [UIColor appOrangeColor];
    
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    textView.placeholder = @"Comment here";
    
    commentTextView.layer.borderColor = [UIColor colorWithRed:196/255.0 green: 204/255.0 blue: 210/255.0 alpha: 1.0].CGColor;
    
    commentTextView.layer.borderWidth = 1.0;
    
    commentTextView.layer.cornerRadius = 4.0;
    
    [insideView addSubview:referenceLabel];
    [insideView addSubview:referenceImageView];
    [insideView addSubview:lineView];
    [insideView addSubview:commentTextView];
    
    [insideView addSubview:submitButton];
    
    [scrollView addSubview:insideView];
    
    [overLayView addSubview:scrollView];
    
//    [self.view addSubview:overLayView];

    [[UIApplication sharedApplication].keyWindow addSubview:overLayView];

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{

//            self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.09, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);

        self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.09, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);
        
        } completion:^(BOOL finished) {

        }];
    
//    overLayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        overLayView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished){
//        // do something once the animation finishes, put it here
//    }];
}


-(void)addDetailsViewindexPathRow:(TableViewButton*)sender
{
    overLayView = [[UIView alloc] initWithFrame:self.view.frame];

    overLayView.tag = 222;

    overLayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    UITapGestureRecognizer* tapToDismissNotif = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crossButtonTapped:)];

    [overLayView addGestureRecognizer:tapToDismissNotif];

    tapToDismissNotif.delegate = self;
   
    float popupHeight = 0.0;
    
    NSDictionary* docDetails = [self.completedFilesResponseArray objectAtIndex:sender.indexPathRow];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, 170)];
    
     self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.05, -self.view.frame.size.height, self.view.frame.size.width*0.9, 170);
    
    scrollView.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    

    scrollView.backgroundColor = [UIColor whiteColor];
    
    UIView* insideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 200)];
    
    insideView.backgroundColor = [UIColor whiteColor];
    
    scrollView.layer.cornerRadius = 4.0;
    
    insideView.layer.cornerRadius = 4.0;
    
    UILabel* referenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(insideView.frame.size.width/2 - 100, 12, 200, 40)];
    
    referenceLabel.textAlignment = NSTextAlignmentCenter;
    
    referenceLabel.text = @"Document Details";
    
    referenceLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
    
    referenceLabel.textColor = [UIColor appOrangeColor];
    
    
    UIView* headingSeparatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, referenceLabel.frame.origin.y + referenceLabel.frame.size.height + 5, insideView.frame.size.width, 1)];
    headingSeparatorLineView.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    UIImageView* crossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(insideView.frame.size.width - 40, 20, 20, 20)];
    
    crossImageView.image = [UIImage imageNamed:@"Cross"];
    
    UIButton* crossButton = [[UIButton alloc] initWithFrame:CGRectMake(insideView.frame.size.width - 60, 0, 60, 60)];
    
    [crossButton setBackgroundColor:[UIColor clearColor]];
    
    [crossButton addTarget:self action:@selector(crossButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   
    float titleLabelXPosition = insideView.frame.size.width*0.05;
    float titleValueLabelXPosition = insideView.frame.size.width*0.49;

    UILabel* dictationIdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, headingSeparatorLineView.frame.origin.y + headingSeparatorLineView.frame.size.height+10 , insideView.frame.size.width*0.4, 30)];

    dictationIdTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];

    dictationIdTitleLabel.font = [UIFont systemFontOfSize:14];

    dictationIdTitleLabel.text = @"File Name";

    UILabel* dictationIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, headingSeparatorLineView.frame.origin.y + headingSeparatorLineView.frame.size.height+10, insideView.frame.size.width*0.5, 30)];

    dictationIdLabel.font = [UIFont systemFontOfSize:14];

    dictationIdLabel.text = [NSString stringWithFormat:@"%@",[docDetails valueForKey:@"OriginalFileName"]];

    dictationIdLabel.numberOfLines = 0;
   
    dictationIdLabel.textColor = [UIColor grayColor];

    CGRect newFrame3 = [self getLabelSize:dictationIdLabel];
   
    dictationIdLabel.frame = newFrame3;
    
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, dictationIdLabel.frame.origin.y + dictationIdLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
//
  
    UILabel* patientNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, separatorLineView.frame.origin.y + separatorLineView.frame.size.height+10 , insideView.frame.size.width*0.5, 30)];
    
    patientNameTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    
    patientNameTitleLabel.font = [UIFont systemFontOfSize:14];
    
    patientNameTitleLabel.text = @"Patient's Name";
    
    UILabel* patientNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, separatorLineView.frame.origin.y + separatorLineView.frame.size.height+10, insideView.frame.size.width*0.4, 30)];
    
    patientNameLabel.font = [UIFont systemFontOfSize:14];
    
    patientNameLabel.text = [docDetails valueForKey:@"PatientName"];
    
    patientNameLabel.numberOfLines = 0;
   
    patientNameLabel.textColor = [UIColor grayColor];

    
    CGRect newFrame = [self getLabelSize:patientNameLabel];
    
    patientNameLabel.frame = newFrame;
    
//    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, patientNameLabel.frame.origin.y + patientNameLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
//    separatorLineView1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
//
//    UILabel* originalFileNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, separatorLineView1.frame.origin.y + 10 , insideView.frame.size.width*0.5, 30)];
//
//    originalFileNameTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
//
//    originalFileNameTitleLabel.font = [UIFont systemFontOfSize:14];
//
//    originalFileNameTitleLabel.text = @"Original File Name";
//
//    UILabel* originalFileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, separatorLineView1.frame.origin.y + 10, insideView.frame.size.width*0.4, 30)];
//
//    originalFileNameLabel.font = [UIFont systemFontOfSize:14];
//
//    originalFileNameLabel.text = [docDetails valueForKey:@"OriginalFileName"];
//
//
//    originalFileNameLabel.numberOfLines = 0;
//
//    CGRect newFrame1 = [self getLabelSize:originalFileNameLabel];
//
//    originalFileNameLabel.frame = newFrame1;
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, patientNameLabel.frame.origin.y + patientNameLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
    separatorLineView2.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    
    UILabel* patientDOBTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, separatorLineView2.frame.origin.y + 10 , insideView.frame.size.width*0.4, 30)];
    
    patientDOBTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    
    patientDOBTitleLabel.font = [UIFont systemFontOfSize:14];
    
    patientDOBTitleLabel.text = @"Patient's DOB";
    
    CGRect newFrame1 = [self getLabelSize:patientDOBTitleLabel];
    
    patientDOBTitleLabel.numberOfLines = 0;
    
    patientDOBTitleLabel.frame = newFrame1;
    
    UILabel* patientDOBLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, separatorLineView2.frame.origin.y + 10, insideView.frame.size.width*0.5, 30)];
    
    patientDOBLabel.font = [UIFont systemFontOfSize:14];
    
    patientDOBLabel.text = [NSString stringWithFormat:@"%@",[docDetails valueForKey:@"PatientDateofBirth"]];
    
    patientDOBLabel.textColor = [UIColor grayColor];

    CGRect newFrame2 = [self getLabelSize:patientDOBLabel];
    
    patientDOBLabel.numberOfLines = 0;
    
    patientDOBLabel.frame = newFrame2;
    

    
    UIView* separatorLineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, patientDOBTitleLabel.frame.origin.y + patientDOBTitleLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
    separatorLineView3.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    
    UILabel* uploadedDateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, separatorLineView3.frame.origin.y + 10 , insideView.frame.size.width*0.4, 30)];
    
    uploadedDateTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
    
    uploadedDateTitleLabel.font = [UIFont systemFontOfSize:14];
    
    uploadedDateTitleLabel.text = @"Dictation Upload Date";
    
    CGRect newFrame4 = [self getLabelSize:uploadedDateTitleLabel];
    
    uploadedDateTitleLabel.numberOfLines = 0;
    
    uploadedDateTitleLabel.frame = newFrame4;
    
    UILabel* uploadedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, separatorLineView3.frame.origin.y + 10, insideView.frame.size.width*0.5, 30)];
    
    uploadedDateLabel.font = [UIFont systemFontOfSize:14];
    
    uploadedDateLabel.text = [NSString stringWithFormat:@"%@",[docDetails valueForKey:@"DictationUploadDate"]];
    
    uploadedDateLabel.textColor = [UIColor grayColor];

    CGRect newFrame5 = [self getLabelSize:uploadedDateLabel];
    
    uploadedDateLabel.numberOfLines = 0;
    
    uploadedDateLabel.frame = newFrame5;
    
    
    popupHeight = referenceLabel.frame.size.height + dictationIdLabel.frame.size.height + patientNameLabel.frame.size.height+ patientDOBLabel.frame.size.height + uploadedDateTitleLabel.frame.size.height+80;//80 = addn of dist betwn 2 lines

    [insideView addSubview:referenceLabel];
    [insideView addSubview:crossButton];
    [insideView addSubview:crossImageView];
    [insideView addSubview:headingSeparatorLineView];
    
    [insideView addSubview:dictationIdTitleLabel];
    [insideView addSubview:dictationIdLabel];
    [insideView addSubview:separatorLineView];
    
    [insideView addSubview:patientNameTitleLabel];
    [insideView addSubview:patientNameLabel];
    [insideView addSubview:patientDOBTitleLabel];
    [insideView addSubview:patientDOBLabel];
//    [insideView addSubview:separatorLineView1];
//
//    [insideView addSubview:originalFileNameTitleLabel];
//    [insideView addSubview:originalFileNameLabel];
    [insideView addSubview:separatorLineView2];
    [insideView addSubview:separatorLineView3];

    [insideView addSubview:uploadedDateTitleLabel];
    [insideView addSubview:uploadedDateLabel];
//    [insideView addSubview:separatorLineView3];
    
    
        
    [scrollView addSubview:insideView];
    
    [overLayView addSubview:scrollView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:overLayView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
   
    self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.09, self.view.frame.size.width*0.9, popupHeight);
 
    } completion:^(BOOL finished) {
        
    }];
    
    //    overLayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    //    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //        overLayView.transform = CGAffineTransformIdentity;
    //    } completion:^(BOOL finished){
    //        // do something once the animation finishes, put it here
    //    }];
}

-(CGRect)getLabelSize:(UILabel*)label
{
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width, FLT_MAX);
//
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];

    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    if (expectedLabelSize.height < 30) {
        expectedLabelSize.height = 30;
    }
    newFrame.size.height = expectedLabelSize.height;
    return newFrame;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Comment here"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Comment here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(void)submitButtonClicked:(TableViewButton*)sender
{
    if ([commentTextView.text  isEqual: @""])
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Invalid Comment" withMessage:@"Please enter a valid comment" withCancelText:@"Cancel" withOkText:@"Ok" withAlertTag:1000];
    }
    else
    {
        AudioDetails* audioDetails = [self.completedFilesForTableViewArray objectAtIndex:sender.indexPathRow];
        [[APIManager sharedManager] sendComment:commentTextView.text dictationId:[NSString stringWithFormat:@"%d",audioDetails.mobiledictationidval]];
        [commentTextView resignFirstResponder];
    }
    
}

-(void)tapped:(UIGestureRecognizer*)touch
{
    
    [self removeCommentView];
//    overLayView.transform = CGAffineTransformIdentity;
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        overLayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    } completion:^(BOOL finished){
//         [overLayView removeFromSuperview];
//    }];
}

-(void)crossButtonTapped:(UIButton*)touch
{
//    [self.navigationController.navigationBar setHidden:false];

    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        
        //            self.scrollView.frame = CGRectMake(-self.view.frame.size.width, -self.view.frame.size.height*0.09, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);

        self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.1, -self.view.frame.size.height, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);
        //[self.scrollView removeFromSuperview];
        overLayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        
    } completion:^(BOOL finished) {
        
        [[[UIApplication sharedApplication].keyWindow viewWithTag:222] removeFromSuperview];

//        [[self.view viewWithTag:222] removeFromSuperview];
        
    }];
    
}

-(void)removeCommentView
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        
        //            self.scrollView.frame = CGRectMake(-self.view.frame.size.width, -self.view.frame.size.height*0.09, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);
        
        self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.1, -self.view.frame.size.height, self.view.frame.size.width*0.8, self.view.frame.size.height*0.73);
        
    } completion:^(BOOL finished) {
        
//        [[self.view viewWithTag:222] removeFromSuperview];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:222] removeFromSuperview];

//        [self.navigationController.navigationBar setHidden:false];

    }];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];

    UIView* commentOrDetailsView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:222];

    if(touch.view == commentOrDetailsView || touch.view == popUpView)
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 3;
    if (tableView == self.tableView) {
        return self.completedFilesResponseArray.count;
//        return self.completedFilesForTableViewArray.count;
    }
    else{
        Database* db=[Database shareddatabase];
        
        departmentNamesArray=[db getDepartMentNames];
        
        return departmentNamesArray.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
    return 80;
    }
    else{
        return 50;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     
        ApprovalFile* docDetails = [self.completedFilesResponseArray objectAtIndex:indexPath.row];
        NSString* OriginalFileName =    docDetails.OriginalFileName;
        
        NSString* FileLockStatus =  docDetails.FileLockStatus;
        NSString* FileLockedToolTip =  docDetails.FileLockedToolTip;
        NSString* Signals =  docDetails.Signals;
        NSString* IsErrorMsg =  docDetails.IsErrorMsg;
        NSString* PatientName =  docDetails.PatientName;

        NSString* SignalsToolTip =  docDetails.SignalsToolTip;
        NSString* ErrorMsg =  docDetails.ErrorMsg;

        BOOL  isErrorPresent = false, isFileLockPresent = false;
        if ([IsErrorMsg isEqualToString:@"true"]){
            isErrorPresent = true;
        }
        if ([FileLockStatus isEqualToString:@"3"]){
            isFileLockPresent = true;
        }
        
        double width = 0.0;
//        if (isFileLockPresent && isErrorPresent) {
            width = (cell.frame.size.width - 20)/3 - 2;
//        }else{
//            width = (cell.frame.size.width - 20)/2 - 1.5;
//        }
        
        if ([cell viewWithTag:101] != nil) {
            [[cell viewWithTag:101] removeFromSuperview];
        }
        TableViewButton* signalButton = [[TableViewButton alloc] initWithFrame:CGRectMake(10, cell.frame.size.height-29, width, 29)];
        [signalButton addTarget:self action:@selector(signalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        signalButton.indexPathRow = indexPath.row;
        signalButton.messageString = SignalsToolTip;
        [signalButton setTitle:@"File Status" forState:UIControlStateNormal];
        [signalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [signalButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [signalButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//        [signalButton setBackgroundColor:[UIColor redColor]];
        signalButton.tag = 101;
        [cell addSubview:signalButton];
        
        TableViewButton* errorButton;
//        TableViewButton* lockButton;
        if ([IsErrorMsg isEqualToString:@"true"]){
            double xPos = 0.0;
//            if (isFileLockPresent) {
                xPos = signalButton.frame.origin.x + signalButton.frame.size.width + 3;
//            }else{
//                xPos = cell.frame.size.width*0.5+7;
//            }
            
            if ([cell viewWithTag:102] != nil) {
                [[cell viewWithTag:102] removeFromSuperview];
//                isErrorButtonAdded = true;
                
               
                errorButton = [[TableViewButton alloc] initWithFrame:CGRectMake(xPos, cell.frame.size.height-29, signalButton.frame.size.width, signalButton.frame.size.height)];
                [errorButton setImage:[UIImage imageNamed:@"WarningRed"] forState:UIControlStateNormal];
                errorButton.messageString = ErrorMsg;
                [errorButton setTitle:@"Error" forState:UIControlStateNormal];
                errorButton.tag = 102;
                [errorButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [errorButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [errorButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//                [errorButton setBackgroundColor:[UIColor blueColor]];
                errorButton.indexPathRow = indexPath.row;
                [errorButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:errorButton];
            }else{
               
                errorButton = [[TableViewButton alloc] initWithFrame:CGRectMake(xPos, cell.frame.size.height-29, signalButton.frame.size.width, signalButton.frame.size.height)];
                [errorButton setImage:[UIImage imageNamed:@"WarningRed"] forState:UIControlStateNormal];
                errorButton.messageString = ErrorMsg;
                [errorButton setTitle:@"Error" forState:UIControlStateNormal];
                [errorButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [errorButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [errorButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//                [errorButton setBackgroundColor:[UIColor blueColor]];
                errorButton.tag = 102;
                errorButton.indexPathRow = indexPath.row;
                [errorButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:errorButton];
            }
          
        }else{
            if ([cell viewWithTag:102] != nil) {
                [[cell viewWithTag:102] removeFromSuperview];
            }
        }
        
        
        
       if ([FileLockStatus isEqualToString:@"3"]){
           double xPos = 0.0;
           if (isErrorPresent) {
               xPos = cell.frame.size.width*0.66-7;
//               xPos = errorButton.frame.origin.x + errorButton.frame.size.width + 3;
           }else{
               xPos = signalButton.frame.origin.x + signalButton.frame.size.width + 3;
//               xPos = signalButton.frame.origin.x + signalButton.frame.size.width + 3;
           }
           if ([cell viewWithTag:103] != nil) {
               [[cell viewWithTag:103] removeFromSuperview];
               
               TableViewButton* lockButton = [[TableViewButton alloc] initWithFrame:CGRectMake(xPos, cell.frame.size.height-29, signalButton.frame.size.width, signalButton.frame.size.height)];
               [lockButton setImage:[UIImage imageNamed:@"LockBlue"] forState:UIControlStateNormal];
               lockButton.messageString = FileLockedToolTip;
               [lockButton setTitle:@"File Lock" forState:UIControlStateNormal];
               lockButton.tag = 103;
               [lockButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
               [lockButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
               [lockButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//               [lockButton setBackgroundColor:[UIColor yellowColor]];
               lockButton.indexPathRow = indexPath.row;
               [lockButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
               [cell addSubview:lockButton];
           }else{
            
               TableViewButton* lockButton = [[TableViewButton alloc] initWithFrame:CGRectMake(xPos, cell.frame.size.height-29, signalButton.frame.size.width, signalButton.frame.size.height)];
               [lockButton setImage:[UIImage imageNamed:@"LockBlue"] forState:UIControlStateNormal];
               [lockButton setTitle:@"File Lock" forState:UIControlStateNormal];
               lockButton.messageString = FileLockedToolTip;
               lockButton.tag = 103;
               [lockButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
               [lockButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
               [lockButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//               [lockButton setBackgroundColor:[UIColor yellowColor]];

               lockButton.indexPathRow = indexPath.row;
               [lockButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
               [cell addSubview:lockButton];
           }
         
       }else{
           if ([cell viewWithTag:103] != nil) {
               [[cell viewWithTag:103] removeFromSuperview];
           }
       }

        
//        TableViewButton* warningButton = [cell viewWithTag:106];
//        [warningButton addTarget:self action:@selector(warningButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        warningButton.indexPathRow = indexPath.row;
//        if ([ErrorMsg isEqualToString:@""] || ErrorMsg == nil) {
//            ErrorMsg = @"No Error";
//        }
//        warningButton.messageString = ErrorMsg;
//
        TableViewButton* moreButton = [cell viewWithTag:701];
        [moreButton addTarget:self action:@selector(addDetailsViewindexPathRow:) forControlEvents:UIControlEventTouchUpInside];
        moreButton.indexPathRow = indexPath.row;
        
//        if ([FileLockStatus intValue] == 3) {
//            [lockButton setImage:[UIImage imageNamed:@"LockBlue"] forState:UIControlStateNormal];
//        }
//        switch ([FileLockStatus intValue]) {
//            case 1:
//                [lockButton setImage:[UIImage imageNamed:@"LockGreen"] forState:UIControlStateNormal];
//                break;
//            case 2:
//                [lockButton setImage:[UIImage imageNamed:@"LockGreen"] forState:UIControlStateNormal];
//                break;
//            case 3:
//                [lockButton setImage:[UIImage imageNamed:@"LockBlue"] forState:UIControlStateNormal];
//                break;
//            default:
//                [lockButton setImage:[UIImage imageNamed:@"LockGray"] forState:UIControlStateNormal];
//                break;
//        }

        switch ([Signals intValue]) {
            case 1:
                [signalButton setImage:[UIImage imageNamed:@"CircleGreen"] forState:UIControlStateNormal];
                break;
            case 2:
                [signalButton setImage:[UIImage imageNamed:@"CircleRed"] forState:UIControlStateNormal];
                break;
            case 3:
                [signalButton setImage:[UIImage imageNamed:@"CircleOrange"] forState:UIControlStateNormal];
                break;
            default:
                [signalButton setImage:[UIImage imageNamed:@"CircleGray"] forState:UIControlStateNormal];
                break;
        }

//        if ([IsErrorMsg isEqualToString:@"true"]) {
//            [warningButton setImage:[UIImage imageNamed:@"WarningRed"] forState:UIControlStateNormal];
//        }else{
//            [warningButton setImage:[UIImage imageNamed:@"WarningGray"] forState:UIControlStateNormal];
//        }
//
        
        UILabel* fileNameLabel = [cell viewWithTag:105];
        
        fileNameLabel.text = OriginalFileName;
        
        UILabel* patientNameLabel = [cell viewWithTag:106];
        
        patientNameLabel.text = PatientName;
        
        return cell;
        
        //    if (audioDetails.downloadStatus == DOWNLOADING)
        //    {
        //        [downloadButton setTitle:@"Downloading" forState:UIControlStateNormal];
        //    }
        //    else if (audioDetails.downloadStatus == DOWNLOADED)
        //    {
        //        [downloadButton setTitle:@"View" forState:UIControlStateNormal];
        //
        //    }
        //    else if (audioDetails.downloadStatus == DOWNLOADEDANDDELETED)
        //    {
        //        [downloadButton setTitle:@"Restore" forState:UIControlStateNormal];
        //
        //    }
        //    else
        //    {
        //        [downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        //    }
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        UILabel* departmentLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, self.view.frame.size.width - 60.0f, 18)];
        
        UIButton* radioButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 18, 18)];
        
        departmentLabel.text = [departmentNamesArray objectAtIndex:indexPath.row];
        
        departmentLabel.tag=indexPath.row+200;
        
        departmentLabel.textColor = [UIColor darkTextColor];
        
        radioButton.tag=indexPath.row+100;
        
        NSString* departmentName = selectedDepartment;
        
        if ([departmentName isEqualToString:departmentLabel.text])
        {
            [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        }
        else
            [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButtonClear"] forState:UIControlStateNormal];
        
        [cell addSubview:radioButton];
        
        [cell addSubview:departmentLabel];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

        cell.backgroundColor = [UIColor whiteColor];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchController.searchBar resignFirstResponder];
}

-(void) addSubview:(CustomObjectForTableViewCell*)obj
{
    TableViewButton* lockButton = [[TableViewButton alloc] initWithFrame:CGRectMake(obj.button.frame.origin.x + obj.button.frame.size.width, obj.button.frame.origin.y, obj.button.frame.size.width, obj.button.frame.size.height)];
    [lockButton setImage:[UIImage imageNamed:@"LockBlue"] forState:UIControlStateNormal];
    lockButton.messageString = @"File Locked by other user";
    lockButton.tag = 102;
    lockButton.indexPathRow = [self.tableView indexPathForCell:obj.cell].row;
    [lockButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [obj.cell  addSubview:lockButton];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    if (tableView == self.tableView) {
        NSDictionary* docDetailsDict = [self.completedFilesResponseArray objectAtIndex:indexPath.row];
        NSString* dictationId = [docDetailsDict valueForKey:@"DictationID"];
        NSString* userId = [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID_INT];
//        NSString* filePathString = [[[[NSString stringWithFormat:@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?CallingFrm=4&sDictationID="] stringByAppendingString:dictationId] stringByAppendingString:@"&UserID="] stringByAppendingString:userId];
//        NSString* filePathString = [NSString stringWithFormat:@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?CallingFrm=4&sDictationID=%@&UserID=%@",dictationId,userId];
        
//        NSString* filePathString = [NSString stringWithFormat:@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?CallingFrm=4&sDictationID=34990&UserID=3"];
        //@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?CallingFrm=4&sDictationID=34990&UserID=3";
//    https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?sDictationID=X0yFEzKcfCBY0uAqBgw/Mg==&UserID=+YuDQhkzFywtOCgd403HVA==
        NSData* dictIdData = [[NSString stringWithFormat:@"%@",dictationId] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *dictIdEncData = [dictIdData AES256EncryptWithKey:SECRET_KEY];
        NSString* dictIdEncString = [dictIdEncData base64EncodedStringWithOptions:0];
        
        NSData* userIdData = [[NSString stringWithFormat:@"%@",userId] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *userIdEncData = [userIdData AES256EncryptWithKey:SECRET_KEY];
        NSString* userIdEncString = [userIdEncData base64EncodedStringWithOptions:0];
        
        NSString* filePathString = [NSString stringWithFormat:@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?CallingFrm=4&sDictationID=%@&UserID=%@",dictIdEncString,userIdEncString];
        
//        NSString* filePathString = [NSString stringWithFormat:@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?sDictationID=X0yFEzKcfCBY0uAqBgw/Mg==&UserID=+YuDQhkzFywtOCgd403HVA=="];
    
        
       EditDocxViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDocxViewController"];
        vc.webFilePath = filePathString;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:true completion:nil];
    }
    else{
        cell=[tableView cellForRowAtIndexPath:indexPath];
        
        UILabel* departmentNameLanel= [cell viewWithTag:indexPath.row+200];
        
        UIButton* radioButton=[cell viewWithTag:indexPath.row+100];
        
        selectedDepartment = departmentNameLanel.text;
//        [audiorecordDict setValue:departmentNameLanel.text forKey:@"Department"];
        
        [radioButton setBackgroundImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
        
        [tableView reloadData];
    }
    
}

-(void)lockButtonClicked:(TableViewButton*)sender
{
    [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:sender.messageString withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
}
-(void)signalButtonClicked:(TableViewButton*)sender
{
    [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:sender.messageString withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
}
-(void)warningButtonClicked:(TableViewButton*)sender
{
    [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Alert" withMessage:sender.messageString withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
}

-(void)approveButtonClicked:(UIButton*)sender
{
    
}
//-(void)commentButtonClicked:(TableViewButton*)sender
//{
//
//}
//-(void)detailsButtonClicked:(UIButton*)sender
//{
//
//}
-(void)downloadButtonClicked:(TableViewButton*)sender
{
    int indexPathRow = sender.indexPathRow;
    
    AudioDetails* audioDetails = [_completedFilesForTableViewArray objectAtIndex:indexPathRow];
    
    int dictationId = audioDetails.mobiledictationidval;
    
    NSString* fileName = [[Database shareddatabase] getfileNameFromDictationID:[NSString stringWithFormat:@"%d", dictationId]];
   // [[APIManager sharedManager] downloadFileUsingConnection:[NSString stringWithFormat:@"%d",dictationId]];

    if ([[sender titleForState:UIControlStateNormal]  isEqual: @"Download"] || [[sender titleForState:UIControlStateNormal]  isEqual: @"Restore"])
    {
        //[[APIManager sharedManager] downloadFileUsingConnection:@"6753263"];
        [[APIManager sharedManager] downloadFileUsingConnection:[NSString stringWithFormat:@"%d",dictationId]];

        [[Database shareddatabase] updateDownloadingStatus:DOWNLOADING dictationId:audioDetails.mobiledictationidval];
        
        audioDetails.downloadStatus = DOWNLOADING;
        
        [self.completedFilesForTableViewArray replaceObjectAtIndex:indexPathRow withObject:audioDetails];
        
        
        [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:indexPathRow inSection:0], nil]  withRowAnimation:UITableViewRowAnimationNone];
    }
    else
        if ([[sender titleForState:UIControlStateNormal]  isEqual: @"View"])

    {
//        NSString* newDestPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Clinic Letter Template"] ofType:@"doc"];
        
        NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Downloads/%@",fileName]];

        NSString* newDestPath = [destpath stringByAppendingPathExtension:@"doc"];
        
        UIDocumentInteractionController* interactionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:newDestPath]];
        
        interactionController.delegate = self;
        
        [interactionController presentPreviewAnimated:true];
    }
   
}

-(void)deleteButtonClicked:(TableViewButton*)sender
{
    self.selectedRow = sender.indexPathRow;
    
    [self deleteDocxAndUpdateStatus];
   
}

-(void)editButtonClicked:(TableViewButton*)sender
{
    self.selectedRow = sender.indexPathRow;
    
   // [self deleteDocxAndUpdateStatus];
    // present edit doc vc
   
}
-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
    
}
-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
   return self.view;
    
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    
    return self;
}


-(void)showFilterSettings:(id)sender
{
    [self addPopViewForRightBarButton:sender];
}


-(void)addPopViewForRightBarButton:(id)sender
{
//    self.selectedRow = sender.indexPathRow;
    
//    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:sender.indexPathRow inSection:0];
    
//    AudioDetails* audioDetails = [self.completedFilesForTableViewArray objectAtIndex:self.selectedRow];
    
//    UITableViewCell* tappedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
//    UIImageView* moreImageView = [tappedCell viewWithTag:702];
    //    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-175, self.view.frame.origin.y+20, 160, 126) andSubViews:subViewArray :self];
    //    UIView* pop=[[PopUpCustomView alloc]initWithFrame:CGRectMake(tappedCell.frame.size.width-175, tappedCell.frame.size.height + tappedCell.frame.origin.y+10, 160, 126) andSubViews:subViewArray :self];
    NSArray* subViewArray;
    
    double popViewHeight;
    double popViewWidth = 160;
    
   
    subViewArray=[NSArray arrayWithObjects:@"Last 5 Days",@"Last 10 Days",@"Last 15 Days",@"No Filter", nil];
        
    popViewHeight = 168; // 41 for each including top and bottom space
   
    
    double navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    double popUpViewXPosition = self.view.frame.size.width - popViewWidth;
    double popUpViewYPosition = navigationBarHeight + 20;
    
    
    
    
    
    UIView* overlayView = [[PopUpCustomView alloc]initWithFrame:CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight) andSubViews:subViewArray :self];
    
    UIView* popUpView = [overlayView viewWithTag:561];
    
//    popUpView.frame = CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight);

    popUpView.frame = CGRectMake(popUpViewXPosition+(popViewWidth/2), popUpViewYPosition, 0, 0);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:overlayView];
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{

    
        popUpView.frame = CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight);
        
    } completion:^(BOOL finished) {

    }];
    //    [tappedCell addSubview:pop];
    
}

//-(void)Last5Days
//{
//    
//    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
//    if ([popUpView isKindOfClass:[UIView class]])
//    {
//        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    }
//    
//    [self setRightBarButtonItem:@"Last 5 Days"];
//    
//    [self getCompletedFilesForDays:@"5"];
//
//}
//
//-(void)Last10Days
//{
//    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
//    if ([popUpView isKindOfClass:[UIView class]])
//    {
//        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    }
//    
//    [self setRightBarButtonItem:@"Last 10 Days"];
//
//    [self getCompletedFilesForDays:@"10"];
//}

//-(void)Last15Days
//{
//    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
//    if ([popUpView isKindOfClass:[UIView class]])
//    {
//        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    }
//
//    [self setRightBarButtonItem:@"Last 15 Days"];
//
//    [self getCompletedFilesForDays:@"15"];
//}
//
//-(void)Last30Days
//{
//    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
//    if ([popUpView isKindOfClass:[UIView class]])
//    {
//        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    }
//
//    [self setRightBarButtonItem:@"Last 30 Days"];
//
//    [self getCompletedFilesForDays:@"30"];
//}
//
//-(void)NoFilter
//{
//    UIView* popUpView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
//    if ([popUpView isKindOfClass:[UIView class]])
//    {
//        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    }
//
//    [self setRightBarButtonItem:@"No Filter"];
//
//    [self getCompletedFilesForDays:@"365"];
//
//}

-(void)addPopView:(TableViewButton*)sender
{
    self.selectedRow = sender.indexPathRow;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:sender.indexPathRow inSection:0];
    
    NSDictionary* docDetails = [self.completedFilesResponseArray objectAtIndex:self.selectedRow];
    
    UITableViewCell* tappedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView* moreImageView = [tappedCell viewWithTag:702];

    NSArray* subViewArray;

    double popViewHeight;
    double popViewWidth = 160;

//    if (audioDetails.downloadStatus == DOWNLOADED)
//    {
//        subViewArray=[NSArray arrayWithObjects:@"Info.",@"Edit Docx",@"Delete Docx", nil];
//
//        popViewHeight = 126;
//    }
//    else
//    {
        subViewArray=[NSArray arrayWithObjects:@"Info.", nil];
        
        popViewHeight = 40;
        
        popViewWidth = 120;
//    }
    
    double navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    double popUpViewXPosition = moreImageView.frame.origin.x - popViewWidth;

    double popUpViewYPosition = navigationBarHeight + tappedCell.frame.origin.y + moreImageView.frame.origin.y + 20;

    UIView* overlayView = [[PopUpCustomView alloc]initWithFrame:CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight) andSubViews:subViewArray :self];

    UIView* popUpView = [overlayView viewWithTag:561];
    
    popUpView.frame = CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight);
    
    popUpView.frame = CGRectMake(popUpViewXPosition+popViewWidth, popUpViewYPosition, 0, 0);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:overlayView];
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
    
    
            popUpView.frame = CGRectMake(popUpViewXPosition, popUpViewYPosition, popViewWidth, popViewHeight);
    
    } completion:^(BOOL finished) {
    
    }];

//    [tappedCell addSubview:pop];
    
}

-(void)dismissPopView:(id)sender
{
    
    
    UIView* overlayView= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];

    UIView* popUpView = [overlayView viewWithTag:561];

    if (popUpView.frame.size.height < 150)  // for tableview cell more popup dismiss
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedRow inSection:0];
        
        UITableViewCell* tappedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        UIImageView* moreImageView = [tappedCell viewWithTag:702];
        
        double navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
        
        double popUpViewYPosition = navigationBarHeight + tappedCell.frame.origin.y + moreImageView.frame.origin.y + 20;
        
        double popUpViewXPosition = moreImageView.frame.origin.x;
        
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            
            NSArray* subViews = [popUpView subviews];
            
            for (UIView* view in subViews)
            {
                view.frame = CGRectMake(popUpViewXPosition, popUpViewYPosition, 0, 0);
            }
            
            popUpView.frame = CGRectMake(popUpViewXPosition, popUpViewYPosition, 0, 0);
            
            
            
        } completion:^(BOOL finished) {
            
            if ([popUpView isKindOfClass:[UIView class]])
            {
                [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
            }
            
        }];
        
    }
    else // for navigation bar more popup dismiss
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];

    }
   
    
}
-(void)Info
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
//    [self addDetailsViewindexPathRow:self.selectedRow];
//    [self.navigationController presentViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"] animated:YES completion:nil];
}

-(void)EditDocx
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
     UIViewController* vc= [self.storyboard  instantiateViewControllerWithIdentifier:@"EditDocxViewController"];
       
       vc.modalPresentationStyle = UIModalPresentationFullScreen;
       
       [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(void)DeleteDocx
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    
    [self deleteDocxAndUpdateStatus];
//    [self.navigationController presentViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"UserSettingsViewController"] animated:YES completion:nil];
}

-(void)deleteDocxAndUpdateStatus
{
    alertController = [UIAlertController alertControllerWithTitle:@"Delete"
                                                          message:DELETE_MESSAGE_DOCX
                                                   preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Delete"
                                            style:UIAlertActionStyleDestructive
                                          handler:^(UIAlertAction * action)
                    {
                        

                       AudioDetails* audioDetails = [self.completedFilesForTableViewArray objectAtIndex:self.selectedRow];
                            
                       audioDetails.downloadStatus = DOWNLOADEDANDDELETED;
                                
                       [self.completedFilesForTableViewArray replaceObjectAtIndex:self.selectedRow withObject:audioDetails];
                                
                       [self.tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:self.selectedRow inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];

                        
                        [self updateDocxFileDeleteStatus:audioDetails.mobiledictationidval status:DOWNLOADEDANDDELETED];
                        
                        [self deleteDocxFromStorage:audioDetails.fileName];

                        [alertController dismissViewControllerAnimated:YES completion:nil];

                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]; //You can use a block here to handle a press on this button
    
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

-(void)updateDocxFileDeleteStatus:(long)mobiledictationidval status:(int)deleteStatus
{
    [[Database shareddatabase] updateDownloadingStatus:DOWNLOADEDANDDELETED dictationId:mobiledictationidval];

}

-(void)deleteDocxFromStorage:(NSString*)fileName
{
    [[APIManager sharedManager] deleteDocxFile:[NSString stringWithFormat:@"%@",fileName]];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//-(void)addDetailsViewindexPathRow:(long)indexPathRow
//{
//    overLayView = [[UIView alloc] initWithFrame:self.view.frame];
//
//    overLayView.tag = 222;
//
//    overLayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//
//    UITapGestureRecognizer* tapToDismissNotif = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crossButtonTapped:)];
//
//    [overLayView addGestureRecognizer:tapToDismissNotif];
//
//    tapToDismissNotif.delegate = self;
//
//    AudioDetails* audioDetails = [self.completedFilesForTableViewArray objectAtIndex:indexPathRow];
//
//    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
//
//     self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.05, -self.view.frame.size.height, self.view.frame.size.width*0.9, self.view.frame.size.height*0.73);
//
//    scrollView.delegate = self;
//
//    self.automaticallyAdjustsScrollViewInsets = false;
//
//
//    scrollView.backgroundColor = [UIColor whiteColor];
//
//    UIView* insideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, 500)];
//
//    insideView.backgroundColor = [UIColor whiteColor];
//
//    scrollView.layer.cornerRadius = 4.0;
//
//    insideView.layer.cornerRadius = 4.0;
//
//    UILabel* referenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(insideView.frame.size.width/2 - 60, 12, 120, 40)];
//
//    referenceLabel.textAlignment = NSTextAlignmentCenter;
//
//    referenceLabel.text = @"Details";
//
//    referenceLabel.font = [UIFont systemFontOfSize:18];
//
//    referenceLabel.textColor = [UIColor appOrangeColor];
//
//    UIImageView* crossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(insideView.frame.size.width - 40, 20, 20, 20)];
//
//    crossImageView.image = [UIImage imageNamed:@"Cross"];
//
//    UIButton* crossButton = [[UIButton alloc] initWithFrame:CGRectMake(insideView.frame.size.width - 60, 0, 60, 60)];
//
//    [crossButton setBackgroundColor:[UIColor clearColor]];
//
//    [crossButton addTarget:self action:@selector(crossButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//
//    float titleLabelXPosition = insideView.frame.size.width*0.05;
//    float titleValueLabelXPosition = insideView.frame.size.width*0.49;
//
//    UILabel* dictationIdTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, referenceLabel.frame.origin.y + referenceLabel.frame.size.height+7 , insideView.frame.size.width*0.4, 30)];
//
//    dictationIdTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
//
//    dictationIdTitleLabel.font = [UIFont systemFontOfSize:14];
//
//    dictationIdTitleLabel.text = @"Audio ID";
//
//    UILabel* dictationIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, referenceLabel.frame.origin.y + referenceLabel.frame.size.height+7, insideView.frame.size.width*0.5, 30)];
//
//    dictationIdLabel.font = [UIFont systemFontOfSize:14];
//
//    dictationIdLabel.text = audioDetails.fileName;
//
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, dictationIdTitleLabel.frame.origin.y + dictationIdTitleLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
//    separatorLineView.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
//
//
//    UILabel* originalFileNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, separatorLineView.frame.origin.y + 10 , insideView.frame.size.width*0.5, 30)];
//
//    originalFileNameTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
//
//    originalFileNameTitleLabel.font = [UIFont systemFontOfSize:14];
//
//    originalFileNameTitleLabel.text = @"Dictated By";
//
//    UILabel* originalFileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, separatorLineView.frame.origin.y + 10, insideView.frame.size.width*0.4, 30)];
//
//    originalFileNameLabel.font = [UIFont systemFontOfSize:14];
//
//    originalFileNameLabel.text = @"Test Consultant 1";
//
//    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, originalFileNameLabel.frame.origin.y + originalFileNameLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
//    separatorLineView1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
//
//
//    UILabel* dictatedOnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, separatorLineView1.frame.origin.y + 10 , insideView.frame.size.width*0.4, 30)];
//
//    dictatedOnTitleLabel.textColor= [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
//
//    dictatedOnTitleLabel.font = [UIFont systemFontOfSize:14];
//
//    dictatedOnTitleLabel.text = @"Dictated On";
//
//    UILabel* dictatedOnLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, separatorLineView1.frame.origin.y + 10, insideView.frame.size.width*0.5, 30)];
//
//    dictatedOnLabel.font = [UIFont systemFontOfSize:14];
//
//    dictatedOnLabel.text = [NSString stringWithFormat:@"%@",audioDetails.recordingDate];
//
//    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, dictatedOnLabel.frame.origin.y + dictatedOnLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
//    separatorLineView2.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
//
//    UILabel* uploadedDateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXPosition, separatorLineView2.frame.origin.y + 10 , insideView.frame.size.width*0.4, 30)];
//
//    uploadedDateTitleLabel.textColor = [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:1.0];
//
//    uploadedDateTitleLabel.font = [UIFont systemFontOfSize:14];
//
//    uploadedDateTitleLabel.text = @"Transfer Date";
//
//    UILabel* uploadedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleValueLabelXPosition, separatorLineView2.frame.origin.y + 10, insideView.frame.size.width*0.5, 30)];
//
//    uploadedDateLabel.font = [UIFont systemFontOfSize:14];
//
//    uploadedDateLabel.text = audioDetails.transferDate;
//
//    UIView* separatorLineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, uploadedDateLabel.frame.origin.y + uploadedDateLabel.frame.size.height + 5, insideView.frame.size.width-20, 1)];
//    separatorLineView3.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
//
//    commentTextView.font = [UIFont systemFontOfSize:14.0];
//
//    commentTextView.delegate = self;
//
//    [insideView addSubview:referenceLabel];
//    [insideView addSubview:crossButton];
//    [insideView addSubview:crossImageView];
//
//    [insideView addSubview:dictationIdTitleLabel];
//    [insideView addSubview:dictationIdLabel];
//    [insideView addSubview:separatorLineView];
//
//    [insideView addSubview:originalFileNameTitleLabel];
//    [insideView addSubview:originalFileNameLabel];
//    [insideView addSubview:separatorLineView1];
//
//    [insideView addSubview:dictatedOnTitleLabel];
//    [insideView addSubview:dictatedOnLabel];
//    [insideView addSubview:separatorLineView2];
//
//    [insideView addSubview:uploadedDateTitleLabel];
//    [insideView addSubview:uploadedDateLabel];
//    [insideView addSubview:separatorLineView3];
//
//    [scrollView addSubview:insideView];
//
//    [overLayView addSubview:scrollView];
//
//    [[UIApplication sharedApplication].keyWindow addSubview:overLayView];
//
//    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.1 options:UIViewAnimationOptionTransitionCurlDown animations:^{
//
//    self.scrollView.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.09, self.view.frame.size.width*0.9, self.view.frame.size.height*0.73);
//
//    } completion:^(BOOL finished) {
//
//    }];
//
//    //    overLayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    //    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//    //        overLayView.transform = CGAffineTransformIdentity;
//    //    } completion:^(BOOL finished){
//    //        // do something once the animation finishes, put it here
//    //    }];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
