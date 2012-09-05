//
//  TractDetailViewController.m
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "TractDetailViewController.h"
#import "InfoViewController.h"


@implementation TractDetailViewController

@synthesize selectedTract = _selectedTract;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@", _selectedTract];
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@""];
//    NSLog(@"TractDetailViewController fileName: %@", fileName);
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory,fileName,@".pdf"];
//    NSLog(@"TractDetailViewController filePath: %@", filePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [webView setUserInteractionEnabled:YES];
        [webView setDelegate:self];
        [webView scalesPageToFit];
        [webView loadRequest:requestObj];
    } else {
        NSLog(@"The file does not exist - TDVC viewDidLoad");
    }
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:_selectedTract ofType:@"pdf"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    webView.scalesPageToFit = YES;
//    [webView loadRequest:request];
}


- (void)shareButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to share?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook",@"Tweet",@"Text Message",@"Email",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    Connectivity *connection = [[Connectivity alloc] init];
    
    // The link to share
    NSString *tractToShare = [[NSString alloc] initWithFormat:@"http://mobitract.utvca.com/tracts/%@%@", _selectedTract,@".pdf"];
    tractToShare = [tractToShare stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    tractToShare = [tractToShare stringByReplacingOccurrencesOfString:@"?" withString:@""];
    
    //NSLog(@"The tractToShare is: %@", tractToShare);
    
    if ([connection isReachable]) {
        if (buttonIndex == 0) {
            //NSLog(@"Facebook Button Pressed");
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[delegate facebook] isSessionValid]) {
                [[delegate facebook] authorize:nil];
            } else {
                SBJSON *jsonWriter = [SBJSON new];
                
                // The action links to be shown with the post in the feed
                NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"Share",@"name",@"http://facebook.com/MobiTract",@"link", nil], nil];
                NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
                // Dialog parameters
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               @"This is for you!", @"name",
                                               //@"", @"caption",
                                               @"Share Jesus' love with tracts and devotionals!", @"description",
                                               tractToShare, @"link",
                                               @"http://mobitract.utvca/images/appicon.png", @"picture",
                                               actionLinksStr, @"actions",
                                               nil];
                
                //            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [[delegate facebook] dialog:@"feed"
                                  andParams:params
                                andDelegate:nil];
            }
            } else if (buttonIndex == 1) {
            //NSLog(@"Twitter Button pressed");
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            
            // Optional: set an image, url and initial text
            [twitter addImage:[UIImage imageNamed:@"Icon@2x.png"]];
            [twitter addURL:[NSURL URLWithString:[NSString stringWithFormat:tractToShare]]];
            [twitter setInitialText:@"Share Jesus' love with tracts and devotionals! #mobitract"];
            
            // Show the controller
            [self presentModalViewController:twitter animated:YES];
            
            // Called when the tweet dialog has been closed
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
            {
                NSString *title = @"Tweet Status";
                NSString *msg; 
                
                if (result == TWTweetComposeViewControllerResultCancelled)
                    msg = @"Tweet compostion was canceled.";
                else if (result == TWTweetComposeViewControllerResultDone)
                    msg = @"Tweet composition completed.";
                
                // Show alert to see how things went...
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
                
                // Dismiss the controller
                [self dismissModalViewControllerAnimated:YES];
            };
                
        } else if (buttonIndex == 2) {
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            
            if (messageClass != nil) { 			
                // Check whether the current device is configured for sending SMS messages
                if ([messageClass canSendText]) {
                    
                    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
                    if([MFMessageComposeViewController canSendText])
                    {
                        NSString *messageWithTract = [[NSString alloc] initWithFormat:@"Share Jesus' love with tracts and devotionals! %@", tractToShare];
                        controller.body = messageWithTract;
                        controller.messageComposeDelegate = self;
                        [self presentModalViewController:controller animated:YES];
                    }
                    
                    //[self displaySMSComposerSheet];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Text messaging is not supported on this device." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }
            }
            
        } else if (buttonIndex == 3) {
            //NSLog(@"Email Button pressed");
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            NSArray *recipients = [NSArray arrayWithObject:@"sample@example.com"];
            [controller setToRecipients:recipients];
            [controller setSubject:@"Share with MobiTract - iOS app"];
            
            NSString *emailShare = [[NSString alloc] 
                                    initWithFormat:@"Share Jesus' love with tracts and devotionals!. <br />%@ <br /><br /><a href='http://mobitract.utvca.com'>Learn more about MobiTract.</a>", tractToShare];
            [controller setMessageBody:emailShare isHTML:YES]; 
            if (controller) 
            {
                [self presentModalViewController:controller animated:YES];
            }
        } else {
            //NSLog(@"Cancel Button pressed");
        }
    } else {
        // No internet connection available.
        // Display the alert instead of responding to the modal buttons
        [connection displayAlert];
    }
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

// Displays an SMS composition interface inside the application. 
-(void)displaySMSComposerSheet 
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	
	[self presentModalViewController:picker animated:YES];
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
			break;
		case MessageComposeResultFailed:
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)showInfoView:(id)sender 
{
    // Load the InfoView
    InfoViewController *ivc = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    // Set the title for the InfoView
    ivc.title = @"Information";
}

- (void)viewDidUnload
{
    webView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
@end
