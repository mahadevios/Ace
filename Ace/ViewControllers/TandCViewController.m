//
//  TandCViewController.m
//  Ace
//
//  Created by mac on 27/11/18.
//  Copyright © 2018 Xanadutec. All rights reserved.
//

#import "TandCViewController.h"
#import "APIManager.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "Keychain.h"

@interface TandCViewController ()

@end

@implementation TandCViewController
@synthesize hud;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    hud.minSize = CGSizeMake(150.f, 100.f);
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.label.text = @"Loading Data...";
//    hud.detailsLabel.text = @"Please wait";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateTandCResponse:) name:NOTIFICATION_ACCEPT_TANDC_API
                                               object:nil];
    
//    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"By agreeing to use our service you agree to our privacy policy"];
//
    NSString* str = @"By agreeing to use our service you agree to our privacy policy";
//    [str addAttribute: NSLinkAttributeName value: @"http://xanadutec.com.au/privacy-policy.html" range: NSMakeRange(48, 14)];
    
    self.privacyPolicyLinkTextVIew.scrollEnabled = NO;
    self.privacyPolicyLinkTextVIew.editable = NO;
    self.privacyPolicyLinkTextVIew.textContainer.lineFragmentPadding = 0;
    self.privacyPolicyLinkTextVIew.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.privacyPolicyLinkTextVIew.delegate = self;
//    self.privacyPolicyLinkTextVIew.attributedText = str;
    self.privacyPolicyLinkTextVIew.text = str;
    self.privacyPolicyLinkTextVIew.font = [UIFont systemFontOfSize:14];
    // Do any additional setup after loading the view.
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
   
}

