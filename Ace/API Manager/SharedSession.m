//
//  SharedSession.m
//  Ace
//
//  Created by mac on 14/03/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import "SharedSession.h"



@implementation SharedSession

static NSURLSession * sharedSession =nil;

+(NSURLSession*) getSharedSession:(id)sender
{
    if (sharedSession== nil)
    {
       
        sharedSession = [[SharedSession alloc] init];
        
        NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"Xanadutec"];

        backgroundConfig.timeoutIntervalForResource = 30*60;// time wait for upload
        
//        backgroundConfig.sessionSendsLaunchEvents = false;
        
        sharedSession = [NSURLSession sessionWithConfiguration:backgroundConfig delegate:sender delegateQueue:[NSOperationQueue mainQueue]];
        
        return sharedSession;
    }
    else
    {
        return  sharedSession;
    }
    
//    static NSURLSession *session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"Xanadutec"];
//        
//        session = [NSURLSession sessionWithConfiguration:backgroundConfig delegate:sender delegateQueue:nil];
//    });
//    return session;

}



@end
