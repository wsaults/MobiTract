//
//  TractDetailViewController.h
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "AppDelegate.h"
#import "FBConnect.h"
#import "Connectivity.h"

@interface TractDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, 
MFMessageComposeViewControllerDelegate> {
    
    __weak IBOutlet UIWebView *webView;
    NSString *selectedTract;
}

@property (strong, nonatomic) NSString *selectedTract;

- (IBAction)shareButton:(id)sender;
- (IBAction)showInfoView:(id)sender;
- (void)displaySMSComposerSheet;

@end
