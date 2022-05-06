//
//  InCompleteDictationViewController.h
//  Ace
//
//  Created by mac on 04/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "APIManager.h"
#import "AppPreferences.h"
#import "Constants.h"

@interface InCompleteDictationViewController : UIViewController
{
    APIManager* app;
    Database* db;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
