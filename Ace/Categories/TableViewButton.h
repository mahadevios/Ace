//
//  TableViewButton.h
//  Ace
//
//  Created by mac on 23/11/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewButton : UIButton

@property(nonatomic) long indexPathRow;
@property(nonatomic,strong) NSString* messageString;

@end
