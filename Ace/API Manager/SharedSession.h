//
//  SharedSession.h
//  Ace
//
//  Created by mac on 14/03/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSession : NSURLSession

{
 //void (^_completionHandler)(UIBackgroundFetchResult);
    //NSString* completionHandler;
}
+(SharedSession*) getSharedSession:(id)sender;

//@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)(void);

@end
