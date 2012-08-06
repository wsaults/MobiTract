//
//  InfoViewController.m
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

#define PRODUCT_ID @"com.utvca.mobitract.gift"

@synthesize inappObserver, inappButton, donateText, prodRequest = _prodRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    inappObserver = [[InAppPurchaseObserver alloc] init];
    
    if ([SKPaymentQueue canMakePayments]) {
        // Yes, In-App Purchase is enabled on this device! 
        // Proceed to fetch available In-App Purchase items.
        
        // Replace "Your IAP Product ID" with your actual In-App Purchase Product ID, 
        // fetched from either a remote server or stored locally within your app.
        _prodRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PRODUCT_ID]];
        _prodRequest.delegate = self;
        [_prodRequest start];
    } else {
        // Notify user that In-App Purchase is disabled via button text. 
        [inappButton setTitle:@"In-App Purchase is Disabled" forState:UIControlStateNormal]; 
        inappButton.enabled = NO;
    }
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)donation:(id)sender {
    //NSLog(@"Donation button pressed");
    Connectivity *connection = [[Connectivity alloc] init];
    if ([connection isReachable]) {
        // Replace "Your IAP Product ID" with your actual In-App Purchase Product ID.
        SKMutablePayment *paymentRequest = [[SKMutablePayment alloc] init];
        paymentRequest.productIdentifier = PRODUCT_ID;
        // Assign an Observer class to the SKPaymentTransactionObserver,
        // so that it can monitor the transaction status.
        [[SKPaymentQueue defaultQueue] addTransactionObserver:inappObserver];
        // Request a purchase of the selected item.
        [[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
    } else {
        [connection displayAlert];
    }

}

// StoreKit returns a response from an SKProductsRequest. 
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    // Populate the inappBuy button with the received product info. 
    SKProduct *validProduct = nil;
    int count = [response.products count];
    //NSLog(@"The count of response.products is %d", count);
    if (count>0) {
        //NSLog(@"The count was greater than zero");
        validProduct = [response.products objectAtIndex:0];
    }
    if (!validProduct) {
        [inappButton setTitle:@"No Prodcuts Available" forState:UIControlStateNormal];
        inappButton.enabled = NO;
        return;
    }
    
    //NSString *buttonText = [[NSString alloc] initWithFormat:@"%@ - Buy %@", validProduct.localizedTitle, validProduct.price];
    NSString *buttonText = [[NSString alloc] initWithFormat:@"%@ - %@",validProduct.localizedTitle, validProduct.price];
    [inappButton setTitle:buttonText forState:UIControlStateNormal]; 
    inappButton.enabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

- (IBAction)visitWebsiteButton:(id)sender {
    //NSLog(@"Visit website button pressed");
    // Is there an internet connection?
    Connectivity *connection = [[Connectivity alloc] init];
    if([connection isReachable]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mobitract.utvca.com"]];
    } else {
        [connection displayAlert];
    }
}

- (IBAction)feedBackButton:(id)sender {
    //NSLog(@"Feedback button pressed");
    // Is there an internet connection?
    Connectivity *connection = [[Connectivity alloc] init];
    if([connection isReachable]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        NSArray *recipients = [NSArray arrayWithObject:@"utvca@utvca.com"];
        [controller setToRecipients:recipients];
        [controller setSubject:@"MobiTract Feedback"];
        [controller setMessageBody:@"Hello MobiTract:" isHTML:YES]; 
        if (controller) 
        {
            [self presentModalViewController:controller animated:YES];
        }
    } else {
        [connection displayAlert];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        //NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}


@end
