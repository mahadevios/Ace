//
//  Database.h
//  DbExample
//
//  Created by mac on 08/02/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DepartMent.h"
#import "AudioDetails.h"
#import "DocFileDetails.h"
#import "AppPreferences.h"

@interface Database : NSObject

+(Database *)shareddatabase;


@property(nonatomic, strong) NSString* isVRSTableAltered;

-(NSString *)getDatabasePath;


//-(NSMutableArray *)getFeedbackAndQueryMessages;

-(void)insertDepartMentData:(NSArray*)deptArray;

-(NSMutableArray*)getDepartMentNames;

-(DepartMent*)getDepartMentFromDepartmentName:(NSString*)name;

-(NSString*)getDepartMentIdFromDepartmentName:(NSString*)departmentName;

-(NSMutableArray*)getListOfFileTransfersOfStatus:(NSString*)status;

-(int)getDepartMentIdForFileName:(NSString*)fileName;


///--------for home view counts-------------//

-(int)getCountOfTodaysTransfer:(NSString*)date;

-(int)getCountOfTransferFailed;

-(int)getCountOfTransfersOfDicatationStatus:(NSString*)status;//get count of incomplete(paused,for alert tag) or complete(stoped,for awaiting count)

//---------------*****---------------------//

-(void)insertRecordingData:(NSDictionary*)dict;

-(void)updateAudioFileName:(NSString*)existingAudioFileName dictationStatus:(NSString*)status;//to update incomplete,awaiting status

-(void)updateAudioFileName:(NSString*)existingAudioFileName duration:(float)duration;//to update duration


//---------------for list view(transferred or deleted list)----------------//

-(NSMutableArray*)getListOfTransferredOrDeletedFiles:(NSString*)listName;

//---------------*****-----------------------------------------------------//

-(void)updateAudioFileStatus:(NSString*)status fileName:(NSString*)fileName dateAndTime:(NSString*)dateAndTimeString;

-(void)updateAudioFileUploadedStatus:(NSString*)status fileName:(NSString*)fileName dateAndTime:(NSString*)dateAndTimeString mobiledictationidval:(long) idval;//for transferred status update transferred or failed

-(void)updateAudioFileStatus:(NSString*)status fileName:(NSString*)fileName;//for sdictationstatus=fileupload,called when when user confirm to file transfer

-(void)updateDownloadingStatus:(int)downloadStatus dictationId:(int)dictationId;

-(int)getMobileDictationIdFromFileName:(NSString*)fileName;


-(void)updateUploadingFileDictationStatus;

-(void)updateUploadingStuckedStatus;

-(int)getTransferStatus:(NSString*)filename;

-(NSString*)getDefaultDepartMentId;

-(void)updateDepartment:(long)deptId fileName:(NSString*)fileName;

-(int)getImportedFileCount;

-(void)getlistOfimportedFilesAudioDetailsArray:(int) newDataUpdate;

-(void)updateAudioFileDeleteStatus:(NSString*)status fileName:(NSString*)fileName updatedDated:(NSString*)updatedDated currentDuration:(NSString*)currentDuration fileSize:(NSString*) fileSize;

-(void)setDepartment;

-(void)addDictationStatus:(NSString*)dictationStatus;

-(NSArray*) getFilesToBePurged;

//-(void)updateAudioFileName;// delete this later

-(void)deleteFileRecordFromDatabase:(NSString*)fileName;

-(void) createFileNameidentifierRelationshipTable;

-(void)insertTaskIdentifier:(NSString*)taskIdentifier fileName:(NSString*)fileName;

-(NSString*)getfileNameFromTaskIdentifier:(NSString*)taskIdentifier;

-(void)deleteIdentifierFromDatabase:(NSString*)identifier;

-(NSArray*) getUploadedFileList;

-(NSArray*) getUploadedFilesDictationIdList:(BOOL)filter filterDate:(NSString*)filterDate;

-(NSString*)getfileNameFromDictationID:(NSString*)mobileDictationIdVal;

-(void)addDocFileInDB:(DocFileDetails*)docFileDetails;

-(void)createDocFileAndDownloadedDocxFileTable;

-(NSMutableArray*)getVRSDocFiles;

-(void)deleteDocFileRecordFromDatabase:(NSString*)docFileName;

-(void)updateDeleteStatusOfDocx:(int)deleteStatus dictationId:(NSString*)fileName;

-(void)updateDateFormat;

-(void)AlterVRSTextFilesTableForDepartmentName;


-(NSMutableArray*)getDepartMentObjList;

-(void)truncateTable_TableName:(NSString*)tableName;

@end
