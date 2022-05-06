//
//  DocFilesViewController.h
//  Ace
//
//  Created by mac on 20/11/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewButton.h"
#import "UIColor+ApplicationColors.h"
#import "PopUpCustomView.h"

@interface DocFilesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UIDocumentInteractionControllerDelegate, UIGestureRecognizerDelegate,UITextViewDelegate, UISplitViewControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating>
{
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;
    UIView* popupView;
    PopUpCustomView* forTableViewObj;
    NSArray* departmentNamesArray;
    UITableViewCell *cell;
    NSString* selectedDepartment;
    bool changeDeptCalled;
    BOOL searchBecomeResponsderFromUploadAlert;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *completedFilesResponseArray;
@property (strong, nonatomic) NSMutableArray *completedFilesResponsePredicateArray;
@property (strong, nonatomic) NSMutableArray *completedFilesForTableViewArray;
@property (strong, nonatomic) NSMutableArray *downloadingFilesDictationIdsArray;
@property (strong, nonatomic) UIView* overLayView;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) NSArray *uploadedFilesArray;
@property (strong, nonatomic) UITextView* commentTextView;
@property (nonatomic) long selectedRow;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIView *searchBarBGView;

@end
