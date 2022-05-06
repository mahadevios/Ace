//
//  CustomObjectForTableViewCell.h
//  Ace
//
//  Created by mac on 27/03/21.
//  Copyright © 2021 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomObjectForTableViewCell : NSObject

@property(nonatomic, strong)UITableViewCell* cell;
@property(nonatomic, strong)TableViewButton* button;

@end

NS_ASSUME_NONNULL_END
