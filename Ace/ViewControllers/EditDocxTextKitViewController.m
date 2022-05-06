//
//  ViewController.m
//  DocxReadingDemo
//
//  Created by mac on 23/01/18.
//  Copyright © 2018 Xanadutec. All rights reserved.
//

#import "EditDocxTextKitViewController.h"
#import "ZipArchive.h"
#import "SSZipArchive.h"
#import <CoreText/CoreText.h>

@interface EditDocxTextKitViewController ()



@end

@implementation EditDocxTextKitViewController

@synthesize referenceTextView,textViewCount,scrollView,insideView,textAdded,elementChanged,modifiedTextViewTagsArray,XPathForTextViewDict,theDocument, relsDocument,elementIndexDict,bundleFileName,zipDocxFileName,unzipFolderName,textViewContentHeightDict,locAndLenOfRunEleUsingTxVwTagDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    modifiedTextViewTagsArray = [NSMutableArray new];
    
    textViewContentHeightDict = [NSMutableDictionary new];
    locAndLenOfRunEleUsingTxVwTagDic = [NSMutableDictionary new];
    referenceTextView.translatesAutoresizingMaskIntoConstraints = true;
    [referenceTextView sizeToFit];
    referenceTextView.scrollEnabled = false;
    textViewCount = 2;
    
    self.navigationItem.title=@"Custom Docx Editor";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    
        bundleFileName = @"Operative Note Different Template";
        unzipFolderName = @"sample3Folder";
        zipDocxFileName = @"Operative Note Different Template";
    
//    bundleFileName = @"Wound Check ATT Letter_107_38841";
//    unzipFolderName = @"sample3Folder";
//    zipDocxFileName = @"Wound Check ATT Letter_107_38841";
    
//    bundleFileName = @"Trauma OpNote_502_40370";
//    unzipFolderName = @"sample3Folder";
//    zipDocxFileName = @"Trauma OpNote_502_40370";
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.saveDocxButton.layer.cornerRadius = 4.0;
    
    self.saveDocxButton.layer.borderWidth = 1.0;
    //    3,122,255
    self.saveDocxButton.layer.borderColor = [UIColor colorWithRed:3/255.0 green:122/255.0 blue:1 alpha:1.0].CGColor;
    
    self.viewDocxButton.layer.cornerRadius = 4.0;
    
    self.viewDocxButton.layer.borderWidth = 1.0;
    
    self.viewDocxButton.layer.borderColor = [UIColor colorWithRed:3/255.0 green:122/255.0 blue:1 alpha:1.0].CGColor;
    
    [self copyBundleDocxFileToDirectory];
    
    [self unZipToMakeXML];
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Operative Note Different Template"] ofType:@"htm"];
    
    [self showHTMLFileUsingFilePath:sourcePath];
    
//    [self parseXMLFiles:sourcePath];
}
- (IBAction)backButtonClicked:(id)sender
{
    [self popViewController:sender];
}
-(void)popViewController:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"w:p"])
    {
        
        elementChanged = true;
        
        UITextView* referenceTextView = [insideView viewWithTag:textViewCount];
        
        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(referenceTextView.frame.origin.x, referenceTextView.frame.origin.y+referenceTextView.frame.size.height, self.view.frame.size.width, 30)];
        
        //    UITextView* textView = [[UITextView alloc] init];
        textViewCount++;
        
        textView.tag = textViewCount;
        
        [insideView addSubview:textView];
        
        
        
        
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Did end element");
    //          if ([elementName isEqualToString:@"root"])
    //              {
    if ([elementName isEqualToString:@"w:p"])
    {
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    
    
    
    UITextView* textView = [insideView viewWithTag:textViewCount];
    
    if (elementChanged == false)
    {
        parsedString = [parsedString stringByAppendingString:string];
        
        textView.text = parsedString;
        
        
    }
    else
    {
        parsedString = @"";
        
        textView.text = string;
        
        parsedString = string;
        
        //          textView.translatesAutoresizingMaskIntoConstraints = true;
        //
        //          [textView sizeToFit];
        //
        //          textView.scrollEnabled = false;
        
    }
    
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    textView.frame = frame;
    //
    textView.scrollEnabled = YES;
    textView.contentSize = [textView sizeThatFits:textView.frame.size];
    textView.delegate = self;
    
    //
    //     textView.translatesAutoresizingMaskIntoConstraints = true;
    //
    //     [textView sizeToFit];
    //     textView.scrollEnabled = false;
    
    
    elementChanged = false;
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in self.insideView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    
    self.scrollView.contentSize = contentRect.size;
}
-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"%@",validationError.localizedDescription);
    
}





- (IBAction)unZipDoc:(id)sender
{
    //    ZipArchive* zip = [ZipArchive new];
    //
    //
    //
    //
    //    NSString* unzipPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Kuldeep"]];
    
    
    //
    //        BOOL unzip = [zip UnzipOpenFile:[[NSBundle mainBundle] pathForResource:@"shaila" ofType:@"docx"]]; // first unzip the file
    //
    //
    //        NSString* unZippedFilePath = [[NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject]] stringByAppendingPathComponent:@"shaila"];
    //
    //        BOOL isWritten = [zip UnzipFileTo:unZippedFilePath overWrite:true];
    //
    //        [zip UnzipCloseFile];
    //
    //    }
    // [self unZipToMakeDocx];
    
}

-(void)copyBundleDocxFileToDirectory
{
    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",bundleFileName] ofType:@"docx"];
    
    NSString* destDocxPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.docx",zipDocxFileName]];
    
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destDocxPath error:nil];
    NSLog(@"");
}

-(BOOL)unZipToMakeXML
{
    NSString* unzipPath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",unzipFolderName]];
    
    //
    //
    NSError* err;
    if([[NSFileManager defaultManager] fileExistsAtPath:unzipPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:unzipPath error:&err];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:unzipPath])
    {
        NSError* error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:unzipPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:unzipPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        
        NSString* zipPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",bundleFileName] ofType:@"docx"];
        
        BOOL docxCreated =  [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
        
        return docxCreated;
    }
    
    
    return true;
}

//-(void)parseFile:(NSString*)unZipFileName
//{
//    NSString* filePath = [[NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/word/document.xml",unZipFileName]];
//
//    NSURL *url = [[NSURL alloc]initWithString:filePath];
//    parser = [[NSXMLParser alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:filePath]];
//
//    [parser setDelegate:self];
//    BOOL result = [parser parse];
//}
- (IBAction)zipDoc:(id)sender
{
    
    
    
}

-(BOOL)unZipToMakeDocx
{
    BOOL created =  [SSZipArchive createZipFileAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.docx",zipDocxFileName]] withContentsOfDirectory:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",unzipFolderName]]];
    
    return created;
}

- (IBAction)parseXMLFiles:(id)sender
{
    //[self parseFile:@"Kuldeep"];
    //[self viewXMLFile:@"document"];
    scrollView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    scrollView.layer.borderWidth = 2.0;
    [self parseXML];
    [sender setUserInteractionEnabled:false];
}

- (IBAction)viewNewlyCreatedDocx:(id)sender
{
    [self viewDocxFile:zipDocxFileName];
}

-(void)viewDocxFile:(NSString*)fileName
{
    NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",fileName]];
    
    NSString* newDestPath = [destpath stringByAppendingPathExtension:@"docx"];
    
    UIDocumentInteractionController* interactionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:newDestPath]];
    
    interactionController.delegate = self;
    
    [interactionController presentPreviewAnimated:true];
    
}


-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
    
}
-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
    
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    
    return self;
}



// KissXML


