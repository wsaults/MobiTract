//
//  Connectivity.m
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Connectivity.h"

@implementation Connectivity

- (BOOL)isReachable {
    // Check for internect connectivity
    Reachability* reachability = [Reachability reachabilityWithHostname:@"mobitract.utvca.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable)
    {
        // The internet is NOT reachable
        return NO;
    }
    else
    {
        // The internet is reachable
        return YES;   
    }
}

- (void)displayAlert {
    // Display Error message: internet connection unreachable
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:" 
                                                    message:@"Connection Required"
                                                   delegate:self 
                                          cancelButtonTitle:@"Okay" 
                                          otherButtonTitles:nil];
    [alert show];
}


@end
