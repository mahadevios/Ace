//
//  ViewController.h
//  DocxReadingDemo
//
//  Created by mac on 23/01/18.
//  Copyright © 2018 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDXML.h"
#import "AppPreferences.h"
#import <WebKit/WebKit.h>


@interface EditDocxViewController : UIViewController<NSXMLParserDelegate,UIDocumentInteractionControllerDelegate,UITextViewDelegate, WKNavigationDelegate, WKUIDelegate>
{
    NSXMLParser * parser;
    NSString* parsedString;
    NSAttributedString* textViewAttributedString;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;
    bool isWebViewLoadedOnce;
}
@property (weak, nonatomic) IBOutlet UIView *saveOptionView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
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

@property(nonatomic,strong) NSString* webFilePath;
@property(nonatomic,strong) DDXMLDocument *theDocument;
@property(nonatomic,strong) DDXMLDocument *relsDocument;
@property(nonatomic, strong) WKWebView* wkWebView;

- (IBAction)saveEditedFile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveDocxButton;
@property (weak, nonatomic) IBOutlet UIButton *viewDocxButton;

- (IBAction)unZipDoc:(id)sender;
- (IBAction)zipDoc:(id)sender;
- (IBAction)parseXMLFiles:(id)sender;
- (IBAction)viewNewlyCreatedDocx:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *insideView;
- (IBAction)backButtonClicked:(id)sender;

@end

