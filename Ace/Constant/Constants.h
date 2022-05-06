//
//  Header.h
//  Ace
//
//  Created by mac on 13/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#ifndef Header_h
#define Header_h

//#define  BASE_URL_PATH                        @"http://www.xanadutec.net/cubeagent_webapi/api"
//
//#define  BASE_URL_PATH                        @"http://192.168.3.150:8081/CubeAPI/api"
//#define  CHECK_DEVICE_REGISTRATION            @"MobileCheckDeviceRegistration"
//#define  AUTHENTICATE_API                     @"MobileAuthenticate"
//#define  ACCEPT_PIN_API                       @"MobileAcceptPIN"
//#define  VALIDATE_PIN_API                     @"MobileValidatePIN"
//#define  DICTATIONS_INSERT_API                @"MobileDictationsInsert"
//#define  DATA_SYNCHRONISATION_API             @"MobileDataSynchronisation"
//#define  FILE_UPLOAD_API                      @"MobileFileUpload"
//#define  PIN_CANGE_API                        @"MobilePINChange"

//#define  BASE_URL_PATH                        @"http://www.xanadutec.net/cubeagent_webapi/api"
//appointment live on 1. "https://www.cubescribe.com/cubeagent_webapi/api" and 2. "https://www.cubescribeonline.com/CubeApi4Intranet/api" currently for test(since we've added completed doc apis in 2 only)


//#define  BASE_URL_PATH                          @"https://www.cubescribeonline.com/CubeApi4Intranet/api"//test db
//#define  BASE_URL_PATH_1                        @"https://www.cubescribe.com/cubeagent_webapi/api"//live

#define  BASE_URL_PATH                        @"http://139.99.188.235:81/CubeApi4Intranet/api"
#define  BASE_URL_PATH_1                        @"http://139.99.188.235:81/CubeApi4Intranet/api"

//#define  BASE_URL_PATH                        @"http://192.168.3.156:8081/CubeAPI/api"
#define  CHECK_DEVICE_REGISTRATION            @"encrdecr_MobileCheckDeviceRegistration"
#define  AUTHENTICATE_API                     @"encrdecr_MobileAuthenticate"
#define  ACCEPT_PIN_API                       @"encrdecr_MobileAcceptPIN"
#define  VALIDATE_PIN_API                     @"encrdecr_MobileValidatePIN"
#define  DICTATIONS_INSERT_API                @"encrdecr_MobileDictationsInsert"
#define  DATA_SYNCHRONISATION_API             @"encrdecr_MobileDataSynchronisation"
//#define  FILE_UPLOAD_API                      @"encrdecr_MobileFileUpload"
#define  FILE_UPLOAD_API                      @"encrdecr_MobileFileUpload"

#define  PIN_CANGE_API                        @"encrdecr_MobilePINChange"
#define  FILE_DOWNLOAD_API                    @"encedecr_MobileDownloadDocFile"
#define  SEND_DICTATION_IDS_API               @"encrdecr_MobileRequestForCompleteFiles"
#define  SEND_COMMENT_API                     @"encdecr_MobileDocFileComment"
#define  DOCX_FILE_UPLOAD_API                 @"encedecr_MobileUploadDocFile"
#define  ACCEPY_TandC_API                     @"encedecr_MobileTermsAndConditions"
#define  GET_APNTMNT_LIST_API                 @"encrdecr_MobileClinicList"
#define  UPDATE_APNTMNT_STATUS_API            @"encrdecr_MobileAppointmentStatus"
#define  GET_COMPLETED_DOC_LIST_API           @"encrdecr_MobileApproval"


#define  MEETING_USER_ENDPOINT_API            @"http://liveklasserp.testbot.xyz/Sessions/join?m=91&p=532714&u="
#define  MEETING_MENTOR_ENDPOINT              @"http://liveklasserp.testbot.xyz/Sessions/join?m=91&p=861720&u=";


#define  SECRET_KEY                           @"cubemob"
#define  POST                           @"POST"
#define  GET                            @"GET"
#define  PUT                            @"PUT"
#define  REQUEST_PARAMETER              @"requestParameter"
#define  SUCCESS                        @"1000"
#define  FAILURE                        @"1001"
#define  VRS_LOCALE                     @"vrsLocale"
#define  DICTATOR_NAME                  @"dictatorName"


//NSNOTIFICATION

#define NOTIFICATION_CHECK_DEVICE_REGISTRATION      @"notificationForMobileCheckDeviceRegistration"
#define NOTIFICATION_AUTHENTICATE_API               @"notificationForMobileAuthenticate"
#define NOTIFICATION_ACCEPT_PIN_API                 @"notificationForMobileAcceptPIN"
#define NOTIFICATION_VALIDATE_PIN_API               @"notificationForMobileValidatePIN"
#define NOTIFICATION_DICTATIONS_INSERT_API          @"notificationForMobileDictationsInsert"
#define NOTIFICATION_DATA_SYNCHRONISATION_API       @"notificationForMobileDataSynchronisation"
#define NOTIFICATION_FILE_UPLOAD_API                @"notificationForMobileFileUpload"
#define NOTIFICATION_FILE_DOWNLOAD_API              @"notificationForMobileFileDownload"
#define NOTIFICATION_SEND_DICTATION_IDS_API         @"notificationSendDictationIds"
#define NOTIFICATION_ACCEPT_TANDC_API               @"notificationAcceptTandC"

