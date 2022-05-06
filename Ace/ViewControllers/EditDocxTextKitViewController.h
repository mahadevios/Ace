//
//  EditDocxTextKitViewController.h
//  Ace
//
//  Created by mac on 03/12/20.
//  Copyright © 2020 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDXML.h"
#import "AppPreferences.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditDocxTextKitViewController : UIViewController<UITextViewDelegate>
{
    NSXMLParser * parser;
    NSString* parsedString;
    NSAttributedString* textViewAttributedString;
}
@property (weak, nonatomic) IBOutlet UITextView *referenceTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insideViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insideViewHeightConstraint;
@property(nonatomic,strong) NSLayoutConstraint* height;
@property(nonatomic) int textViewCount;

@property(nonatomic) BOOL textAdded;
@property(nonatomic) BOOL elementChanged;
@property(nonatomic,strong) NSMutableArray* modifiedTextViewTagsArray;
@property(nonatomic,strong) NSMutableDictionary* XPathForTextViewDict;
@property(nonatomic,strong) NSMutableDictionary* elementIndexDict;
@property(nonatomic,strong) NSMutableDictionary* textViewContentHeightDict;
@property(nonatomic,strong) NSMutableDictionary* locAndLenOfRunEleUsingTxVwTagDic;

@property(nonatomic,strong) NSString* bundleFileName;
@property(nonatomic,strong) NSString* unzipFolderName;
@property(nonatomic,strong) NSString* zipDocxFileName;

@property(nonatomic,strong) DDXMLDocument *theDocument;
@property(nonatomic,strong) DDXMLDocument *relsDocument;

//- (IBAction)saveEditedFile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveDocxButton;
@property (weak, nonatomic) IBOutlet UIButton *viewDocxButton;

- (IBAction)unZipDoc:(id)sender;
- (IBAction)zipDoc:(id)sender;
- (IBAction)parseXMLFiles:(id)sender;
- (IBAction)viewNewlyCreatedDocx:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *insideView;

- (IBAction)backButtonPressed:(id)sender;


@end

NS_ASSUME_NONNULL_END
