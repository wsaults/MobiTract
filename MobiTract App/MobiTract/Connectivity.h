//
//  Connectivity.h
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface Connectivity : NSObject

- (BOOL)isReachable;
- (void)displayAlert;

@end
