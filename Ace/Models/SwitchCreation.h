//
//  SwitchCreation.h
//  Ace
//
//  Created by mac on 29/07/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SwitchCreation : NSObject

@property(nonatomic,strong)UITableViewCell* cell;
@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)UILabel* label;
@property(nonatomic,strong)UISwitch* flipSwitch;
@property(nonatomic) int tag;
@end