-(void)validateTandCResponse:(NSNotification*)dictObj
{
    
    NSDictionary* responseDict = dictObj.object;
    
    NSString* responseCodeString=  [responseDict valueForKey:RESPONSE_CODE];
    
    [hud hideAnimated:YES];

    if ([responseCodeString intValue]==1)
    {
        
       LoginViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                viewController.modalPresentationStyle = UIModalPresentationFullScreen;
                
                 [self presentViewController:viewController animated:NO completion:nil];
       
    }
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Something went wrong, please try again" withMessage:nil withCancelText:@"Ok" withOkText:nil withAlertTag:1000];
    }
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    NSString* tc = @"Terms and Conditions 1.    Our relationship with you (a)    “XanaduTec™” means Xanadutec Ltd. UK whose principal place of business is at 91 Delamere Road London W5 3JP and XanaduTec Pty Limited ACN 620 425 541 ATF XanaduTec Trust ABN 56485258851 (“XanaduTec”), whose principal place of business is at L14, 275 Alfred Street North Sydney NSW 2060. This document explains how the agreement is made up, and sets out the terms of our agreement with you. (b)    Your use and/or purchase of XanaduTec's products, services and use of websites (including affiliated websites and pages, and including but not limited to the website at www.xanadutec.com.au and www.xanadutec.com) (referred to collectively as the “Services” in this document) is subject to the terms of a legal agreement between you and XanaduTec. (c)    Unless otherwise agreed in writing with XanaduTec, your agreement with XanaduTec will always include the terms and conditions set out in this document (“Main Terms”). (d)    Your agreement with XanaduTec will also include the terms of any Legal Notices we send you or post on any website owned or operated by XanaduTec applicable to the Services, in addition to the Main Terms. All of these are referred to as the “Additional Terms”. Where Additional Terms apply to a Service, these will be accessible for you to read either within, or through your use of, that Service. (e)    The Main Terms, together with the Additional Terms and the XanaduTec Privacy Policy, form a legally binding agreement between you and XanaduTec in relation to your use of the Services. It is important that you take the time to read them carefully. Collectively, this legal agreement is referred to below as the “Terms”. (f)    If there is any contradiction between what the Additional Terms say and what the Main Terms say, then the Additional Terms shall take precedence in relation to that Service. 2.    Accepting the Terms (a)    In order to use the Services, you must first agree to the Terms. You may not use the Services if you do not accept the Terms. (b)    You can accept the Terms by: (i)    clicking to accept or agree to the Terms, where this option is made available to you by XanaduTec in the user interface for any Service; or (ii)    by actually using the Services. In this case, you understand and agree that XanaduTec will treat your use of the Services as acceptance of the Terms from that point onwards. (c)    You may not use the Services and may not accept the Terms if (a) you are not of legal age or capacity to form a binding contract with XanaduTec, or (b) you are a person barred from receiving the Services under the laws of Australia or other countries including the country in which you are resident or from which you use the Services. (d)    XanaduTec Services (through this application) are presently only available to persons residing in the Commonwealth of Australia, although this may extend internationally at our discretion.(e)    Before you continue, you should print off or save a local copy of the Main Terms for your records and ensure that you have obtained independent legal advice in relation to the Main Terms. 3.    Provision of the Services by XanaduTec (a)    XanaduTec will use all reasonable endeavours to provide the Services to you as represented on the XanaduTec website, or any instructional or promotional material provided by or on behalf of XanaduTec. (b)    You acknowledge and agree that the form and nature of the Services which XanaduTec provides may change from time to time without prior notice to you, and you shall remain bound by the Terms when using the Services in any updated or amended version. (c)    You acknowledge and agree that XanaduTec may stop (permanently or temporarily) providing the Services (or any features within the Services) to you or to users generally at XanaduTec’s sole discretion, without prior notice to you. You may stop using the Services at any time. You do not need to specifically inform XanaduTec when you stop using the Services. (d)    You acknowledge and agree that if XanaduTec disables access to your account, you may be prevented from accessing the Services, your account details or any files or other content which is contained in your account. (e)    You acknowledge and agree that while XanaduTec may not currently have set a fixed upper limit on the number of transmissions you may send or receive through the Services or on the amount of storage space used for the provision of any Service, such fixed upper limits may be set by XanaduTec at any time, at XanaduTec’s discretion. 4.    Supply of XanaduTec Services (a)    XanaduTec is a business process outsourcing and knowledge process outsourcing company operating in the Commonwealth of Australia. It deals with services like data processing, Transcription and software development, without limitation. (b)    XanaduTec relies on representations made by our suppliers, and will not be liable to you for any misrepresentation made, if we reasonably relied upon such representation in sourcing any supplying the Services, to the extent allowed by law. (c)    XanaduTec will deliver any transcription or related Services as quickly as possible, and use our best endeavours to ensure the accuracy of the Services. We endeavour to turnaround any such services, within an average of 24 hours, but will not be liable to you for any delay beyond that time. (d)    You agree to pay all fees charged based on XanaduTec’s pricing, charges, and billing terms notified to you. (e)    Information provided by you will be relied upon for the purposes of delivery of the Services. We will not be liable to you for incorrect information provided by you. (f)    XanaduTec attempts to be as accurate as possible. However, XanaduTec does not warrant that the Services supplied by XanaduTec are accurate, complete, reliable, current or error-free. If a Service offered by XanaduTec is not as described, your only remedy is to obtain a refund for that Service alone. (g)    You expressly acknowledge that all Services supplied to you from XanaduTec: (i)    may involve outsourcing, and the provision of your data to any company to which we outsource; (ii)    are priced in Australian Dollars; and (iii)    will be charged, unless expressly stated otherwise, as exclusive of Goods and Services Tax pursuant to A New Tax System (Goods and Services Tax) Act 1999 (Cth). We will issue a tax invoice for all purchases, delivered to your nominated email account and that you will make no objection or claim in relation to any of these matters unless such restriction is prohibited by law. 5.    Your Use of the Services (a)    In order to access certain Services, you will be required to provide information about yourself (identification, payment and contact details) as part of the registration process for the Service, or as part of your continued use of the Services. You agree that any registration information you give to XanaduTec will always be accurate, correct and up to date, and will be provided in accordance with the XanaduTec Privacy Policy and other applicable privacy policies. (b)    XanaduTec will rely on the accuracy of the information you provide. All Services will be provided in accordance with the information you have provided as at the date of provision of the Services. XanaduTec will not be liable to you in any respect or for any amount for any loss suffered by you) if you have not provided accurate information. (c)    Any data you provide to XanaduTec will be error free, legible (or audible) in a manner that will reasonably be considered to allow us to provide the Services. We will not be liable to you in any respect for any amount for any loss suffered by you if you have not provided information of such quality. (d)    You will be required to supply your own equipment (including any voice recording device), internet/data connection and power supply (Equipment) to use the Services, and ensure that the Equipment meets the minimum specifications in order for the Services to function. We are not liable to you for any failure or inadequacy of the equipment. (e)    You agree to use the Services only for purposes that are permitted by (a) these Terms and (b) any applicable law, regulation or generally accepted practices or guidelines in the relevant jurisdictions (including any laws regarding the export of data or software to and from Australia or other relevant countries). (f)    You agree not to access (or attempt to access) any of the Services by any means other than through the interface that is provided by XanaduTec, unless you have been specifically allowed to do so in a separate agreement with XanaduTec. You specifically agree not to access (or attempt to access) any of the Services through any automated means (including use of scripts or web crawlers) and shall ensure that you comply with the instructions set out in any robots.txt file present on the Services. (g)    You agree that you will not engage in any activity that interferes with or disrupts the Services (or the servers and networks which are connected to the Services). (h)    Unless you have been specifically permitted to do so in a separate agreement with XanaduTec, you agree that you will not reproduce, duplicate, copy, sell, trade or resell the Services for any purpose. (i)    You will keep confidential all terms of business between you and XanaduTec in relation to price.                                    (j)    You agree that you are solely responsible for (and that XanaduTec has no responsibility to you or to any third party for) any breach of your obligations under the Terms and for the consequences (including any loss or damage which XanaduTec may suffer) of any such breach. You agree to indemnify XanaduTec for any loss suffered by reason of any breach of your obligations under the Terms (jncluding any consequential damages).6.    Your passwords and account security and data security(a)    You agree and understand that you are responsible for maintaining the confidentiality of passwords associated with any account you use to access the Services.(b)    Accordingly, you agree that you will be solely responsible to XanaduTec for all activities that occur under your account, and XanaduTec will not be responsible for any loss suffered by you or any other person by reason of unauthorised use of your account.(c)    You may not transfer your account to any other person, unless specifically agreed in writing by XanaduTec.(d)    You must change your password before your first use of the Services.(e)    If you become aware of any unauthorised use of your password or of your account, you agree to change your account password and notify XanaduTec immediately using the contact details at www.xanadutec.com or www.xanadutec.com.au (f)    We will take all reasonable steps to ensure the security of any data you provide to us, including use of 256-bit encryption where data is used to provide the Services. We will also use reasonable endeavours to ensure that any company to which we outsource or allocate the provision of Services will comply with our Privacy Policy and Australian law. So long as we take reasonable steps to do so, we shall not be liable to you for any unauthorised disclosure of any information unless we have not notified you as required by our Privacy Policy or by law. 7.    Privacy and your personal information (a)    For information about XanaduTec’s data protection practices, please read XanaduTec’s Privacy Policy. This policy explains how XanaduTec treats your personal information, and protects your privacy, when you use the Services. (b)    You agree to the use of your data in accordance with XanaduTec’s Privacy Policy. 8.    Content in the Services (a)    You understand that all information (such as data files, written text, computer software, music, audio files or other sounds, photographs, videos or other images) which you may have access to as part of, or through your use of, the Services are the sole responsibility of the person from which such content originated. All such information is referred to below as the “Content”. (b)    You should be aware that Content presented to you as part of the Services, including but not limited to advertisements in the Services may be protected by intellectual property rights which are owned by the sponsors or advertisers who provide that Content to XanaduTec (or by other persons or companies on their behalf). You may not modify, rent, lease, loan, sell, distribute or create derivative works based on this Content (either in whole or in part) unless you have been specifically told that you may do so by XanaduTec or by the owners of that Content, in a separate written agreement. (c)    XanaduTec reserves the right (but shall have no obligation) to review, flag, filter, modify, refuse or remove any or all Content from any Service. For some of the Services, XanaduTec may (but has no obligation to) provide tools to filter out explicit sexual content. (d)    You understand that by using the Services you may be exposed to Content that you may find offensive, indecent or objectionable and that, in this respect, you use the Services at your own risk. XanaduTec accepts no responsibility for any exposure you have to such content by using the Services. (e)    You agree that you are solely responsible for (and that XanaduTec has no responsibility to you or to any third party for) any Content that you create, transmit or display while using the Services and for the consequences of your actions (including any loss or damage which XanaduTec may suffer) by doing so. You will indemnify XanaduTec for any loss or damage suffered by XanaduTec as a result of Content published by you. 9.    Proprietary rights (a)    XanaduTec and the ‘XanaduTec’ logo are both trademarks owned by companies associated with XanaduTec. (b)    You acknowledge and agree that XanaduTec (or XanaduTec’s licensors) own all legal right, title and interest in and to the Services, including any intellectual property rights which subsist in the Services (whether those rights happen to be registered or not, and wherever in the world those rights may exist). You further acknowledge that the Services may contain information which is designated confidential by XanaduTec and that you shall not disclose such information without XanaduTec’s prior written consent. (c)    Unless you have agreed otherwise in writing with XanaduTec, nothing in the Terms gives you a right to use any of XanaduTec’s trade names, trade marks, service marks, logos, domain names, and other distinctive brand features. (d)    If you have been given an explicit right to use any of these brand features in a separate written agreement with XanaduTec, then you agree that your use of such features shall be in compliance with that agreement, and any applicable provisions of these terms. (e)    Other than the limited license set out below, XanaduTec acknowledges and agrees that it obtains no right, title or interest from you (or your licensors) under these Terms in or to any Content that you submit, post, transmit or display on, or through, the Services, including any intellectual property rights which subsist in that Content (whether those rights happen to be registered or not, and wherever in the world those rights may exist). Unless you have agreed otherwise in writing with XanaduTec, you agree that you are responsible for protecting and enforcing those rights and that XanaduTec has no obligation to do so on your behalf. XanaduTec shall not be responsible for any infringement of those rights by any person or entity. (f)    You agree that you shall not remove, obscure, or alter any proprietary rights notices (including copyright and trade mark notices) which may be affixed to or contained within the Services. (g)    Unless you have been expressly authorised to do so in writing by XanaduTec, you agree that in using the Services, you will not use any trade mark, service mark, trade name, logo of any company or organization in a way that is likely or intended to cause confusion about the owner or authorized user of such marks, names or logos. You agree to wholly indemnify XanaduTec for any loss or damage suffered by XanaduTec by reason of any breach by you of this Clause. 10.    License from XanaduTec (a)    XanaduTec gives you a personal, worldwide, royalty-free, non-assignable and non-exclusive license to use the software (including websites and any mobile application) provided to you by XanaduTec as part of the Services as provided to you by XanaduTec (referred to as the “Software” below). This license is for the sole purpose of enabling you to use and enjoy the benefit of the Services as provided by XanaduTec, in the manner permitted by the Terms. (b)    You may not (and you may not permit anyone else to) copy, modify, create a derivative work of, reverse engineer, decompile or otherwise attempt to extract the source code of the Software (including our website) or any part thereof, unless this is expressly permitted or required by law, or unless you have been expressly told that you may do so by XanaduTec, in writing. (c)    Unless XanaduTec has given you specific written permission to do so, you may not assign (or grant a sub-license of) your rights to use the Software, grant a security interest in or over your rights to use the Software, or otherwise transfer any part of your rights to use the Software. 11.    Software updates (a)    The Software which you use may automatically download and install updates from time to time from XanaduTec. These updates are designed to improve, enhance and further develop the Services and may take the form of bug fixes, enhanced functions, new software modules and completely new versions. You agree to receive such updates (and permit XanaduTec to deliver these to you) as part of your use of the Services. 12.    Indemnity (a)    You agree to fully and promptly indemnify XanaduTec against any loss (either direct or indirect) damage or expense whatsoever which XanaduTec may suffer or incur in respect of: (1)    Any breach by you of the provisions of this agreement; (2)    Any breach by you of any law, including any law in relation to privacy and ownership of information; (3)    Any claim by any person against you arising out of or in respect of the exploitation of the intellectual property in the Services by XanaduTec. (b)    You irrevocably release XanaduTec and waive all claims which you may have in the future against XanaduTec, in respect of any action, claim or remedy whatsoever in any way attributable to the exploitation of the intellectual property in the Services by XanaduTec, or any part of the Services performed by any company to which XanaduTec outsources where allowed by law. 13.    Ending your relationship with XanaduTec and refund policy (a)    The Terms will continue to apply until terminated by either you or XanaduTec as set out below.(b)    Subject to the balance of this clause, if you want to terminate your legal agreement with XanaduTec, you may do so by: (i)    notifying XanaduTec at any time using the contact page on our website; and (ii)    closing your accounts for all of the Services which you use, where XanaduTec has made this option available to you. (c)    You may obtain a refund for any Services delivered, only if you notify us in writing within 7 days of receipt of those goods, but only where those Services are defective (as determined by us acting reasonably, or otherwise as defined by the UK Consumer Law and Australian Consumer Law). You will be refunded for the equivalent of what you have paid for the defective Service only. (d)    XanaduTec may at any time, terminate its legal agreement with you if: (i)    you have breached any provision of this agreement (or have acted in manner which clearly shows that you do not intend to, or are unable to comply with the provisions of this agreement); or (ii)    XanaduTec is required to do so by law (for example, where the provision of the Services to you is, or becomes, unlawful); or (iii)    any partner with whom XanaduTec offered the Services to you has terminated its relationship with XanaduTec or ceased to offer the Services to you; or (iv)    XanaduTec is transitioning to no longer providing the Services to users in the country in which you are resident or from which you use the service; or (v)    the provision of the Services to you by XanaduTec is, in XanaduTec’s opinion, no longer commercially viable; or (vi)    for any other reason XanaduTec in its reasonable discretion thinks fit. (e)    In the event that the agreement for any reason outlined in this Clause, XanaduTec may (but is not obliged to) refund you for Services not used at the time of termination. (f)    Nothing in this Section shall affect XanaduTec’s rights regarding provision of Services under the Terms. (g)    When these Terms come to an end, all of the legal rights, obligations and liabilities that you and XanaduTec have benefited from, been subject to (or which have accrued over time whilst the Terms have been in force) or which are expressed to continue indefinitely, shall be unaffected by this cessation, and the provisions of these Terms shall continue to apply to such rights, obligations and liabilities indefinitely. 14.    EXCLUSION OF LIABILITY (a)    NOTHING IN THESE TERMS, SHALL EXCLUDE OR LIMIT XANADUTEC’S WARRANTY OR LIABILITY FOR LOSSES WHICH MAY NOT BE LAWFULLY EXCLUDED OR LIMITED BY APPLICABLE LAW. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF CERTAIN WARRANTIES OR CONDITIONS OR THE LIMITATION OR EXCLUSION OF LIABILITY FOR LOSS OR DAMAGE CAUSED BY NEGLIGENCE, BREACH OF CONTRACT OR BREACH OF IMPLIED TERMS, OR INCIDENTAL OR CONSEQUENTIAL DAMAGES. ACCORDINGLY, ONLY THE LIMITATIONS WHICH ARE LAWFUL IN YOUR JURISDICTION WILL APPLY TO YOU AND OUR LIABILITY WILL BE LIMITED TO THE MAXIMUM EXTENT PERMITTED BY LAW. (b)    YOU EXPRESSLY UNDERSTAND AND AGREE THAT YOUR USE OF THE SERVICES IS AT YOUR SOLE RISK AND THAT THE SERVICES ARE PROVIDED ”AS IS“ AND “AS AVAILABLE.”(c)    IN PARTICULAR, XANADUTEC DO NOT REPRESENT OR WARRANT TO YOU THAT: (i)    YOUR USE OF THE SERVICES WILL MEET YOUR REQUIREMENTS,(ii)    YOUR USE OF THE SERVICES WILL BE UNINTERRUPTED, TIMELY, SECURE OR FREE FROM ERROR OR VIRUSES, (iii)    ANY INFORMATION OBTAINED BY YOU AS A RESULT OF YOUR USE OF THE SERVICES WILL BE ACCURATE OR RELIABLE, AND (iv)    THAT DEFECTS IN THE OPERATION OR FUNCTIONALITY OF ANY SOFTWARE PROVIDED TO YOU AS PART OF THE SERVICES WILL BE CORRECTED. (d)    ANY MATERIAL DOWNLOADED OR OTHERWISE OBTAINED THROUGH THE USE OF THE SERVICES IS DONE AT YOUR OWN DISCRETION AND RISK AND YOU WILL BE SOLELY RESPONSIBLE FOR ANY DAMAGE TO YOUR COMPUTER SYSTEM OR OTHER DEVICE OR LOSS OF DATA THAT RESULTS FROM THE DOWNLOAD OF ANY SUCH MATERIAL. (e)    NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM XANADUTEC OR THROUGH OR FROM THE SERVICES SHALL CREATE ANY WARRANTY NOT EXPRESSLY STATED IN THE TERMS. (f)    XANADUTEC FURTHER EXPRESSLY DISCLAIMS ALL WARRANTIES AND CONDITIONS OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO THE IMPLIED WARRANTIES AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. 15.    LIMITATION OF LIABILITY (a)    YOU EXPRESSLY UNDERSTAND AND AGREE THAT XANADUTEC, ITS SUBSIDIARIES AND AFFILIATES, AND ITS LICENSORS SHALL NOT BE LIABLE TO YOU FOR: (i)    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL CONSEQUENTIAL OR EXEMPLARY DAMAGES WHICH MAY BE INCURRED BY YOU, HOWEVER CAUSED AND UNDER ANY THEORY OF LIABILITY. THIS SHALL INCLUDE, BUT NOT BE LIMITED TO, ANY LOSS OF PROFIT (WHETHER INCURRED DIRECTLY OR INDIRECTLY), ANY LOSS OF GOODWILL OR BUSINESS REPUTATION, ANY LOSS OF DATA SUFFERED, COST OF PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, OR OTHER INTANGIBLE LOSS; (ii)    ANY LOSS OR DAMAGE WHICH MAY BE INCURRED BY YOU., INCLUDING BUT NOT LIMITED TO LOSS OR DAMAGE AS A RESULT OF ANY RELIANCE PLACED BY YOU ON THE COMPLETENESS, ACCURACY OR EXISTENCE OF ANY ADVERTISING, OR AS A RESULT OF ANY RELATIONSHIP OR TRANSACTION BETWEEN YOU AND ANY ADVERTISER OR SPONSOR WHOSE ADVERTISING APPEARS ON THE SERVICES. (iii)    ANY CHANGES WHICH XANADUTEC MAY MAKE TO THE SERVICES, OR FOR ANY PERMANENT OR TEMPORARY CESSATION IN THE PROVISION OF THE SERVICES (OR ANY FEATURES WITHIN THE SERVICES); (iv)    THE DELETION OF, CORRUPTION OF, OR FAILURE TO STORE, ANY CONTENT AND OTHER COMMUNICATIONS DATA MAINTAINED OR TRANSMITTED BY OR THROUGH YOUR USE OF THE SERVICES; (v)    YOUR FAILURE TO PROVIDE XANADUTEC WITH ACCURATE ACCOUNT INFORMATION; (vi)    YOUR FAILURE TO KEEP YOUR PASSWORD OR ACCOUNT DETAILS SECURE AND CONFIDENTIAL; (b)    THE LIMITATIONS ON XANADUTEC’S LIABILITY TO YOU ABOVE SHALL APPLY WHETHER OR NOT XANADUTEC HAS BEEN ADVISED OF OR SHOULD HAVE BEEN AWARE OF THE POSSIBILITY OF ANY SUCH LOSSES ARISING. (c)    WE SHALL NOT BE LIABLE TO YOU FOR ANY DELAY OR FAILURE TO PERFORM OR PROVIDE THE SERVICES BY REASON OF ANY CIRCUMSTANCES BEYOND OUR REASONABLE CONTROL. (d)    IN THE EVENT THAT XANADUTEC IS FOUND TO BE LIABLE TO YOU, OUR LIABILITY SHALL BE LIMITED TO A REFUND OF AMOUNTS PAID BY YOU TO XANADUTEC. 16.    Copyright and trade mark policies (a)    It is XanaduTec’s policy to respond to notices of alleged copyright and trademark infringement that comply with applicable international intellectual property law, including the Copyright Act and Trade Marks Act (Cth of Australia) and to terminating the accounts of repeat infringers. 17.    Advertisements (a)    Some of the Services are supported by advertising revenue and may display advertisements and promotions. These advertisements may be targeted to the content of information stored on the Services, queries made through the Services or other information. (b)    The manner, mode and extent of advertising by XanaduTec on the Services are subject to change without specific notice to you. (c)    In consideration for XanaduTec granting you access to and use of the Services, you agree that XanaduTec may place such advertising on the Services. (d)    Without limiting the effect of the above, XanaduTec accepts no responsibility and will not be liable to you for any loss suffered by reason of the existence any advertising on the Services. 18.    Other content (a)    The Services may include hyperlinks to other web sites or content or resources. XanaduTec may have no control over any web sites or resources which are provided by companies or persons other than XanaduTec. (b)    You acknowledge and agree that XanaduTec is not responsible for the availability of any such external sites or resources, and does not endorse any advertising, products or other materials on or available from such web sites or resources. (c)    You acknowledge and agree that XanaduTec is not liable for any loss or damage which may be incurred by you as a result of the availability of those external sites or resources, or as a result of any reliance placed by you on the completeness, accuracy or existence of any advertising, products or other materials on, or available from, such web sites or resources. 19.    Changes to the Terms (a)    XanaduTec may make changes to the Main Terms or Additional Terms from time to time. When these changes are made, XanaduTec will make a new copy of the Terms available on our website or any other Software and any new Additional Terms will be made available to you from within, or through, the affected Services. XanaduTec shall not be required to otherwise notify you of any changes to the Terms or Additional Terms, and you agree to be bound by the Terms as applicable from time to time. (b)    You understand and agree that if you use the Services after the date on which the Main Terms or Additional Terms have changed, XanaduTec will treat your use as acceptance of the updated Main Terms or Additional Terms. 20.    General legal terms (a)    Sometimes when you use the Services, you may (as a result of, or through your use of the Services) use a service or download a piece of software, or purchase goods, which are provided by another person or company. Your use of these other services, software or goods may be subject to separate terms between you and the company or person concerned. If so, the Terms do not affect your legal relationship with these other companies or individuals. (b)    The Terms constitute the whole legal agreement between you and XanaduTec and govern your use of the Services (but excluding any services which XanaduTec may provide to you under a separate written agreement), and completely replace any prior agreements and/or representations between you and XanaduTec in relation to the Services. (c)    You agree that XanaduTec may provide you with notices, including those regarding changes to the Terms, by email, regular mail, or postings on the Services. (d)    You agree that if XanaduTec does not exercise or enforce any legal right or remedy which is contained in the Terms (or which XanaduTec has the benefit of under any applicable law), this will not be taken to be a waiver of XanaduTec’s rights and that those rights or remedies will still be available to XanaduTec. (e)    If any court of competent jurisdiction rules that any provision of these Terms is invalid, then that provision will be read down or removed from the Terms without affecting the rest of the Terms. The remaining provisions of the Terms will continue to be valid and enforceable. (f)    No agency or partnership shall be construed to have been created by virtue of this agreement. (g)    You acknowledge and agree that each member of any company or entity to which XanaduTec is directly affiliated (through whole or part ownership or control) shall be third party beneficiaries to the Terms and that such other companies shall be entitled to directly enforce, and rely upon, any provision of the Terms which confers a benefit on (or rights in favor of) them. Other than this, no other person or company shall be third party beneficiaries to the Terms.(h)    The Terms, and your relationship with XanaduTec under the Terms, shall be governed by the laws of the State of New South Wales (or Australia where applicable) without regard to its conflict of laws provisions. You and XanaduTec agree to submit to the exclusive jurisdiction of the courts located within the State of New South Wales (or Australia, where applicable) to resolve any legal matter arising from the Terms. Notwithstanding this, you agree that XanaduTec shall still be allowed to apply for injunctive remedies (or an equivalent type of urgent legal relief, interlocutory or final) in any jurisdiction. (i)    You acknowledge and warrant that you are of legal capacity and have obtained, or had a reasonable opportunity to obtain independent legal advice in relation to the Terms and enter this agreement with an understanding of the legal and practical effect of the Terms. XanaduTec shall not be liable for any breach of this warranty.";
    

    
//    NSString *filePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TCsFinal.docx"];
//
//    [self.webView setDelegate:self];
//    self.webView.scrollView.delegate = self;
//    NSURL *url = [NSURL fileURLWithPath:filePath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView scalesPageToFit];
//    [self.webView loadRequest:request];
//    self.webView.scrollView.alwaysBounceVertical = false;
//    self.webView.scrollView.alwaysBounceHorizontal = false;
//    self.webView.scrollView.bounces = false;
//    self.webView.hidden = true;
    
    
    if ([self.view viewWithTag:400] == nil)
       {
//           self.navigationView.backgroundColor = [UIColor redColor];
//
//           self.wkWebView.backgroundColor = [UIColor greenColor];
           
           CGRect webViewFrame = CGRectMake(self.view.frame.origin.x,self.navigationView.frame.origin.y+self.navigationView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-190);
           self.wkWebView = [[WKWebView alloc] initWithFrame:webViewFrame];
           self.wkWebView.tag = 400;
           NSString *filePath=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TCsFinal.docx"];
           NSURLRequest *loadDataRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
           self.wkWebView.navigationDelegate = self;
           [self.wkWebView loadRequest:loadDataRequest];

           [self.wkWebView setUserInteractionEnabled:true];
           [self.view addSubview:self.wkWebView];


       }
       
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    double h = self.wkWebView.scrollView.contentSize.height;
//    double hh = webView.frame.size.height;
//
//    CGPoint point = CGPointMake(0, self.wkWebView.scrollView.contentSize.height -  webView.frame.size.height);
//
//    [webView.scrollView setContentOffset:point animated:true];
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
////    [self zoomToFit];
////    [webView scalesPageToFit];
//
//
//    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
//
//    float scale;
//
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//       scale = 70000/webView.scrollView.frame.size.width;
//    }
//    else
//    {
//       scale = 20000/webView.scrollView.frame.size.width;
//    }
//
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", scale];
//    [webView stringByEvaluatingJavaScriptFromString:jsString];
//
//    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
//
//    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %ld);", (long)height];
//    [webView stringByEvaluatingJavaScriptFromString:javascript];
//
//    if (!isScrollViewLoadedOnce)
//    {
//        [hud removeFromSuperview];
////        [hud hideAnimated:true];
//        NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(67, %ld);", (long)height];
//        [webView stringByEvaluatingJavaScriptFromString:javascript];
//        isScrollViewLoadedOnce = true;
//    }
//    else
//    {
//        self.webView.hidden = false;
//    }
//
//
////    [webView.scrollView setContentOffset:CGPointMake(100, webView.scrollView.contentSize.height)];
//
//
//}
//
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.x < 67)
//        scrollView.contentOffset = CGPointMake(67, scrollView.contentOffset.y);
//}
//- (void)zoomToFit
//{
//    if ([self.webView respondsToSelector:@selector(scrollView)])
//    {
//        UIScrollView *scrollView = [self.webView scrollView];
//
//        float zoom = self.webView.bounds.size.width / scrollView.contentSize.width;
//        scrollView.minimumZoomScale = zoom;
//        [scrollView setZoomScale:zoom animated:YES];
//    }
//}



- (IBAction)checkBoxButtonClicked:(id)sender
{
    if (checkBoxSelected)
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"CheckBoxUnSelected"];
        
        checkBoxSelected = false;
    }
    else
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"CheckBoxSelected"];
        
        checkBoxSelected = true;
    }
}
- (IBAction)tcSubmitButtonClicked:(id)sender
{
    if (checkBoxSelected == true)
    {
        if ([AppPreferences sharedAppPreferences].isReachable)
        {
            NSString*     macId=[Keychain getStringForKey:@"udid"];

//            NSString* macId = [[NSUserDefaults standardUserDefaults] valueForKey:@"MacId"];

            NSString* dateAndTime = [[APIManager sharedManager] getDateAndTimeString];
            
            hud.minSize = CGSizeMake(150.f, 100.f);
            hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = @"Submitting Response...";
            hud.detailsLabel.text = @"Please wait";
            
            [[APIManager sharedManager] acceptTandC:macId dateAndTIme:dateAndTime acceptFlag:@"1"];
        }
        else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please check your internet connection and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
        
    }
    else
    {
         [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:nil withMessage:@"Please accept Terms and Conditions and try again." withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        
    }
}
@end
