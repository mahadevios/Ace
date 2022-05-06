//
//  AlertViewController.h
//  Ace
//
//  Created by mac on 27/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Database.h"
#import "APIManager.h"

@interface AlertViewController : UIViewController<UISplitViewControllerDelegate>
{
    Database* db;
    APIManager* app;
    int badgeCount;
    MBProgressHUD* hud;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray* VRSDocFilesArray;

@end
