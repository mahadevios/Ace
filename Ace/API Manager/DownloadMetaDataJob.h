//
//  DownloadMetaDataJob.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//
/*================================================================================================================================================*/

#import <Foundation/Foundation.h>
#import "SBJson4.h"
#import "objc/runtime.h"
#import "SharedSession.h"
@protocol DownloadMetaDataJobDelegate;

@interface DownloadMetaDataJob : NSObject
{
    NSString        *downLoadEntityJobName;
    NSString        *downLoadResourcePath;
    NSString        *httpMethod;
    NSString        *downloadMethodType;

    NSMutableData   *responseData;
    
    NSDictionary      *requestParameter;
    NSArray           *headerParameter;

    float				bytesReceived;
	long long			expectedBytes;
    float               percentComplete;
    float               progress;
    
    id<DownloadMetaDataJobDelegate> downLoadJobDelegate;
    
    NSDate          *startDate;
    
    int             statusCode;
    
    NSDictionary* result;

}

/*================================================================================================================================================*/

@property (nonatomic,strong)  NSString              *downLoadEntityJobName;
@property (nonatomic,strong)  NSString              *downLoadResourcePath;
@property (nonatomic,strong)  NSString              *downloadMethodType;

@property (nonatomic,strong)  NSDictionary          *requestParameter;
@property (nonatomic,strong)  NSMutableArray          *dataArray;

@property (nonatomic,strong)  NSString              *httpMethod;
@property (nonatomic,strong)  id<DownloadMetaDataJobDelegate> downLoadJobDelegate;

@property (nonatomic,strong)  NSTimer               *addTrintsAfterSomeTimeTimer;

@property (nonatomic,assign)  int                   currentSaveTrintIndex;
@property (nonatomic,assign)  NSNumber              *isNewMatchFound;
@property(nonatomic,strong)NSURLSession* session;

-(id) initWithdownLoadEntityJobName:(NSString *) jobName withRequestParameter:(id) localRequestParameter withResourcePath:(NSString *) resourcePath withHttpMethd:(NSString *) httpMethodParameter downloadMethodType:(NSString*)downloadMethodType;

-(void)downloadFileUsingNSURLSession:(NSString*)str;

-(void)uploadDocxFileAfterGettingdatabaseValues:(NSString*)fileName;

-(void) startMetaDataDownLoad;


@end

/*================================================================================================================================================*/

@protocol DownloadMetaDataJobDelegate

- (void) messageSentResponseDidReceived:(NSDictionary *) responseDic;

@end

/*================================================================================================================================================*/
