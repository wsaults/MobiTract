//
//  InAppPurchaseObserver.m
//  BibleTractApp
//
//  Created by William Saults on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseObserver.h"
#import "InfoViewController.h"

@implementation InAppPurchaseObserver 

// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) { 
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                // Item is still in the process of being purchased. 
                break;
            case SKPaymentTransactionStatePurchased: 
                // Item was successfully purchased! 
                // --- UNLOCK FEATURE OR DOWNLOAD CONTENT HERE --- 
                [self saveToUserDefaults:@"userMadeDonation"];
                
                // The purchased item ID is accessible via
                // transaction.payment.productIdentifier
                
                if ([transaction.payment.productIdentifier isEqualToString:@"com.utvca.mobitract.gift"])
                {
                    // save the transaction receipt to disk
                    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"DonateTransactionReceipt" ];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDonatePurchased" ];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                [self finishTransaction:transaction wasSuccessful:YES];
                break;
            case SKPaymentTransactionStateRestored:
                // Verified that user has already paid for this item.
                // Ideal for restoring item across all devices of this customer.
                // --- UNLOCK FEATURE OR DOWNLOAD CONTENT HERE ---
                
                [self saveToUserDefaults:@"userMadeDonation"];
                // The purchased item ID is accessible via
                // transaction.payment.productIdentifier
                
                // save the transaction receipt to disk
                [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"com.utvca.mobitract.gift"];
                
                // enable the features
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isDonatePurchased" ];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // After customer has restored purchased content on this device, 
                // remove the finished transaction from the payment queue. 
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                // Purchase was either cancelled by user or an error occurred.
                if (transaction.error.code != SKErrorPaymentCancelled) { 
                    // A transaction error occurred, so notify user.
                }
                // Finished transactions should be removed from the payment queue. 
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            break; 
        }
    } 
}


// removes the transaction from the queue and posts a notification with the transaction result
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // After customer has successfully received purchased content, 
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        //NSLog(@"The transaction was a success!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!" 
                                                        message:@"We greatly appreciate your generous gift!" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

- (void)saveToUserDefaults:(NSString*)myString
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setObject:myString forKey:@"Prefs"];
		[standardUserDefaults synchronize];
	}
}

+ (NSString*)retrieveFromUserDefaults
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:@"Prefs"];
	
	return val;
}

@end