-(void)parseXML
{
    
    textViewCount = 2;
    
    long totalTextHeight = 250;
    
    bool isGroupElement = false;
    
    float groupElementHeight = 0.0;
    
    NSString* filePath = [[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/word/document",unzipFolderName]] stringByAppendingPathExtension:@"xml"];
    
    //    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"xml"];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    theDocument = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    
    //NSArray *results = [theDocument nodesForXPath:@"/bookstore/book[price>35]" error:&error];
    //NSArray *results = [theDocument nodesForXPath:@"w:p" error:&error];
    XPathForTextViewDict = [NSMutableDictionary new];
    
    elementIndexDict = [NSMutableDictionary new];
    
    DDXMLElement* rootElement = [theDocument rootElement] ;
    
    //    DDXMLNode *defaultNamespace = [theDocument.rootElement namespaceForPrefix:@""];
    //        defaultNamespace.name = @"default";
    //        NSArray *xmlNodes = [[theDocument rootElement] nodesForXPath:@"//default:document[1]/default:body[1]" error:nil];
    
    //    /document[1]/body[1]/p[10]
    //    [rootElement nextNode];
    //    [rootElement nextSibling];
    
    NSArray* bodyElementArray = [rootElement elementsForName:@"w:body"];
    
    DDXMLElement* bodyElement = [bodyElementArray objectAtIndex:0];
    
    // get page width, height and margins
    NSArray* docPropArray = [bodyElement elementsForName:@"w:sectPr"];
    
    DDXMLElement* docPropElement = [docPropArray objectAtIndex:0];
    
    NSArray* pgSzArray = [docPropElement elementsForName:@"w:pgSz"];
    
    DDXMLElement* pgSzElement = [pgSzArray objectAtIndex:0];
    
    NSArray* pgMarArray = [docPropElement elementsForName:@"w:pgMar"];
    
    DDXMLElement* pgMarElement = [pgMarArray objectAtIndex:0];
//    float width = self.view.frame.size.width;
    NSString* docWidthTwip = [[pgSzElement attributeForName:@"w:w"] stringValue];
    NSString* docHeightTwip = [[pgSzElement attributeForName:@"w:h"] stringValue];
    
//    float iOSValueOfOneTwip = width/[docWidthTwip intValue] ;
    float docWidthPt = [docWidthTwip intValue]/20;
    float docHeightPt = [docHeightTwip intValue]/20;
    float iOSValueOfOneTwip = 1 ;

//    float iOSExpectedDocHeight = iOSValueOfOneTwip * [docHeightTwip intValue];
    
    NSString* pageTopMarginTwip = [[pgMarElement attributeForName:@"w:top"] stringValue];
    NSString* pageRightMarginTwip = [[pgMarElement attributeForName:@"w:right"] stringValue];
    NSString* pageLeftMarginTwip = [[pgMarElement attributeForName:@"w:left"] stringValue];
    //    NSString* bottomMarginTwip = [[pgMarElement attributeForName:@"w:bottom"] stringValue];
    
    //<w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/>
    //    float docWidth = [docWidthTwip intValue] * iOSValueOfOneTwip;
    //    float docHeight = [docHeightTwip intValue] * iOSValueOfOneTwip;
    float pageTopMarginIOS = ([pageTopMarginTwip intValue] * iOSValueOfOneTwip) / 20;
    float pageRightMarginIOS = ([pageRightMarginTwip intValue] * iOSValueOfOneTwip) / 20;
    float pageLeftMarginIOS = ([pageLeftMarginTwip intValue] * iOSValueOfOneTwip)/20 ;
    //    float docBottomMargin = [bottomMarginTwip intValue] * iOSValueOfOneTwip;
    NSMutableDictionary* levelNumDict = [NSMutableDictionary new];
    NSArray* bodyElementChildrenArray = [bodyElement children];
    
    [[insideView viewWithTag:textViewCount] removeFromSuperview];
    
    UITextView* textView;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(pageLeftMarginIOS, pageTopMarginIOS, docWidthPt-pageRightMarginIOS-pageLeftMarginIOS, docHeightPt)];
    
    [textView setBackgroundColor:[UIColor clearColor]];
    
    textView.returnKeyType = UIReturnKeyDone;
    
    textViewCount++;
    
    textView.tag = textViewCount;
    
    textView.delegate = self;
    
    textView.clipsToBounds = false;
    
//    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    UIFont *defaultFont = [UIFont fontWithName:@"Arial" size:12];

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    NSInteger cnt;
    CGFloat tabInterval = 168.0;
    paragraphStyle.defaultTabInterval = tabInterval;
    NSMutableArray *tabs = [NSMutableArray array];
    for (cnt = 1; cnt < 13; cnt++) {    // Add 12 tab stops, at desired intervals...
        [tabs addObject:[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tabInterval * cnt options:@{}]];
    }
    paragraphStyle.tabStops = tabs;
    
    NSMutableDictionary *attributes = [@{ NSFontAttributeName: defaultFont, NSParagraphStyleAttributeName: paragraphStyle} mutableCopy];
//    CGSize size = CGSizeMake(200, 200);
//    NSValue* value = [NSValue valueWithCGSize:size];
//
//    [attributes setObject:value forKey:NSPaperSizeDocumentAttribute];
    //[bodyElement stringValue]
//    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithData:[source dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType, NSPaperSizeDocumentAttribute: value } documentAttributes:&attributes error:nil];
  

//    [insideView addSubview:textView];
//        NSLog(@"%@", attributedString);
//    [XPathForTextViewDict setObject:[bodyElementChild XPath] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
//
//    [elementIndexDict setObject:[NSString stringWithFormat:@"%ld",bodyElementChild.index] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
    
    for (int m = 0; m < bodyElementChildrenArray.count; m++) {
        DDXMLElement* bodyElementChild = [bodyElementChildrenArray objectAtIndex:m];
        NSString* bodyElementChildXPath = [[bodyElementChild XPath] lastPathComponent];
        NSArray* bodyElementXPathArray = [bodyElementChildXPath componentsSeparatedByString:@"["];

        if ([[bodyElementXPathArray objectAtIndex:0] isEqualToString:@"p"]) {

            bool ifTextViewAddedForPara = false, isNumberPrefix = false;

            NSString *paragraphAlignment = @"left";

            NSString *level, *num;

            [self setAttributedText:textView textToAppend:@"\n" attributes:attributes];

            NSArray* paraElementChildrenArray = [bodyElementChild children];

            for (int n = 0; n < paraElementChildrenArray.count; n++) {
                DDXMLElement* paraElementChild = [paraElementChildrenArray objectAtIndex:n];
                NSString* paraElementChildXPath = [[paraElementChild XPath] lastPathComponent];
                NSArray* paraElementXPathArray = [paraElementChildXPath componentsSeparatedByString:@"["];

                if ([[paraElementXPathArray objectAtIndex:0] isEqualToString:@"pPr"]) {

                    NSArray* paraPropElementChildrenArray = [paraElementChild children];
                    for (int n = 0; n < paraPropElementChildrenArray.count; n++) {
                        DDXMLElement* paraPropElementChild = [paraPropElementChildrenArray objectAtIndex:n];
                        NSString* paraPropElementChildXPath = [[paraPropElementChild XPath] lastPathComponent];
                        NSArray* paraPropElementXPathArray = [paraPropElementChildXPath componentsSeparatedByString:@"["];

                        if ([[paraPropElementXPathArray objectAtIndex:0] isEqualToString:@"tabs"]) {
                            NSArray* paraPropTabElementChildrenArray = [paraPropElementChild children];
                            for (int n = 0; n < paraPropTabElementChildrenArray.count; n++) {
                                DDXMLElement* paraPropTabElementChild = [paraPropTabElementChildrenArray objectAtIndex:n];
                                NSString* paraPropTabElementChildXPath = [[paraPropTabElementChild XPath] lastPathComponent];
                                NSArray* paraPropTabElementXPathArray = [paraPropTabElementChildXPath componentsSeparatedByString:@"["];
                                if ([[paraPropTabElementXPathArray objectAtIndex:0] isEqualToString:@"tab"]) {
//                                   DDXMLNode* positionVal =  [paraPropTabElementChild attributeForName:@"w:pos"];
//                                    NSAttributedString* str = textView.attributedText;
//                                    NSRange range  = NSMakeRange(0, textView.text.length);
//                                    NSMutableDictionary *attributes = [str attributesAtIndex:0 effectiveRange:&range];
//                                    NSMutableParagraphStyle* style = [attributes objectForKey:NSParagraphStyleAttributeName];
//                                    [style setDefaultTabInterval:5];
//
//                                    [attributes setObject:style forKey:NSParagraphStyleAttributeName];
//
//                                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
//
//                                    textView.attributedText = attributedString;
                                }
                            }

                        }else if ([[paraPropElementXPathArray objectAtIndex:0] isEqualToString:@"numPr"]) {

                                NSArray *numLevelArray = [paraPropElementChild elementsForName:@"w:ilvl"];
                                if (numLevelArray.count > 0) {
                                    DDXMLElement* numLevelElement = [numLevelArray firstObject];
                                    DDXMLNode* levelNode = [numLevelElement attributeForName:@"w:val"];
                                    level = [levelNode stringValue];

                                }

                                NSArray *numIdArray = [paraPropElementChild elementsForName:@"w:numId"];
                                if (numIdArray.count > 0) {
                                    DDXMLElement* numIdElement = [numIdArray firstObject];
                                    DDXMLNode* numNode = [numIdElement attributeForName:@"w:val"];
                                    num = [numNode stringValue];
                                    NSString* prevNum = [levelNumDict objectForKey:level];
                                    if (prevNum == nil) {
                                        [levelNumDict setObject:@"1" forKey:level];
                                    }else{
                                        int numInt = [prevNum intValue] + 1;
                                        [levelNumDict setObject:[NSString stringWithFormat:@"%d", numInt] forKey:level];
                                    }
                                }
                                isNumberPrefix = true;

                        }else if ([[paraPropElementXPathArray objectAtIndex:0] isEqualToString:@"jc"]){
                            DDXMLNode* alignmentVal =  [paraPropElementChild attributeForName:@"w:val"];
                            paragraphAlignment = [alignmentVal stringValue];
                        }
                    }

                }else if ([[paraElementXPathArray objectAtIndex:0] isEqualToString:@"r"]){


                        NSString* fontNameString, *fontColorString, *fontSizeString;

                        NSArray* paraRunningPropArray = [paraElementChild elementsForName:@"w:rPr"];

                        if (paraRunningPropArray.count > 0) {

                            DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];

                            fontNameString = [self getFontNameFromElement:paraRunningPropElement];

                            fontSizeString = [self getFontSizeFromElement:paraRunningPropElement];

                            fontColorString = [self getFontColorFromElement:paraRunningPropElement];
                        }

                        NSArray* paraRunElementChildrenArray = [paraElementChild children];
                        for (int n = 0; n < paraRunElementChildrenArray.count; n++) {
                            DDXMLElement* paraRunElementChild = [paraRunElementChildrenArray objectAtIndex:n];
                            NSString* paraRunElementChildXPath = [[paraRunElementChild XPath] lastPathComponent];
                            NSArray* paraRunElementXPathArray = [paraRunElementChildXPath componentsSeparatedByString:@"["];

                            if ([[paraRunElementXPathArray objectAtIndex:0] isEqualToString:@"t"]){

                                isGroupElement = false;

                                DDXMLNode* str = [paraRunElementChild childAtIndex:0];

                                long locnOfCurrentRunEle = textView.text.length;

                                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

                                if ([paragraphAlignment isEqualToString:@"center"]) {

                                    paragraphStyle.alignment = NSTextAlignmentCenter;

                                }else
                                {
                                   paragraphStyle.alignment = NSTextAlignmentLeft;
                                }

                                NSDictionary *attributes = @{ NSFontAttributeName: defaultFont, NSParagraphStyleAttributeName: paragraphStyle};


                                NSString* textWithBulletNumber;

                                if (isNumberPrefix) {
                                    NSString* bulletNumber = [levelNumDict objectForKey:level];
                                    textWithBulletNumber = [bulletNumber stringByAppendingString:[str stringValue]];

                                    isNumberPrefix = false;

                                }else{
                                    textWithBulletNumber = [str stringValue];

                                    [levelNumDict removeAllObjects];

                                }

                                [self setAttributedText:textView textToAppend:textWithBulletNumber attributes:attributes];

                                NSMutableDictionary* XPathUsingLocAndLenOfRunEleDic = [locAndLenOfRunEleUsingTxVwTagDic objectForKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];

                                if (XPathUsingLocAndLenOfRunEleDic == nil) {

                                    XPathUsingLocAndLenOfRunEleDic = [NSMutableDictionary new];
                                    [XPathUsingLocAndLenOfRunEleDic setObject:paraElementChild.XPath forKey:[[NSString stringWithFormat:@"%lu", locnOfCurrentRunEle] stringByAppendingString:[NSString stringWithFormat:@",%lu", (unsigned long)[str stringValue].length]]];
                                    [locAndLenOfRunEleUsingTxVwTagDic setObject:XPathUsingLocAndLenOfRunEleDic forKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];
                                }else{
                                    [XPathUsingLocAndLenOfRunEleDic setObject:paraElementChild.XPath forKey:[[NSString stringWithFormat:@"%lu", locnOfCurrentRunEle] stringByAppendingString:[NSString stringWithFormat:@",%lu", (unsigned long)[str stringValue].length]]];

                                    [locAndLenOfRunEleUsingTxVwTagDic setObject:XPathUsingLocAndLenOfRunEleDic forKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];
                                }

                                CGRect frame = textView.frame;

                                frame.size.height = textView.contentSize.height;

                                textView.frame = frame;

                                [textViewContentHeightDict setObject: [NSString stringWithFormat:@"%f",textView.contentSize.height] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];

                            }else if ([[paraRunElementXPathArray objectAtIndex:0] isEqualToString:@"pict"]){

                                isGroupElement = true;
                                //1.2.3.1 p -> r -> pict -> group : get group from pict of run element
                                NSArray* paraRunPictElementChildArray = [paraRunElementChild children];

                                for (int n = 0; n < paraRunPictElementChildArray.count; n++) {
                                    DDXMLElement* paraRunPictElementChild = [paraRunPictElementChildArray objectAtIndex:n];
                                    NSString* paraRunPictElementChildXPath = [[paraRunPictElementChild XPath] lastPathComponent];
                                    NSArray* paraRunPictElementXPathArray = [paraRunPictElementChildXPath componentsSeparatedByString:@"["];

                                    if ([[paraRunPictElementXPathArray objectAtIndex:0] isEqualToString:@"group"]){

                                        //DDXMLElement* ee = [[groupElement parent] parent];
                                        DDXMLNode* styleNode = [paraRunPictElementChild attributeForName:@"style"];

                                        DDXMLNode* groupCoordOriginNode = [paraRunPictElementChild attributeForName:@"coordorigin"];

                                        DDXMLNode* groupCoordSizeNode = [paraRunPictElementChild attributeForName:@"coordsize"];

                                        NSString* groupCoordOriginString = [groupCoordOriginNode stringValue];

                                        NSString* groupCoordSizeString = [groupCoordSizeNode stringValue];

                                        NSArray* groupCoordOriginArray = [groupCoordOriginString componentsSeparatedByString:@","];

                                        NSArray* groupCoordSizeArray = [groupCoordSizeString componentsSeparatedByString:@","];

                                        float groupCoordOriginX = 0.0, groupCoordOriginY = 0.0, groupCoordWidth = 0.0, groupCoordHeight = 0.0;
                                        if (groupCoordOriginArray.count == 2) {
                                            groupCoordOriginX = [[groupCoordOriginArray objectAtIndex:0] floatValue];
                                            groupCoordOriginY = [[groupCoordOriginArray objectAtIndex:1] floatValue];

                                        }
                                        if (groupCoordSizeArray.count == 2) {
                                            groupCoordWidth = [[groupCoordSizeArray objectAtIndex:0] floatValue];
                                            groupCoordHeight = [[groupCoordSizeArray objectAtIndex:1] floatValue];
                                        }
                                        NSString* styleString = [styleNode stringValue];

                                        NSArray* styleAttribute = [styleString componentsSeparatedByString:@";"];

                                        NSMutableDictionary* styleDict = [NSMutableDictionary new];
                                        for (NSString* att in styleAttribute) {
                                            NSArray* styleKey = [att componentsSeparatedByString:@":"];
                                            [styleDict setObject:[styleKey objectAtIndex:1] forKey:[styleKey objectAtIndex:0]];
                                        }
                                        NSString* groupHeightPtString = [styleDict valueForKey:@"height"];
                                        NSString* groupWidthPtString = [styleDict valueForKey:@"width"];
                                        NSString* groupLeftMarginPtString = [styleDict valueForKey:@"margin-left"];
                                        NSString* groupTopMarginPtString = [styleDict valueForKey:@"margin-top"];
                //                        NSString* pos = [styleDict valueForKey:@"position"];

                                        float groupLeftMarginWRTiOS = 0.0, groupTopMarginWRTiOS = 0.0, groupWidthWRTiOS = 0.0, groupHeightWRTiOS = 0.0, groupHeightIOS;

                                        if ([groupHeightPtString containsString:@"pt"]) {
                                            if ([groupHeightPtString length] > 0) {
                                                groupHeightPtString = [groupHeightPtString substringToIndex:[groupHeightPtString length] - 2]; // remove "pt" suffix to get float value
                                                groupHeightIOS = [groupHeightPtString floatValue]; // ht is in points so one point  = 20 twip
                                                groupHeightWRTiOS = groupHeightIOS;
                                            }
                                        }
                                        if ([groupWidthPtString containsString:@"pt"]) {
                                            if ([groupWidthPtString length] > 0) {
                                                groupWidthPtString = [groupWidthPtString substringToIndex:[groupWidthPtString length] - 2];
                                                groupWidthWRTiOS = [groupWidthPtString floatValue];
                                            }
                                        }
                                        if ([groupLeftMarginPtString containsString:@"pt"]) {
                                            if ([groupLeftMarginPtString length] > 0) {
                                                groupLeftMarginPtString = [groupLeftMarginPtString substringToIndex:[groupLeftMarginPtString length] - 2];
                                                groupLeftMarginWRTiOS =  [groupLeftMarginPtString floatValue];

                                            }
                                        }
                                        if ([groupTopMarginPtString containsString:@"pt"]) {
                                            if ([groupTopMarginPtString length] > 0) {
                                                groupTopMarginPtString = [groupTopMarginPtString substringToIndex:[groupTopMarginPtString length] - 2];
                                                groupTopMarginWRTiOS = [groupTopMarginPtString floatValue];
                                            }
                                        }

                                        groupElementHeight = groupHeightWRTiOS;

                                        NSArray* groupElementChildrenArray = [paraRunPictElementChild children];

                                        UIView* groupElementView = [[UIView alloc] initWithFrame: CGRectMake(groupLeftMarginWRTiOS, groupTopMarginWRTiOS, groupWidthWRTiOS, groupHeightWRTiOS)];

                                        for (DDXMLElement* groupChildElement in groupElementChildrenArray) {
                                            NSString *elementPathString = groupChildElement.XPath.lastPathComponent;
                                            NSString *elementNameString = [elementPathString lastPathComponent];

                                            //1.2.3.1.1 p -> r -> pict -> group -> shape : get shape from group
                                            if ([elementNameString containsString:@"shape"] && ![elementNameString containsString:@"shapetype"]) {

                                                DDXMLNode* styleNode = [groupChildElement attributeForName:@"style"];

                                                NSString* styleString = [styleNode stringValue];

                                                NSArray* styleAttribute = [styleString componentsSeparatedByString:@";"];

                                                NSMutableDictionary* styleDict = [NSMutableDictionary new];
                                                for (NSString* att in styleAttribute) {
                                                    NSArray* styleKey = [att componentsSeparatedByString:@":"];
                                                    [styleDict setObject:[styleKey objectAtIndex:1] forKey:[styleKey objectAtIndex:0]];
                                                }
                                                NSString* ht = [styleDict valueForKey:@"height"];
                                                NSString* wt = [styleDict valueForKey:@"width"];
                                                NSString* left = [styleDict valueForKey:@"left"];
                                                NSString* top = [styleDict valueForKey:@"top"];
                                                NSString* pos = [styleDict valueForKey:@"position"];


                                                float groupElementLeftPosition = ((([left floatValue] - groupCoordOriginX) / 20) * iOSValueOfOneTwip) ; // minus groupCoordOriginX i.e. start from the origin
                                                float groupElementTopPosition = (((([top floatValue] - groupCoordOriginY))/20) * iOSValueOfOneTwip);
                                                float groupElementWidth = (([wt floatValue]/20)*iOSValueOfOneTwip);
                                                float groupElementHeight = (([ht floatValue]/20)*iOSValueOfOneTwip);

                                                //v:image, v:textbox
                                                //1.2.3.1.1.1 p -> r -> pict -> group -> shape -> imagedata : get imagedata from shape
                                                NSArray* imageElementArray = [groupChildElement elementsForName:@"v:imagedata"];

                                                NSArray* textboxElementArray;

                                                if (imageElementArray.count > 0) {
                                                    DDXMLElement* imageElement = [imageElementArray firstObject];
                                                    NSString* relationId = [[imageElement attributeForName:@"r:id"] stringValue];

                                                    NSString* filePath = [[[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/word/_rels/document",unzipFolderName]] stringByAppendingPathExtension:@"xml"] stringByAppendingPathExtension:@"rels"];

                                                    DDXMLDocument* relsDocument = [self parseXmlFromPath:filePath];

                                                    DDXMLElement* relsRootElement = [relsDocument rootElement];

                                                    NSString* imagePath;
                                                    NSArray* relationshipElementArray = [relsRootElement elementsForName:@"Relationship"];
                                                    for (DDXMLElement* relationshipElement in relationshipElementArray) {
                                                        NSString* elementRelationId = [[relationshipElement attributeForName:@"Id"] stringValue];

                                                        if ([elementRelationId isEqualToString:relationId]) {

                                                            NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/word",unzipFolderName]];


                                                            imagePath = [[relationshipElement attributeForName:@"Target"] stringValue];

                                                            imagePath = [filePath stringByAppendingPathComponent:imagePath];
                                                            break;
                                                        }
                                                    }

                                                    if (imagePath != nil) {
                                                        UIImageView* shapeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(groupElementLeftPosition, groupElementTopPosition, groupElementWidth, groupElementHeight)];

                                                        shapeImageView.image = [UIImage imageWithContentsOfFile:imagePath];

                                                        [groupElementView addSubview:shapeImageView];
                                                    }
                                                }//1.2.3.1.1.1 p -> r -> pict -> group -> shape -> textbox : get textbox from shape
                                                else if ((textboxElementArray = [groupChildElement elementsForName:@"v:textbox"]).count > 0) {

                                                    DDXMLElement* textboxElement =  [textboxElementArray firstObject];

                                                    NSArray* txbxContentElementArray =  [textboxElement elementsForName:@"w:txbxContent"];

                                                    if (txbxContentElementArray.count > 0) {

                                                        DDXMLElement* txbxContentElement =  [txbxContentElementArray firstObject];

                                                        NSArray* paragraphArray = [txbxContentElement elementsForName:@"w:p"];

                                                        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(groupElementLeftPosition, groupElementTopPosition, groupElementWidth, groupElementHeight)];

                                                        [textView setBackgroundColor:[UIColor clearColor]];

                                                        [textView setTextAlignment:NSTextAlignmentRight]; // Note: set statically, fetch the property then set



                                                        for (int i =0 ; i < paragraphArray.count; i++)
                                                        {
                                                            if (i !=0) {
                                                                textView.text = [textView.text stringByAppendingString:@"\n"];
                                                            }

                                                            DDXMLElement* paragraph = [paragraphArray objectAtIndex:i];

                                                            NSString* fontNameString, *fontSizeString, *fontColorString;
                                                            bool isFontBold = false;
                                                            NSArray *paraPropArray = [paragraph elementsForName:@"w:pPr"];

                                                            if (paraPropArray.count > 0) {

                                                                DDXMLElement* paraPropElement = [paraPropArray firstObject];

                                                                NSArray* paraRunningPropArray = [paraPropElement elementsForName:@"w:rPr"];

                                                                if (paraRunningPropArray.count > 0) {

                                                                    DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];

                                                                    fontNameString = [self getFontNameFromElement:paraRunningPropElement];

                                                                    fontColorString = [self getFontColorFromElement:paraRunningPropElement];

                                                                    fontSizeString = [self getFontSizeFromElement:paraRunningPropElement];

                                                                }
                                                            }
                                                            // parahraph can have running elements or smartTags or so on(addon them in if, if, if..like below)
                                                            NSArray *runningArray = [paragraph elementsForName:@"w:r"];
                                                            NSArray *hyperLinkArray;
                                                            if (runningArray.count > 0) {

                                                                for (int i = 0; i < runningArray.count; i++) {

                                                                    DDXMLElement* runningElement = [runningArray objectAtIndex:i];

                                                                    NSArray* paraRunningPropArray = [runningElement elementsForName:@"w:rPr"];

                                                                    if (paraRunningPropArray.count > 0) {

                                                                        DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];

                                                                        fontNameString = [self getFontNameFromElement:paraRunningPropElement];

                                                                        fontColorString = [self getFontColorFromElement:paraRunningPropElement];

                                                                        fontSizeString = [self getFontSizeFromElement:paraRunningPropElement];

                                                                    }
                                                                    NSArray *textArray = [runningElement elementsForName:@"w:t"];

                                                                    if (textArray.count>0)
                                                                    {
                                                                        isGroupElement = false;

                                                                        DDXMLElement* ele = [textArray objectAtIndex:0];

                                                                        DDXMLNode* str = [ele childAtIndex:0];

                                                                        UIFont* defaultFont = [attributes valueForKey:NSFontAttributeName];

                                                                        UIFont* txtbxFont = [UIFont fontWithName:fontNameString size:[fontSizeString floatValue]/2];
            //                                                            [textView setFont:txtbxFont];  // fontsize is half of a point...and we want in a point so divide by 2, * 0.6 is for ios scale down
                                                                        [attributes setValue:txtbxFont forKey:NSFontAttributeName];

                                                                        [self setAttributedText:textView textToAppend:[str stringValue] attributes:attributes];

                                                                        [textViewContentHeightDict setObject: [NSString stringWithFormat:@"%f",textView.contentSize.height] forKey:[NSString stringWithFormat:@"%ld",textView.tag]];

            //                                                            [groupElementView addSubview:textView];
                                                                    }

                                                                }

                                                            }
                                                            if ((hyperLinkArray = [paragraph elementsForName:@"w:hyperlink"]).count > 0) {


                                                                DDXMLElement* hyperLinkElement = [hyperLinkArray firstObject];

                                                                NSArray* runElementArray = [hyperLinkElement elementsForName:@"w:r"];

                                                                if (runElementArray.count > 0) {
                                                                    DDXMLElement* runElement = [runElementArray firstObject];

                                                                    NSArray* textArray = [runElement elementsForName:@"w:t"];

                                                                    if (textArray.count > 0) {
                                                                        DDXMLElement* textElement = [textArray firstObject];

                                                                        NSString* text = [textElement stringValue];
                                                                        textView.text = [textView.text stringByAppendingString:text];
                                                                        CGRect frame = textView.frame;
                                                                        frame.size.height = textView.contentSize.height;
                                                                        textView.frame = frame;
            //                                                            [groupElementView addSubview:textView];
                                                                    }
                                                                }


                                                            }

                                                            NSArray *smartTagElementArray = [paragraph elementsForName:@"w:smartTag"];

                                                            if (smartTagElementArray.count > 0) {

                                                                DDXMLElement* smartTagElement =  [smartTagElementArray objectAtIndex:0];

                                                                NSArray* innerSmartTagElementArray =  [smartTagElement elementsForName:@"w:smartTag"];

                                                                if (innerSmartTagElementArray.count > 0) {
                                                                    DDXMLElement* innerSmartTagElement =  [innerSmartTagElementArray objectAtIndex:0];

                                                                    NSArray* runningArray =    [innerSmartTagElement elementsForName:@"w:r"];

                                                                    if (runningArray.count > 0) {
                                                                        DDXMLElement* runningElement =  [runningArray objectAtIndex:0];

                                                                        NSArray* paraRunningPropArray = [runningElement elementsForName:@"w:rPr"];

                                                                        if (paraRunningPropArray.count > 0) {

                                                                            DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];

                                                                            fontNameString = [self getFontNameFromElement:paraRunningPropElement];

                                                                            fontColorString = [self getFontColorFromElement:paraRunningPropElement];

                                                                            fontSizeString = [self getFontSizeFromElement:paraRunningPropElement];
                                                                        }
                                                                        NSArray* textArray =  [runningElement elementsForName:@"w:t"];

                                                                        if (textArray.count > 0) {
                                                                            DDXMLElement* textElement =  [textArray objectAtIndex:0];

                                                                            DDXMLNode* str =  [textElement childAtIndex:0];

                                                                            [textView setFont:[UIFont fontWithName:fontNameString size:[fontSizeString floatValue]/2*0.6]]; // fontsize is half of a point...and we want in a point so divide by 2, * 0.6 is for ios scale down

                                                                            textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%@",str]];

                                                                            [textViewContentHeightDict setObject: [NSString stringWithFormat:@"%f",textView.contentSize.height] forKey:[NSString stringWithFormat:@"%ld",textView.tag]];

                                                                            totalTextHeight = totalTextHeight + textView.frame.size.height;

                                                                        }
                                                                    }

                                                                }
                                                            }


                                                        }

                                                        [groupElementView addSubview:textView];
                                                    }
                                                }

                                            }

                                        }
                                        //                    textView.tag = 0;

                                        groupElementView.tag = textViewCount;

                                        totalTextHeight = totalTextHeight + groupElementView.frame.size.height;

                                        [textView addSubview:groupElementView];
                                    }
                                }


                            }else if ([[paraRunElementXPathArray objectAtIndex:0] isEqualToString:@"tab"]){
                                [self setAttributedText:textView textToAppend:@"\t" attributes:attributes];

                                }
                        }


//                    }



                }else if ([[paraElementXPathArray objectAtIndex:0] isEqualToString:@"hyperlink"]){



                    NSArray* hyperlinkElementChildrenArray = [paraElementChild children];
                    for(int i = 0; i < hyperlinkElementChildrenArray.count;i++){
                        DDXMLElement* hyperLinkChildElement = [hyperlinkElementChildrenArray objectAtIndex:i];

                        NSString* hyperLinkChildElementXPath = [[hyperLinkChildElement XPath] lastPathComponent];
                        NSArray* hyperLinkChildElementXPathArray = [hyperLinkChildElementXPath componentsSeparatedByString:@"["];
                        if ([[hyperLinkChildElementXPathArray objectAtIndex:0] isEqualToString:@"r"]){
                            NSArray* runChildElementArray = [hyperLinkChildElement children];

                            for(int j = 0; j < runChildElementArray.count; j++){
                                DDXMLElement* runChildElement = [runChildElementArray objectAtIndex:j];

                                NSString* runChildElementXPath = [[runChildElement XPath] lastPathComponent];
                                NSArray* runChildElementXPathArray = [runChildElementXPath componentsSeparatedByString:@"["];
                                if ([[runChildElementXPathArray objectAtIndex:0] isEqualToString:@"t"]){

                                    NSString* text = [runChildElement stringValue];
                                    textView.text = [textView.text stringByAppendingString:text];
//                                    CGRect frame = textView.frame;
//                                    frame.size.height = textView.contentSize.height;
//                                    textView.frame = frame;
                                }
                            }
                        }
                    }
//                    DDXMLElement* hyperLinkElement = [hyperLinkArray firstObject];
//
//                    NSArray* runElementArray = [hyperLinkElement elementsForName:@"w:r"];
//
//                    if (runElementArray.count > 0) {
//                        DDXMLElement* runElement = [runElementArray firstObject];
//
//                        NSArray* textArray = [runElement elementsForName:@"w:t"];
//
//                        if (textArray.count > 0) {
//                            DDXMLElement* textElement = [textArray firstObject];
//
//                            //                        DDXMLNode* textNode = [textElement childAtIndex:0];
//
//                            NSString* text = [textElement stringValue];
//                            textView.text = [textView.text stringByAppendingString:text];
//                            CGRect frame = textView.frame;
//                            frame.size.height = textView.contentSize.height;
//                            textView.frame = frame;
//                            [groupElementView addSubview:textView];
//                        }
//                    }
                }
            }

            if (textView.text.length > 0) {

                totalTextHeight = totalTextHeight + textView.frame.size.height;

                [insideView addSubview:textView];
            }
            else{ // if no text that may mean <w:r> with <w:tab>(atleast for the current nhs template) and no text...but you have to add the textfield since when you will fetch y posn and height in next loop you should get the below textfield.


                CGRect frame = textView.frame;

                frame.size.height = 35;
                frame.size.width = 0;

                textView.frame = frame;
                [insideView addSubview:textView];
            }

            // 1.2 p -> r : get run elements of para.

            NSArray *runningArray = [bodyElementChild elementsForName:@"w:r"];
            NSArray *hyperlinkArray = [bodyElementChild elementsForName:@"w:hyperlink"];
            // instead of iterating all the run element like next for loop...we need to get all the elements from paragrpah ele. and then go through them serially like we did for all the body element
            if (runningArray.count > 0) {



            }
            //            if((hyperLinkArray = [bodyElementChild elementsForName:@"w:hyperlink"]).count > 0){
            //
            //            }
            //


        }
        else if ([[bodyElementXPathArray objectAtIndex:0] isEqualToString:@"tbl"])
        {

            NSMutableArray* gridColWidthArray = [NSMutableArray new];
            NSMutableArray* gridColXPosArray = [NSMutableArray new];
//            DDXMLElement* tblElement = [tableArray firstObject];
            NSArray* tblGridArray = [bodyElementChild elementsForName:@"tblGrid"];
            if (tblGridArray.count > 0) {
                DDXMLElement* tblGridElement = [tblGridArray firstObject];
                NSArray* gridColArray = [tblGridElement elementsForName:@"gridCol"];
                if (gridColArray.count > 0) {
                    for (int i = 0; i < gridColArray.count; i++) {
                       DDXMLElement* gridColElement = [gridColArray objectAtIndex:i];
                       NSString* gridColWidth = [[gridColElement attributeForName:@"w:w"] stringValue];
                        [gridColWidthArray addObject:gridColWidth];
                        if (i==0) {
                            [gridColXPosArray addObject:[NSString stringWithFormat:@"%d",0]];
                        }else{
                            int prevX = [[gridColXPosArray objectAtIndex:i-1] intValue];
                            int currentWidth = [[gridColWidthArray objectAtIndex:i-1] intValue];
                            [gridColXPosArray addObject:[NSString stringWithFormat:@"%d",prevX+currentWidth]];
                        }
                    }
                }
            }

            NSArray* tblRowArray = [bodyElementChild elementsForName:@"w:tr"];

            for (int i = 0; i < tblRowArray.count; i++) {
                DDXMLElement* tblRowElement = [tblRowArray objectAtIndex:i];
                NSArray* tblColElementArray = [tblRowElement elementsForName:@"w:tc"];
                UIView* referenceTextView = [insideView viewWithTag:textViewCount];
                float colYPosition = referenceTextView.frame.size.height + referenceTextView.frame.origin.y;
                for (int j = 0; j < tblColElementArray.count; j++) {

                    DDXMLElement* tblColElement = [tblColElementArray objectAtIndex:j];
                    NSArray* tblColPropArray = [tblColElement elementsForName:@"w:tcPr"];
                    if (tblColPropArray.count > 0) {
                       DDXMLElement* tblColPropElement = [tblColPropArray firstObject];
                    }
                    NSArray* tblColParaArray = [tblColElement elementsForName:@"w:p"];

                    for (int k = 0; k < tblColParaArray.count; k++) {

                        float colWidth = ([[gridColWidthArray objectAtIndex:j] floatValue]*iOSValueOfOneTwip)/20, XPosition = 0.0;

                        XPosition = ([[gridColXPosArray objectAtIndex:j] floatValue]*iOSValueOfOneTwip)/20;

                        DDXMLElement* tblColParaElement = [tblColParaArray objectAtIndex:k];

                        NSArray* paraPropArray = [tblColParaElement elementsForName:@"w:pPr"];
                        NSString* fontNameString, *fontSizeString, *colorString;
                        bool isFontBold = false;
                        if(paraPropArray.count > 0){
                            DDXMLElement* paraPropElement = [paraPropArray firstObject];

                            NSArray* paraRunningPropArray = [paraPropElement elementsForName:@"w:rPr"];

                            if (paraRunningPropArray.count > 0) {

                                DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];

                                fontNameString = [self getFontNameFromElement:paraRunningPropElement];

                                colorString = [self getFontColorFromElement:paraRunningPropElement];

                                fontSizeString = [self getFontSizeFromElement:paraRunningPropElement];

                            }

                        }

                        NSArray* paraRunElementArray = [tblColParaElement elementsForName:@"w:r"];
                        for (int l = 0; l < paraRunElementArray.count; l++) {

                            DDXMLElement* paraRunElement = [paraRunElementArray objectAtIndex:l];
                            NSArray* paraRunningPropArray = [paraRunElement elementsForName:@"w:rPr"];
                            if (paraRunningPropArray.count > 0) {

                                DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];

                                fontNameString = [self getFontNameFromElement:paraRunningPropElement];

                                colorString = [self getFontColorFromElement:paraRunningPropElement];

                                fontSizeString = [self getFontSizeFromElement:paraRunningPropElement];

                                NSArray* sizeElementArray;
                                if ([fontSizeString isEqualToString:@""] || ((sizeElementArray = [paraRunningPropElement elementsForName:@"w:szCs"]).count > 0))
                                {
                                    DDXMLElement* sizeElement = [sizeElementArray firstObject];

                                    fontSizeString = [[sizeElement attributeForName:@"w:val"] stringValue];

                                }
                            }
                            NSArray* textElementArray = [paraRunElement elementsForName:@"w:t"];
                            NSString* text;
                            UIFont* specificFont = [UIFont fontWithName:fontNameString size:[fontSizeString floatValue]/2];

//                            [textView setFont:specificFont];  // fontsize is half of a point...and we want in a point so divide by 2, * 0.6 is for ios scale down

                            if (textElementArray.count > 0) {
                                DDXMLElement* textElement = [textElementArray firstObject];
                                text = [textElement stringValue];

                                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                               paragraphStyle.alignment = NSTextAlignmentLeft;

                                NSDictionary *attributes;

                                if (specificFont != nil) {
                                    attributes = @{ NSFontAttributeName: specificFont, NSParagraphStyleAttributeName: paragraphStyle};
                                }else{
                                    attributes = @{ NSFontAttributeName: defaultFont, NSParagraphStyleAttributeName: paragraphStyle};
                                }



                                [self setAttributedText:textView textToAppend:text attributes:attributes];
//                                textView.text = [textView.text stringByAppendingString:text];
                                CGRect frame = textView.frame;
                                frame.size.height = textView.contentSize.height;
                                textView.frame = frame;
                            }



                        }
//                        if (textView.text.length > 0) {
//
//                            totalTextHeight = totalTextHeight + textView.frame.size.height;
//
//                            [insideView addSubview:textView];
//                        }
//                        else{ // if no text that may mean <w:r> with <w:tab>(atleast for the current nhs template) and no text...but you have to add the textfield since when you will fetch y posn and height in next loop you should get the below textfield.
//
//
//                            CGRect frame = textView.frame;
//
//                            frame.size.height = 35;
//                            frame.size.width = 0;
//
//                            textView.frame = frame;
//                            [insideView addSubview:textView];
//                        }
                    }
                }
            }

        }



        if (insideView.frame.size.height < totalTextHeight)
        {
            CGRect frame = insideView.frame;

            frame.size.height = totalTextHeight;
            frame.size.width = [docWidthTwip intValue] /20;

            insideView.frame = frame;

            CGSize size = CGSizeMake(insideView.frame.size.width, insideView.frame.size.height);

            self.scrollView.contentSize = size;

            [insideView removeConstraint:_insideViewWidthConstraint];

            _insideViewWidthConstraint = [NSLayoutConstraint
                                           constraintWithItem:insideView
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:0
                                           constant:size.width];

            [insideView addConstraint:_insideViewWidthConstraint];


            [insideView removeConstraint:_insideViewHeightConstraint];

            _insideViewHeightConstraint = [NSLayoutConstraint
                                           constraintWithItem:insideView
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:0
                                           constant:size.height];

            [insideView addConstraint:_insideViewHeightConstraint];
        }

    }
    
