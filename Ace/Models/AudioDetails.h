//
//  AudioDetails.h
//  Ace
//
//  Created by mac on 28/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioDetails : NSObject

@property(nonatomic, strong) NSString* fileName;
@property(nonatomic, strong) NSString* uploadStatus;
@property(nonatomic, strong) NSString* dictationStatus;
@property(nonatomic) int downloadStatus;
@property(nonatomic, strong) NSString* transferDate;
@property(nonatomic, strong) NSString* department;
@property(nonatomic) int mobiledictationidval;
@property(nonatomic, strong) NSString* currentDuration;
@property(nonatomic, strong) NSString* recordingDate;
@property(nonatomic, strong) NSString* fileSize;

@end
