//
//  ViewController.m
//  DocxReadingDemo
//
//  Created by mac on 23/01/18.
//  Copyright © 2018 Xanadutec. All rights reserved.
//

#import "EditDocxViewController.h"
#import "ZipArchive.h"
#import "SSZipArchive.h"

@interface EditDocxViewController ()



@end

@implementation EditDocxViewController

@synthesize referenceTextView,textViewCount,scrollView,insideView,textAdded,elementChanged,modifiedTextViewTagsArray,XPathForTextViewDict,theDocument, relsDocument,elementIndexDict,bundleFileName,zipDocxFileName,unzipFolderName,textViewContentHeightDict,locAndLenOfRunEleUsingTxVwTagDic;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeKeyBoard:) name:UIKeyboardWillShowNotification object:nil];

    self.wkWebView.userInteractionEnabled = false;
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
//    
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
    
//    [self copyBundleDocxFileToDirectory];
    
//    [self unZipToMakeXML];
    
    
}

- (void)removeKeyBoard:(NSNotification *)notify {
    // web is your UIWebView
//    [self.wkWebView evaluateJavaScript:@"document.activeElement.blur()" completionHandler:nil];
    [self.wkWebView endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self parseXMLFiles:nil];
//    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Operative Note Different Template"] ofType:@"htm"];
    NSString* sourcePath = @"https://www.cubescribeonline.com/CubeApp4Intranet/test/test";
//    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Operative Note Different Template"] ofType:@"htm"];
    
//    [self showHTMLFileUsingFilePathAndTextView:sourcePath];
    if (!isWebViewLoadedOnce) {
        [self showHTMLFileUsingFilePathAndWebView:sourcePath];
        isWebViewLoadedOnce = true;
    }
   

}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    alertController = [UIAlertController alertControllerWithTitle:message
                                                      message:nil
                                               preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                {
        completionHandler();
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:actionDelete];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"");
}