//    CGRect frame = insideView.frame;
//
//    frame.size.height = textView.contentSize.height;
//    frame.size.width = textView.contentSize.width;
//
//    insideView.frame = frame;
//
//    CGSize size = CGSizeMake(insideView.frame.size.width, insideView.frame.size.height);
//
//    self.scrollView.contentSize = size;
//
//    [insideView removeConstraint:_insideViewWidthConstraint];
//
//    _insideViewWidthConstraint = [NSLayoutConstraint
//                                  constraintWithItem:insideView
//                                  attribute:NSLayoutAttributeWidth
//                                  relatedBy:NSLayoutRelationEqual
//                                  toItem:nil
//                                  attribute:NSLayoutAttributeNotAnAttribute
//                                  multiplier:0
//                                  constant:size.width];
//
//    [insideView addConstraint:_insideViewWidthConstraint];
//
//
//    [insideView removeConstraint:_insideViewHeightConstraint];
//
//    _insideViewHeightConstraint = [NSLayoutConstraint
//                                   constraintWithItem:insideView
//                                   attribute:NSLayoutAttributeHeight
//                                   relatedBy:NSLayoutRelationEqual
//                                   toItem:nil
//                                   attribute:NSLayoutAttributeNotAnAttribute
//                                   multiplier:0
//                                   constant:size.height];
//
//    [insideView addConstraint:_insideViewHeightConstraint];
//
//    textViewAttributedString = textView.attributedText;
    [insideView addSubview:textView];
    
}

