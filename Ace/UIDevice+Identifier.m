//
//  UIDevice+Identifier.m
//  Ace
//
//  Created by mac on 31/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "UIDevice+Identifier.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIDevice (Identifier)
- (NSString *) identifierForVendor1
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    else
    return @"";
}
@end