#define NOTIFICATION_PIN_CANGE_API                  @"notificationForMobilePINChange"
#define NOTIFICATION_PAUSE_RECORDING                @"pauseRecording"
#define NOTIFICATION_INTERNET_MESSAGE               @"internetMessage"
#define NOTIFICATION_PAUSE_AUDIO_PALYER             @"pausePlayer"
#define NOTIFICATION_DELETE_RECORDING               @"deleteRecording"
#define NOTIFICATION_SAVE_RECORDING                 @"saveRecording"
#define NOTIFICATION_FILE_IMPORTED                  @"fileImportingCompleted"
#define NOTIFICATION_UPLOAD_NEXT_FILE               @"uploadNextFile"
#define NOTIFICATION_SEND_COMMENT_API               @"commentNotification"
#define NOTIFICATION_FILE_UPLOAD_CLICKED            @"fileUploadClicked"
#define NOTIFICATION_STOP_VRS                       @"stopVRS"
#define NOTIFICATION_GET_APNTMNT_LIST               @"notiGetApntmntList"
#define NOTIFICATION_UPDATE_APNTMNT_STATUS          @"notiUpdateApntStatus"
#define NOTIFICATION_COMPLETED_DOC_LIST             @"notiCompletedDocList"

//Settimg Constants
//
#define SAVE_DICTATION_WAITING_SETTING         @"Save dictation waiting by"
#define CONFIRM_BEFORE_SAVING_SETTING          @"Confirm before saving"
#define CONFIRM_BEFORE_SAVING_SETTING_ALTERED  @"Confirm before saving alter"
#define ALERT_BEFORE_RECORDING                 @"Alert before recording"
#define BACK_TO_HOME_AFTER_DICTATION           @"Back to home after dictation"
#define LOGIN_USING_FACE_TOUCH_ID              @"Login using face or touch id"
#define RECORD_ABBREVIATION                    @"Record abbreviation"
#define LOW_STORAGE_THRESHOLD                  @"Low storage threshold"
#define PURGE_DELETED_DATA                     @"Purge data by"
#define CHANGE_YOUR_PASSWORD                   @"Change your pin"
#define DELETE_MESSAGE_DOCX                    @"Do you want to delete this file?"
#define DELETE_MESSAGE                         @"Do you want to delete this recording?"
#define DELETE_MESSAGE_MULTIPLES               @"Do you want to delete these recordings?"
#define TRANSFER_MESSAGE                       @"Are you sure you want to transfer this recording?"
#define TRANSFER_MESSAGE_MULTIPLES             @"Are you sure you want to transfer these recordings?"
#define RESEND_MESSAGE                         @"Are you sure you want to resend this recording?"
#define PAUSE_STOP_MESSAGE                     @"Recording is on.Please pause/stop the recording"
#define MAXIMUM_RECORDING_LIMIT_MESSAGE        @"Recording duration length exceeded,please start new recording for further dictation"
#define RECORDING_SAVED_MESSAGE                @"Recording duration length exceeded,your recording has been saved in awaiting transfer,please start new recording for further dictation"

#define NO_INTERNET_TITLE_MESSAGE               @"No internet connection!"
#define NO_INTERNET_DETAIL_MESSAGE              @"Please check your internet connection and try again."
#define CURRENT_VESRION                        @"currentVersion"
#define IS_DATE_FORMAT_UPDATED                 @"dateFormatUpdated"

#define RECORDING_LIMIT                        3600
#define ALERT_TAB_LOCATION                     3
#define PURGE_DATA_DATE                        @"purgeDataDate"
//#define APPLICATION_TERMINATE_CALLED           @"applicationTerminate"


#define INCOMPLETE_TRANSFER_COUNT_BADGE        @"Incomplete Count"
#define SELECTED_DEPARTMENT_NAME               @"Selected Department"
#define SELECTED_DEPARTMENT_NAME_COPY          @"Selected Department Copy"
#define AUDIO_FILES_FOLDER_NAME                @"Audio files"
#define DOCX_FILES_FOLDER_NAME                 @"Downloads"
#define DOC_VRS_FILES_FOLDER_NAME              @"VRSDOC files"
#define DOC_VRS_TEXT_FILES_FOLDER_NAME         @"VRSAudio files"
#define IS_VRS_ENABLE                          @"isVrsEnable"

#define USER_PIN         @"userPIN"
#define USER_ID         @"userId" //Username
#define USER_PASS         @"userPassword"
#define USER_LOGIN_CODE         @"userLoginCode"
#define USER_ID_INT         @"userIdInt" //unique db userId generated by server
//#define DATE_TIME_FORMAT                       @"MM-dd-yyyy HH:mm:ss"
#define DATE_TIME_FORMAT                       @"yyyy-MM-dd HH:mm:ss"

#define RESPONSE_CODE                          @"code"
#define RESPONSE_PIN_VERIFY                    @"pinverify"
#define RESPONSE_TC_FLAG                    @"AcceptTermFlag"
#define RESPONSE_MESSAGE                          @"responseMessage"



#define SHARED_GROUP_IDENTIFIER                @"group.com.xanadutec.ace"
//#define MAC_ID                                 @"e0:2c:b2:eb:5a:8e"
//#define MAC_ID                                 @"e0:2c:b2:ec:5a:8e"

//#define MAC_ID                                 @"e0:2c:b2:ec:5a:8f"

typedef enum
{
    NODOWNLOAD,
    DOWNLOADING,
    DOWNLOADED,
    DOWNLOADEDANDDELETED
}DownloadingStatus;

typedef enum
{
    NODELETE,
    DELETED
}DeleteStatus;

typedef enum
{
    NOUPLOAD,
    UPLOADED
}UploadStatus;
#endif /* Header_h */