-(NSString*) getFontColorFromElement:(DDXMLElement*)paraRunningPropElement{
    NSString* colorString;
    NSArray* colorElementArray = [paraRunningPropElement elementsForName:@"w:color"];
    if (colorElementArray.count > 0) {
        DDXMLElement* colorNameElement  = [colorElementArray firstObject];
        
        colorString = [[colorNameElement attributeForName:@"w:val"] stringValue];
    }
    return colorString;
   
}

-(NSString*) getFontSizeFromElement:(DDXMLElement*)paraRunningPropElement{
    NSString* fontSizeString;
    NSArray* sizeElementArray = [paraRunningPropElement elementsForName:@"w:sz"];
    if (sizeElementArray.count > 0) {
        DDXMLElement* sizeElement = [sizeElementArray firstObject];
        
        fontSizeString = [[sizeElement attributeForName:@"w:val"] stringValue];
    }
    return fontSizeString;
}

-(NSString*) getFontNameFromElement:(DDXMLElement*)paraRunningPropElement{
    NSString* fontNameString;
    bool isFontBoldForParaText;
    
    NSArray* boldElementArray = [paraRunningPropElement elementsForName:@"w:b"];
    if (boldElementArray.count > 0) {
        isFontBoldForParaText = true;
    }else{
        isFontBoldForParaText = false;
    }
    
    if (isFontBoldForParaText) {
        NSArray* fontsElementArray = [paraRunningPropElement elementsForName:@"w:rFonts"];
        if (fontsElementArray.count > 0) {
            DDXMLElement* fontNameElement = [fontsElementArray firstObject] ;
            
            fontNameString = [[[fontNameElement attributeForName:@"w:cs"] stringValue] stringByAppendingString:@"-Bold"];
        }
    }else{
        NSArray* fontsElementArray = [paraRunningPropElement elementsForName:@"w:rFonts"];
        if (fontsElementArray.count > 0) {
            DDXMLElement* fontNameElement = [fontsElementArray firstObject] ;
            
            fontNameString = [[fontNameElement attributeForName:@"w:cs"] stringValue];
        }
    }
    
    return fontNameString;
}
-(void)setAttributedText:(UITextView*)textView textToAppend:(NSString*)newText attributes:(NSDictionary*)attributes{
    
    NSMutableAttributedString *existingAttributedString = [textView.attributedText mutableCopy];
    NSMutableAttributedString *newAttributedString = [[NSMutableAttributedString alloc]initWithString:newText attributes:attributes];
    [existingAttributedString appendAttributedString:newAttributedString];
    textView.attributedText = existingAttributedString;
}
-(DDXMLDocument*) parseXmlFromPath:(NSString*)filePath
{
    
    
    //    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"xml"];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    relsDocument = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    
    return relsDocument;
}

