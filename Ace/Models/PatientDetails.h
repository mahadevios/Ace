//
//  PatientDetails.h
//  Ace
//
//  Created by mac on 22/03/20.
//  Copyright © 2020 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientDetails : NSObject

@property(nonatomic) long AppointementID;
@property(nonatomic, strong) NSString* PatTitle;
@property(nonatomic, strong) NSString* PatFirstname;
@property(nonatomic, strong) NSString* PatLastname;
@property(nonatomic, strong) NSString* MRN;
@property(nonatomic, strong) NSString* NHSNumber;
@property(nonatomic, strong) NSString* DOB;
@property(nonatomic, strong) NSString* PatientContactNumber;
@property(nonatomic, strong) NSString* CountryCode;
@property(nonatomic, strong) NSString* SkypeCode;
@property(nonatomic, strong) NSString* AppointmentDate;
@property(nonatomic, strong) NSString* AppointmentTime;
@property(nonatomic, strong) NSString* AppointmentStatus;
@property(nonatomic, strong) NSString* DepartmentID;
@property(nonatomic, strong) NSString* DoctorUrl;
@property(nonatomic, strong) NSString* PatUrl;
@property(nonatomic, strong) NSString* PatientInWaitingRoom;
//    "AppointementID": 1,
//    "PatTitle": "Mr.",
//    "PatFirstname": "Amol",
//    "PatLastname": "Thorat",
//    "MRN": "123456789",
//    "NHSNumber": "11111111",
//    "DOB": "11-12-1980",
//    "PatientContactNumber": "1234567890",
//    "PatientContactNumber2": "2234567894",
//    "AppointmentDate": "22-03-2020",
//    "AppointmentTime": "10:00:00 AM",
//    "AppointmentStatus": "1",
//    "DepartmentID": "407"
@end

NS_ASSUME_NONNULL_END
