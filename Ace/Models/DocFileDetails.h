//
//  DocFileDetails.h
//  Ace
//
//  Created by mac on 19/12/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocFileDetails : NSObject

@property(nonatomic, strong) NSString* docFileName;
@property(nonatomic, strong) NSString* audioFileName;

@property(nonatomic) int uploadStatus;
@property(nonatomic) int dictationId;

@property(nonatomic, strong) NSString* uploadDate;
@property(nonatomic, strong) NSString* createdDate;
@property(nonatomic, strong) NSString* departmentName;

@property(nonatomic) int deleteStatus;

@end