-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"");
}
- (IBAction)backButtonClicked:(id)sender
{
    //@"window.getSelection().toString()"
    NSString *script = @"window.getSelection().toString()";

    [self.wkWebView evaluateJavaScript:script completionHandler:^(NSString *selectedString, NSError *error) {
        NSLog(@"ete");
    }];

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
    
    for (int m = 0; m < bodyElementChildrenArray.count; m++) {
        DDXMLElement* bodyElementChild = [bodyElementChildrenArray objectAtIndex:m];
        NSString* bodyElementChildXPath = [[bodyElementChild XPath] lastPathComponent];
        NSArray* bodyElementXPathArray = [bodyElementChildXPath componentsSeparatedByString:@"["];
       
        if ([[bodyElementXPathArray objectAtIndex:0] isEqualToString:@"p"]) {
            
          
            
            NSArray* paraElementChildrenArray = [bodyElementChild children];
            bool ifTextViewAddedForPara = false, isNumberPrefix = false;;
            UITextView* textView;
            NSString *level, *num;
            for (int n = 0; n < paraElementChildrenArray.count; n++) {
                DDXMLElement* paraElementChild = [paraElementChildrenArray objectAtIndex:n];
                NSString* paraElementChildXPath = [[paraElementChild XPath] lastPathComponent];
                NSArray* paraElementXPathArray = [paraElementChildXPath componentsSeparatedByString:@"["];
               
                
                
                if ([[paraElementXPathArray objectAtIndex:0] isEqualToString:@"pPr"]) {
                    //1.1 p -> pPr : get para. prop.
//                    NSArray *paraPropArray = [bodyElementChild elementsForName:@"w:pPr"];
                    
//                    if (paraPropArray.count > 0) {
                        
                        //1.1.1 p -> pPr -> numPr : get the paragraph numbering from para. prop.
                        
//                        DDXMLElement* paraPropElement = [paraPropArray firstObject];
                        NSArray *numPropArray = [paraElementChild elementsForName:@"w:numPr"];
                        if (numPropArray.count > 0) {
                            DDXMLElement* numPropElement = [numPropArray firstObject];
                            NSArray *numLevelArray = [numPropElement elementsForName:@"w:ilvl"];
                            
                            if (numLevelArray.count > 0) {
                                DDXMLElement* numLevelElement = [numLevelArray firstObject];
                                DDXMLNode* levelNode = [numLevelElement attributeForName:@"w:val"];
                                level = [levelNode stringValue];
                                
                            }
                            NSArray *numIdArray = [numPropElement elementsForName:@"w:numId"];
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
                        }else{
                            isNumberPrefix = false;
                        }
//                    }else{
//                        [levelNumDict removeAllObjects];// to avoid prefixing number to nonNumber paras.
//                    }
                    
                }else if ([[paraElementXPathArray objectAtIndex:0] isEqualToString:@"r"]){
                   
                    // added textview per para HERE bcas we need to add textview only for those para who has run ele.
                    if (!ifTextViewAddedForPara) {
                        // One textView per paragraph
                        UIView* referenceTextView = [insideView viewWithTag:textViewCount];
                        
                        textView = [[UITextView alloc] initWithFrame:CGRectMake(pageLeftMarginIOS, referenceTextView.frame.size.height + referenceTextView.frame.origin.y, docWidthPt-pageRightMarginIOS-pageLeftMarginIOS, 45)];
                        
                        [textView setBackgroundColor:[UIColor clearColor]];
                        
                        textView.returnKeyType = UIReturnKeyDone;
                        
                        textViewCount++;
                        
                        textView.tag = textViewCount;
                        
                        textView.delegate = self;
                        
                        [XPathForTextViewDict setObject:[bodyElementChild XPath] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
                        
                        [elementIndexDict setObject:[NSString stringWithFormat:@"%ld",bodyElementChild.index] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
                        
                        ifTextViewAddedForPara = true;
                    }
//                    for (int i =0;i<runningArray.count;i++)
//                    {
                        NSString* fontNameString, *fontColorString, *fontSizeString;
                        bool isFontBoldForParaText = false;
                        
//                        DDXMLElement *runningElement = [runningArray objectAtIndex:i];
                        
                        //1.2.1 p -> r -> rPr : get properties of run element
                        NSArray* paraRunningPropArray = [paraElementChild elementsForName:@"w:rPr"];
                        
                        if (paraRunningPropArray.count > 0) {
                            
                            DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];
                            
                            fontNameString = [self getFontNameFromElement:paraRunningPropElement];
                           
                            fontSizeString = [self getFontSizeFromElement:paraRunningPropElement];
                            
                            fontColorString = [self getFontColorFromElement:paraRunningPropElement];
                        }
                        
                        //run ele will contain either of textArray, pictArray, tabArray or so on....
                        NSArray* pictArray;
                        NSArray *textArray;
                        NSArray* tabArray;
                        
                        //1.2.2 p -> r -> t : get text from run element
                        if ((textArray = [paraElementChild elementsForName:@"w:t"]).count>0)
                        {
                            isGroupElement = false;
                            
                            DDXMLElement* ele = [textArray objectAtIndex:0];
                            
                            DDXMLNode* str = [ele childAtIndex:0];
                            
                            long locnOfCurrentRunEle = textView.text.length;
                            
                            if (isNumberPrefix) {
                                NSString* bulletNumber = [levelNumDict objectForKey:level];
                                textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%@.  %@",bulletNumber,str]];
                                isNumberPrefix = false;
                            }else{
                                [levelNumDict removeAllObjects];
                                textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
                            }
                           
                            NSMutableDictionary* XPathUsingLocAndLenOfRunEleDic = [locAndLenOfRunEleUsingTxVwTagDic objectForKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];
                            
                            if (XPathUsingLocAndLenOfRunEleDic == nil) {
                                
                                XPathUsingLocAndLenOfRunEleDic = [NSMutableDictionary new];
                                [XPathUsingLocAndLenOfRunEleDic setObject:paraElementChild.XPath forKey:[[NSString stringWithFormat:@"%lu", locnOfCurrentRunEle] stringByAppendingString:[NSString stringWithFormat:@",%lu", (unsigned long)[str stringValue].length]]];
                                [locAndLenOfRunEleUsingTxVwTagDic setObject:XPathUsingLocAndLenOfRunEleDic forKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];
                            }else{
                                [XPathUsingLocAndLenOfRunEleDic setObject:paraElementChild.XPath forKey:[[NSString stringWithFormat:@"%lu", locnOfCurrentRunEle] stringByAppendingString:[NSString stringWithFormat:@",%lu", (unsigned long)[str stringValue].length]]];
                                
                                [locAndLenOfRunEleUsingTxVwTagDic setObject:XPathUsingLocAndLenOfRunEleDic forKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];
                            }
                            
                            
                            NSString* updatedString = [textView.text stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                            
                            updatedString = [updatedString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                            
                            updatedString = [updatedString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                            
                            textView.text = updatedString;
                            
                            CGRect frame = textView.frame;
                            
                            frame.size.height = textView.contentSize.height;
                            
                            textView.frame = frame;
                            
                            [textViewContentHeightDict setObject: [NSString stringWithFormat:@"%f",textView.contentSize.height] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
                            
                        }//1.2.3 p -> r -> pict : get pict from run element
                        else if((pictArray = [paraElementChild elementsForName:@"w:pict"]).count > 0){
                            
                            isGroupElement = true;
                            
                            DDXMLElement* pictureElement = [pictArray objectAtIndex:0];
                            
                            //1.2.3.1 p -> r -> pict -> group : get group from pict of run element
                            NSArray* groupArray = [pictureElement elementsForName:@"v:group"];
                            
                            DDXMLElement* groupElement = [groupArray objectAtIndex:0];
                            
                            //DDXMLElement* ee = [[groupElement parent] parent];
                            DDXMLNode* styleNode = [groupElement attributeForName:@"style"];
                            
                            DDXMLNode* groupCoordOriginNode = [groupElement attributeForName:@"coordorigin"];
                            
                            DDXMLNode* groupCoordSizeNode = [groupElement attributeForName:@"coordsize"];
                            
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
                            
                            float groupLeftMarginWRTiOS = 0.0, groupTopMarginWRTiOS = 0.0, groupWidthWRTiOS = 0.0, groupHeightWRTiOS = 0.0;
                            float groupHeightIOS, groupLeftMarginIOS = 0.0, groupTopMarginIOS = 0.0;
                            
    //                        float groupLeftMarginCalculatedPt = 0.0;
                            float groupAndPageLeftMarginPt = 0.0;
                            
                            if ([groupHeightPtString containsString:@"pt"]) {
                                if ([groupHeightPtString length] > 0) {
                                    groupHeightPtString = [groupHeightPtString substringToIndex:[groupHeightPtString length] - 2]; // remove "pt" suffix to get float value
//                                    groupHeightIOS = [groupHeightPtString floatValue] * 20 * iOSValueOfOneTwip; // ht is in points so one point  = 20 twip
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
                                    groupAndPageLeftMarginPt = ([pageLeftMarginTwip floatValue]/20) + [groupLeftMarginPtString floatValue];
//                                    groupLeftMarginIOS = [groupLeftMarginPtString floatValue] * 20 * iOSValueOfOneTwip;
                                    groupLeftMarginIOS = [groupLeftMarginPtString floatValue];
                                    groupLeftMarginWRTiOS =  pageLeftMarginIOS + groupLeftMarginIOS;
                                    //                            groupLeftMarginWRTiOS = pageLeftMarginIOS + groupLeftMarginPt;
                                }
                            }
                            if ([groupTopMarginPtString containsString:@"pt"]) {
                                if ([groupTopMarginPtString length] > 0) {
                                    groupTopMarginPtString = [groupTopMarginPtString substringToIndex:[groupTopMarginPtString length] - 2];
//                                    groupTopMarginIOS = [groupTopMarginPtString floatValue] * 20 * iOSValueOfOneTwip;
                                    groupTopMarginIOS = [groupTopMarginPtString floatValue];

                                    groupTopMarginWRTiOS = pageTopMarginIOS + groupTopMarginIOS;
                                }
                            }
                            
                            groupElementHeight = groupHeightWRTiOS;
                            
                            
                            NSArray* groupElementChildrenArray = [groupElement children];
                            
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
                                                            
                                                            
                                                            [textView setFont:[UIFont fontWithName:fontNameString size:[fontSizeString floatValue]/2*0.6]];  // fontsize is half of a point...and we want in a point so divide by 2, * 0.6 is for ios scale down
                                                            
                                                            
                                                            textView.text = [textView.text stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
                                                            
                                                            NSString* updatedString = [textView.text stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                                                            
                                                            updatedString = [updatedString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                                                            
                                                            updatedString = [updatedString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                                                            
                                                            textView.text = updatedString;
                                                            
                                                            [textViewContentHeightDict setObject: [NSString stringWithFormat:@"%f",textView.contentSize.height] forKey:[NSString stringWithFormat:@"%ld",textView.tag]];
                                                            
                                                            [groupElementView addSubview:textView];
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
                                                            [groupElementView addSubview:textView];
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
                                                                
                                                                NSString* updatedString = [textView.text stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
                                                                
                                                                updatedString = [updatedString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
                                                                
                                                                updatedString = [updatedString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                                                                
                                                                textView.text = updatedString;
                                                                
                                                                [textViewContentHeightDict setObject: [NSString stringWithFormat:@"%f",textView.contentSize.height] forKey:[NSString stringWithFormat:@"%ld",textView.tag]];
                                                                
                                                                totalTextHeight = totalTextHeight + textView.frame.size.height;
                                                                
                                                                [groupElementView addSubview:textView];
                                                            }
                                                        }
                                                        
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                        }
                                    }
                                 
                                }
                                
                            }
                            //                    textView.tag = 0;
                            
                            groupElementView.tag = textViewCount;
                            
                            totalTextHeight = totalTextHeight + groupElementView.frame.size.height;
                            
                            [insideView addSubview:groupElementView];
                            
                        }
                        else if((tabArray = [paraElementChild elementsForName:@"w:tab"]).count > 0){
                           
                        }
                        
//                    }
                    
                    
                    
                }else if ([[paraElementXPathArray objectAtIndex:0] isEqualToString:@"hyperlink"]){
                    
                    // added textview per para HERE bcas we need to add textview only for those para who has run/hyperlink ele.
                    if (!ifTextViewAddedForPara) {
                        // One textView per paragraph
                        UIView* referenceTextView = [insideView viewWithTag:textViewCount];
                        
                        textView = [[UITextView alloc] initWithFrame:CGRectMake(pageLeftMarginIOS, referenceTextView.frame.size.height + referenceTextView.frame.origin.y, self.view.frame.size.width-pageRightMarginIOS-pageLeftMarginIOS, 45)];
                        
                        [textView setBackgroundColor:[UIColor clearColor]];
                        
                        textView.returnKeyType = UIReturnKeyDone;
                        
                        textViewCount++;
                        
                        textView.tag = textViewCount;
                        
                        textView.delegate = self;
                        
                        [XPathForTextViewDict setObject:[bodyElementChild XPath] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
                        
                        [elementIndexDict setObject:[NSString stringWithFormat:@"%ld",bodyElementChild.index] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
                        
                        ifTextViewAddedForPara = true;
                    }
                    
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
                                    CGRect frame = textView.frame;
                                    frame.size.height = textView.contentSize.height;
                                    textView.frame = frame;
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
                        
//                        if (j!=0) {
                            XPosition = ([[gridColXPosArray objectAtIndex:j] floatValue]*iOSValueOfOneTwip)/20;
//                        }
                        DDXMLElement* tblColParaElement = [tblColParaArray objectAtIndex:k];

                        // One textView per table column paragraph
                        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(pageLeftMarginIOS+XPosition, colYPosition, colWidth, 45)];
                        
                        [textView setBackgroundColor:[UIColor clearColor]];
                        
                        textView.returnKeyType = UIReturnKeyDone;
                        
                        textViewCount++;
                        
                        textView.tag = textViewCount;
                        
                        textView.delegate = self;
                        
                        [XPathForTextViewDict setObject:[tblColParaElement XPath] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
                        
                        [elementIndexDict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)tblColParaElement.index] forKey:[NSString stringWithFormat:@"%ld",(long)textView.tag]];
                        
                        NSArray* paraPropArray = [tblColParaElement elementsForName:@"w:pPr"];
                        NSString* fontNameString, *fontSizeString, *colorString;
                        bool isFontBold = false;
                        if(paraPropArray.count > 0){
                            DDXMLElement* paraPropElement = [paraPropArray firstObject];
                            
                            NSArray* paraRunningPropArray = [paraPropElement elementsForName:@"w:rPr"];
                            
                            if (paraRunningPropArray.count > 0) {
                                
                                DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];
                                
                                NSArray* boldElementArray = [paraRunningPropElement elementsForName:@"w:b"];
                                if (boldElementArray.count > 0) {
                                    isFontBold = true;
                                }else{
                                    isFontBold = false;
                                }
                                
                                if (isFontBold) {
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
                                NSArray* colorElementArray = [paraRunningPropElement elementsForName:@"w:color"];
                                if (colorElementArray.count > 0) {
                                    DDXMLElement* colorNameElement  = [colorElementArray firstObject];
                                    
                                    colorString = [[colorNameElement attributeForName:@"w:val"] stringValue];
                                }
                                NSArray* sizeElementArray = [paraRunningPropElement elementsForName:@"w:sz"];
                                if (sizeElementArray.count > 0) {
                                    DDXMLElement* sizeElement = [sizeElementArray firstObject];
                                    
                                    fontSizeString = [[sizeElement attributeForName:@"w:val"] stringValue];
                                }
                                
                            }
                            
                        }
                        
                        NSArray* paraRunElementArray = [tblColParaElement elementsForName:@"w:r"];
                        for (int l = 0; l < paraRunElementArray.count; l++) {
                            
                            DDXMLElement* paraRunElement = [paraRunElementArray objectAtIndex:l];
                            NSArray* paraRunningPropArray = [paraRunElement elementsForName:@"w:rPr"];
                            if (paraRunningPropArray.count > 0) {
                                
                                DDXMLElement* paraRunningPropElement = [paraRunningPropArray firstObject];
                                
                                NSArray* boldElementArray = [paraRunningPropElement elementsForName:@"w:b"];
                                if (boldElementArray.count > 0) {
                                    isFontBold = true;
                                }else{
                                    isFontBold = false;
                                }
                                
                                if (isFontBold) {
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
                                
//                                NSArray* fontsElementArray = [paraRunningPropElement elementsForName:@"w:rFonts"];
//                                if (fontsElementArray.count > 0) {
//                                    fontNameString = [[fontsElementArray firstObject] stringValue];
//                                }
                                NSArray* colorElementArray = [paraRunningPropElement elementsForName:@"w:color"];
                                if (colorElementArray.count > 0) {
                                    DDXMLElement* colorNameElement  = [colorElementArray firstObject];
                                    
                                    colorString = [[colorNameElement attributeForName:@"w:val"] stringValue];
                                }
                                NSArray* sizeElementArray = [paraRunningPropElement elementsForName:@"w:sz"];
                                if (sizeElementArray.count > 0) {
                                    DDXMLElement* sizeElement = [sizeElementArray firstObject];
                                    
                                    fontSizeString = [[sizeElement attributeForName:@"w:val"] stringValue];
                                }
                                else if ((sizeElementArray = [paraRunningPropElement elementsForName:@"w:szCs"]).count > 0)
                                {
                                    DDXMLElement* sizeElement = [sizeElementArray firstObject];
                                    
                                    fontSizeString = [[sizeElement attributeForName:@"w:val"] stringValue];

                                }
                            }
                            NSArray* textElementArray = [paraRunElement elementsForName:@"w:t"];
                            NSString* text;
                            [textView setFont:[UIFont fontWithName:fontNameString size:[fontSizeString floatValue]/2*0.6]];  // fontsize is half of a point...and we want in a point so divide by 2, * 0.6 is for ios scale down
                            
                            if (textElementArray.count > 0) {
                                DDXMLElement* textElement = [textElementArray firstObject];
                                text = [textElement stringValue];
                                textView.text = [textView.text stringByAppendingString:text];
                                CGRect frame = textView.frame;
                                frame.size.height = textView.contentSize.height;                                
                                textView.frame = frame;
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
-(DDXMLDocument*) parseXmlFromPath:(NSString*)filePath
{
    
    
    //    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"xml"];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    relsDocument = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    
    return relsDocument;
}

- (IBAction)saveEditedFile:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
           (NSDocumentDirectory, NSUserDomainMask, YES);
       NSString *documentsDirectory = [paths objectAtIndex:0];

       
       NSString *filePath = [NSString stringWithFormat:@"%@/Operative Note Differentttttttcopy.htm",
                                                     documentsDirectory];
     
   
    [self saveEditedHTMLFile:filePath];
//    [self saveEditedXMLFile];
}

-(void) saveEditedXMLFile
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
    //    textView.sele
    
    int selectedTextEndLocn = range.location + range.length - 1;
    int updatedSelectedTextLength = range.length;
    int selectedTextStartLocn = range.location;
    
    
    
    NSMutableDictionary* XpathUsingLocLenDic = [locAndLenOfRunEleUsingTxVwTagDic objectForKey:[NSString stringWithFormat:@"%ld", (long)textView.tag]];
    
    NSMutableDictionary* XPathUsingLocDic = [NSMutableDictionary new];
    
    for (NSString* locAndLenKey in XpathUsingLocLenDic) {
        NSArray* runEleStartLocnArr = [locAndLenKey componentsSeparatedByString:@","];
        
        [XPathUsingLocDic setObject:[XpathUsingLocLenDic objectForKey:locAndLenKey] forKey:[runEleStartLocnArr objectAtIndex:0]];
    }
    for (NSString* locAndLenKey in XpathUsingLocLenDic) {
        NSArray* locAndLenOfRunEleArray = [locAndLenKey componentsSeparatedByString:@","];
        
        if ((selectedTextStartLocn >= [[locAndLenOfRunEleArray objectAtIndex:0] intValue]) && (selectedTextStartLocn <= [[locAndLenOfRunEleArray objectAtIndex:1] intValue])) {
            
            NSString* xPathOfSelectedTextsRunElement = [XpathUsingLocLenDic objectForKey:locAndLenKey];
            NSError* error;
            
            bool isIteratedForNxtRunEle = false;
            while(updatedSelectedTextLength > 0){
                
                if (isIteratedForNxtRunEle) {
                    NSString* XPathOfNxtRunEle = [XPathUsingLocDic objectForKey:[NSString stringWithFormat:@"%d", selectedTextStartLocn]];
                    
                    for (NSString* locAndLenKey in XpathUsingLocLenDic) {
                        
                        NSString* XPathToMatch = [XpathUsingLocLenDic objectForKey:locAndLenKey];
                        
                        if ([XPathOfNxtRunEle isEqualToString:XPathToMatch]) {
                            locAndLenOfRunEleArray =  [locAndLenKey componentsSeparatedByString:@","];
                            
                            xPathOfSelectedTextsRunElement = XPathOfNxtRunEle;
                            
                            break;
                        }
                    }
                }
                
                isIteratedForNxtRunEle = true;
                
                DDXMLNode *defaultNamespace = [theDocument.rootElement namespaceForPrefix:@""];
                
                xPathOfSelectedTextsRunElement = [xPathOfSelectedTextsRunElement stringByReplacingOccurrencesOfString:@"/" withString:[NSString stringWithFormat:@"/%@:", defaultNamespace.name]];
                
                NSArray* runEleArray =[[theDocument rootElement] nodesForXPath:xPathOfSelectedTextsRunElement error:&error];
                
                if (runEleArray.count > 0) {
                    DDXMLElement* runEle = [runEleArray firstObject];
                    
                    NSArray* txtEleArray = [runEle elementsForName:@"w:t"];
                    
                    if (txtEleArray.count > 0) {
                        DDXMLElement* txtEle = [txtEleArray firstObject];
                        
                        int runEleEndLocn = [[locAndLenOfRunEleArray objectAtIndex:0] intValue] + [[locAndLenOfRunEleArray objectAtIndex:1] intValue] - 1;
                        
                        NSString* updatedTxt;
                        
                        if (runEleEndLocn <= selectedTextEndLocn) {//29
                            // procedure: general anaesthetic
                            
                            int removeLength = runEleEndLocn - selectedTextStartLocn + 1;// 17 - 9 +1 = 9
                            NSRange rangeToRemove = NSMakeRange(selectedTextStartLocn, removeLength);
                            updatedSelectedTextLength = updatedSelectedTextLength - removeLength;// 20 - 9 = 11
                            selectedTextStartLocn = selectedTextStartLocn + removeLength;// 9 + 9 = 18
                            NSLog(@"");
                        }else{
                            NSRange rangeToRemove = NSMakeRange(selectedTextStartLocn, updatedSelectedTextLength);
                            updatedSelectedTextLength = 0;
                            NSLog(@"");
                        }
                        
                        
                        
                    }
                    
                }
                NSLog(@"fd");
            }
            
            break;;
        }
    }
    if ([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}



-(void) showHTMLFileUsingFilePathAndTextView:(NSString*)filePath
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

-(void) saveEditedHTMLFile:(NSString*)filePath
{

    [_wkWebView evaluateJavaScript:@"document.body.innerHTML" completionHandler:^(id _Nullable ids, NSError * _Nullable error) {
        NSLog(@"id");
        NSLog(@"id");
    }];

//    NSError* error;
//    NSData *data =  [textViewAttributedString dataFromRange:NSMakeRange(0, textViewAttributedString.length) documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} error:&error];
//
//    bool wri = [data writeToFile:filePath atomically:NO];
//    NSLog(@"");

    
    
}

-(void)showHTMLFileUsingFilePathAndWebView:(NSString*)filePath
{
//    CGRect webViewFrame = CGRectMake(self.insideView.frame.origin.x,self.insideView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    CGRect webViewFrame = CGRectMake(0,_navigationView.frame.origin.y+_navigationView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(_navigationView.frame.size.height));
    self.wkWebView = [[WKWebView alloc] initWithFrame:webViewFrame];
    self.wkWebView.tag = 400;
    //
//    NSURLRequest *loadDataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.cubescribeonline.com/CubeApp4Intranet/test/test"]];
//    NSURLRequest *loadDataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?CallingFrm=4&sDictationID=34990&UserID=3"]];
//    NSURLRequest *loadDataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://stackblitz.com/edit/xdmd1f?file=index.ts"]];
//    NSURLRequest *loadDataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.cubescribeonline.com/CubeApp4Intranet/MobileEditor/Editor?CallingFrm=4&sDictationID=34990&UserID=3"]];
    
    NSURLRequest *loadDataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webFilePath]];
//    NSURLRequest *loadDataRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.wkWebView loadRequest:loadDataRequest];
//    self.wkWebView.
   
    [self.view addSubview:self.wkWebView];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webFilePath] options:@{} completionHandler:nil];

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

//    [webView evaluateJavaScript:@"document.body.setAttribute('contentEditable','true')" completionHandler:nil];
//
//    [webView evaluateJavaScript:@"document.documentElement.outerHTML.toString()" completionHandler:^(id _Nullable html, NSError * _Nullable error) {
//        NSError *error1 = NULL;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
//                                                                               options:NSRegularExpressionCaseInsensitive
//                                                                                 error:&error1];
//
//        [regex enumerateMatchesInString:html
//                                options:0
//                                  range:NSMakeRange(0, [html length])
//                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//
//                                 NSString *img = [html substringWithRange:[result rangeAtIndex:2]];
//                                 NSLog(@"img src %@",img);
//                             }];
//        NSLog(@"html");
//
//    }];
                               
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
