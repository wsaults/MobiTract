//
//  InfoViewController.h
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <StoreKit/StoreKit.h> 

#import "InAppPurchaseObserver.h"
#import "Reachability.h"
#import "Connectivity.h"

@interface InfoViewController : UIViewController <SKProductsRequestDelegate, MFMailComposeViewControllerDelegate> {
    
    __weak IBOutlet UIScrollView *scrollView;
    InAppPurchaseObserver *inappObserver;
    UIButton *inappButton;
    UILabel *donateText;
    SKProductsRequest *prodRequest;
}

@property (strong, nonatomic) InAppPurchaseObserver *inappObserver; 
@property (strong, nonatomic) IBOutlet UIButton *inappButton;
@property (strong, nonatomic) IBOutlet UILabel *donateText;
@property (strong, nonatomic) SKProductsRequest *prodRequest;

- (IBAction)donation:(id)sender;
- (IBAction)visitWebsiteButton:(id)sender;
- (IBAction)feedBackButton:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