- (IBAction)saveEditedFile:(id)sender
{
    [self.view endEditing:YES];
    NSError *error;
    
    NSString* filePath = [[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/word/document",unzipFolderName]] stringByAppendingPathExtension:@"xml"];
    
    NSString* content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    BOOL saved = [self saveEditedFileResource:content];
    
    if (saved == true)
    {
        BOOL docxCreated = [self unZipToMakeDocx];
        
        if (docxCreated == true)
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"File Saved Successfully!" withMessage:@"File saved successfully, click View Docx button to view the file." withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        }
        else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Save Failed!" withMessage:@"Something went wrong, unable to save the File" withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
            
        }
        
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Save Failed!" withMessage:@"Something went wrong, unable to save the File" withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
    }
    
}

-(BOOL)saveEditedFileResource:(NSString*)source
{
    
    NSData* data = [theDocument XMLData];
    // NSString* editedFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/editedXML5"]] stringByAppendingPathExtension:@"xml"];
    
    NSError* err;
    NSString* editedFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/word/document",unzipFolderName]] stringByAppendingPathExtension:@"xml"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:editedFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:editedFilePath error:&err];
    }
    
    
    BOOL written = [data writeToFile:editedFilePath atomically:true];
    
    return written;
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return true;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if(![modifiedTextViewTagsArray containsObject:[NSString stringWithFormat:@"%ld",(long)textView.tag]])
    {
        [modifiedTextViewTagsArray addObject:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
    }
    
    int textViewIndex = [[elementIndexDict objectForKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]] intValue];
    
    NSString* path = [XPathForTextViewDict objectForKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
    
    path = [path stringByReplacingOccurrencesOfString:@"/" withString:@"/w:"];
    
    path = [path stringByReplacingOccurrencesOfString:@"/w:text[1]" withString:@""];
    
    DDXMLElement* bodyElement = [[theDocument rootElement] childAtIndex: 0];
    
    DDXMLElement* oldParaElement = [bodyElement childAtIndex:textViewIndex]; // get the old paragraph to get running ele. prop
    
    NSArray* paraPropertyArray = [oldParaElement elementsForName:@"w:pPr"];
    
    // get oldRunningElementArray from paraElement
    NSArray* oldRunningElementArray = [oldParaElement elementsForName:@"w:r"];  // get running ele. from old para
    
    DDXMLElement* runningPropElement;
    
    // get oldrunning property from oldRunningElementArray
    for (DDXMLElement* runningElement in oldRunningElementArray)
    {
        NSArray* runningPropArray = [runningElement elementsForName:@"w:rPr"];  // get running prop ele.
        
        for (DDXMLElement* _runningPropElement in runningPropArray)
        {
            runningPropElement = [_runningPropElement copy];
        }
    }
    
    DDXMLElement* runningElement = [DDXMLElement elementWithName:@"w:r" stringValue:@""];
    
    DDXMLElement* textElement = [DDXMLElement elementWithName:@"w:t" stringValue:textView.text];
    
    DDXMLElement* paraElement = [DDXMLElement elementWithName:@"w:p" stringValue:@""];
    
    //if textView is empty
    if (oldRunningElementArray.count == 0)
    {
        runningPropElement = [DDXMLElement elementWithName:@"w:rPr" stringValue:@""];
        
        [runningElement addChild:runningPropElement];
    }
    else if (runningPropElement != nil)
    {
        [runningElement addChild:[runningPropElement copy]];
    }
    
    for (DDXMLElement* ele in paraPropertyArray)
    {
        [paraElement addChild:[ele copy]];
        
    }
    
    [runningElement addChild:textElement];
    
    [paraElement addChild:runningElement];
    
    [bodyElement insertChild:paraElement atIndex:textViewIndex];
    
    [bodyElement removeChildAtIndex:textViewIndex+1];
    
    
    
    
    CGFloat fixedWidth = textView.frame.size.width;
    
    CGRect newFrame = textView.frame;
    
    newFrame.size = CGSizeMake(fixedWidth,textView.contentSize.height);
    
    textView.frame = newFrame;
    
    
    // set the remaining text field which are below the current textfield
    double preContentHeight = [[textViewContentHeightDict objectForKey:[NSString stringWithFormat:@"%ld",textView.tag]] doubleValue];
    
    double currentContentHeight = textView.contentSize.height;
    
    double changedContentHeight = currentContentHeight  - preContentHeight;
    
    for (long i = textView.tag+1; i<textViewCount; i++)
    {
        if (changedContentHeight != 0)
        {
            
            
            UITextView* nextTextView = [insideView viewWithTag:i];
            
            CGRect nextFrame = nextTextView.frame;
            
            nextTextView.frame = CGRectMake(nextTextView.frame.origin.x, nextTextView.frame.origin.y+changedContentHeight, nextFrame.size.width, nextFrame.size.height);
            
            
            NSArray* constraints = [nextTextView constraints];
            
            for (NSLayoutConstraint* constraint in constraints)
            {
                [nextTextView removeConstraint:constraint];
            }
            
        }
        
    }
    
    [textViewContentHeightDict setObject:[NSString stringWithFormat:@"%f",currentContentHeight] forKey:[NSString stringWithFormat:@"%ld",textView.tag]
     ];
    
    
    textViewAttributedString = textView.attributedText;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
//
//    int selectedTextEndLocn = range.location + range.length - 1;
//    int updatedSelectedTextLength = range.length;
//    int selectedTextStartLocn = range.location;
//
//
//
//    NSMutableDictionary* XpathUsingLocLenDic = [locAndLenOfRunEleUsingTxVwTagDic objectForKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];
//
//    NSMutableDictionary* XPathUsingLocDic = [NSMutableDictionary new];
//
//    for (NSString* locAndLenKey in XpathUsingLocLenDic) {
//        NSArray* runEleStartLocnArr = [locAndLenKey componentsSeparatedByString:@","];
//
//        [XPathUsingLocDic setObject:[XpathUsingLocLenDic objectForKey:locAndLenKey] forKey:[runEleStartLocnArr objectAtIndex:0]];
//    }
//    for (NSString* locAndLenKey in XpathUsingLocLenDic) {
//        NSArray* locAndLenOfRunEleArray = [locAndLenKey componentsSeparatedByString:@","];
//
//        if ((selectedTextStartLocn >= [[locAndLenOfRunEleArray objectAtIndex:0] intValue]) && (selectedTextStartLocn <= [[locAndLenOfRunEleArray objectAtIndex:1] intValue])) {
//
//            NSString* xPathOfSelectedTextsRunElement = [XpathUsingLocLenDic objectForKey:locAndLenKey];
//            NSError* error;
//
//            bool isIteratedForNxtRunEle = false;
//            while(updatedSelectedTextLength > 0){
//
//                if (isIteratedForNxtRunEle) {
//                    NSString* XPathOfNxtRunEle = [XPathUsingLocDic objectForKey:[NSString stringWithFormat:@"%d", selectedTextStartLocn]];
//
//                    for (NSString* locAndLenKey in XpathUsingLocLenDic) {
//
//                        NSString* XPathToMatch = [XpathUsingLocLenDic objectForKey:locAndLenKey];
//
//                        if ([XPathOfNxtRunEle isEqualToString:XPathToMatch]) {
//                            locAndLenOfRunEleArray =  [locAndLenKey componentsSeparatedByString:@","];
//
//                            xPathOfSelectedTextsRunElement = XPathOfNxtRunEle;
//
//                            break;
//                        }
//                    }
//                }
//
//                isIteratedForNxtRunEle = true;
//
//                DDXMLNode *defaultNamespace = [theDocument.rootElement namespaceForPrefix:@""];
//
//                xPathOfSelectedTextsRunElement = [xPathOfSelectedTextsRunElement stringByReplacingOccurrencesOfString:@"/" withString:[NSString stringWithFormat:@"/%@:", defaultNamespace.name]];
//
//                NSArray* runEleArray =[[theDocument rootElement] nodesForXPath:xPathOfSelectedTextsRunElement error:&error];
//
//                if (runEleArray.count > 0) {
//                    DDXMLElement* runEle = [runEleArray firstObject];
//
//                    NSArray* txtEleArray = [runEle elementsForName:@"w:t"];
//
//                    if (txtEleArray.count > 0) {
//                        DDXMLElement* txtEle = [txtEleArray firstObject];
//
//                        int runEleEndLocn = [[locAndLenOfRunEleArray objectAtIndex:0] intValue] + [[locAndLenOfRunEleArray objectAtIndex:1] intValue] - 1;
//
//                        NSString* updatedTxt;
//
//                        if (runEleEndLocn <= selectedTextEndLocn) {//29
//                            // procedure: general anaesthetic
//
//                            int removeLength = runEleEndLocn - selectedTextStartLocn + 1;// 17 - 9 +1 = 9
//                            NSRange rangeToRemove = NSMakeRange(selectedTextStartLocn, removeLength);
//                            updatedSelectedTextLength = updatedSelectedTextLength - removeLength;// 20 - 9 = 11
//                            selectedTextStartLocn = selectedTextStartLocn + removeLength;// 9 + 9 = 18
//                            NSLog(@"");
//                        }else{
//                            NSRange rangeToRemove = NSMakeRange(selectedTextStartLocn, updatedSelectedTextLength);
//                            updatedSelectedTextLength = 0;
//                            NSLog(@"");
//                        }
//
//
//
//                    }
//
//                }
//                NSLog(@"fd");
//            }
//
//            break;
//        }
//    }
//    if ([text isEqualToString:@"\n"])
//    {
//
//        [textView resignFirstResponder];
//
//        return NO;
//    }
   
    return YES;
}



