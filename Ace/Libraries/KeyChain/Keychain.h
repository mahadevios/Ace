//
//  Keychain.h
//  Ace
//
//  Created by Santosh Bayas on 9/1/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

// This wrapper helps us deal with Keychain-related things
// such as storing API keys and passwords

@interface Keychain : NSObject
{
    
}

+ (BOOL)setString:(NSString *)string forKey:(NSString *)key;
+ (NSString *)getStringForKey:(NSString *)key;

@end
