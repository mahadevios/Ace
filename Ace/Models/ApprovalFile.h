//
//  ApprovalFile.h
//  Ace
//
//  Created by mac on 08/04/21.
//  Copyright © 2021 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApprovalFile : NSObject

@property(nonatomic, strong) NSString* DictationID;
@property(nonatomic, strong) NSString* DictationUploadDate;
@property(nonatomic, strong) NSString* ErrorMsg;
@property(nonatomic, strong) NSString* FileLockStatus;
@property(nonatomic, strong) NSString* FileLockedToolTip;
@property(nonatomic, strong) NSString* IsErrorMsg;
@property(nonatomic, strong) NSString* OriginalFileName;
@property(nonatomic, strong) NSString* PatientName;
@property(nonatomic, strong) NSString* Signals;
@property(nonatomic, strong) NSString* SignalsToolTip;
@property(nonatomic, strong) NSString* PatientDateofBirth;

@end

NS_ASSUME_NONNULL_END