-(void)backButtonPressed:(id)sender
{

    [self saveEditedHTMLFile];
    
    [self dismissViewControllerAnimated:true completion:nil];
    

}

-(void) showHTMLFileUsingFilePath:(NSString*)filePath
{
    UITextView* textView;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, insideView.frame.size.width, insideView.frame.size.height)];
    
    textView.delegate = self;
    NSError* error;
    
    NSURL* url = [[NSURL alloc] initFileURLWithPath:filePath];
    
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithURL:url options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:&error];
    
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    
    textView.attributedText = attributedString1;
    textViewAttributedString = attributedString1;
    CGRect frame = insideView.frame;
    
    frame.size.height = textView.contentSize.height;
    frame.size.width = insideView.frame.size.width;
    
    insideView.frame = frame;
    
    CGSize size = CGSizeMake(insideView.frame.size.width, insideView.frame.size.height);
    
    self.scrollView.contentSize = size;
    
    [insideView removeConstraint:_insideViewHeightConstraint];
    
    _insideViewHeightConstraint = [NSLayoutConstraint
                                   constraintWithItem:insideView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:0
                                   constant:size.height];
    
    [insideView addConstraint:_insideViewHeightConstraint];
    
    [insideView addSubview:textView];
    
}
-(void) saveEditedHTMLFile
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains
           (NSDocumentDirectory, NSUserDomainMask, YES);
       NSString *documentsDirectory = [paths objectAtIndex:0];

       //make a file name to write the data to using the documents directory:
       NSString *fileName = [NSString stringWithFormat:@"%@/Operative Note Differentttttttcopy.htm",
                                                     documentsDirectory];
       //create content - four lines of text
//    NSData *rtfd = [textViewAttributedString RTFDFromRange:NSMakeRange(0, textViewAttributedString.length)
//                    documentAttributes:nil];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: textViewAttributedString];
    NSError* error;
    NSData *data =  [textViewAttributedString dataFromRange:NSMakeRange(0, textViewAttributedString.length) documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} error:&error];
       //save content to the documents directory
    bool wri = [data writeToFile:fileName atomically:NO];
    NSLog(@"");
//       [data writeToFile:fileName
//                        atomically:NO
//                              encoding:NSStringEncodingConversionAllowLossy
//                                     error:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
