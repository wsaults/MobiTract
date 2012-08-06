//
//  InAppPurchaseObserver.h
//  BibleTractApp
//
//  Created by William Saults on 2/9/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"



@interface InAppPurchaseObserver : NSObject <SKPaymentTransactionObserver> {
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)saveToUserDefaults:(NSString*)myString;
+ (NSString*)retrieveFromUserDefaults;
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful;

@end
