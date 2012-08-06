//
//  AppDelegate.h
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>{
    Facebook *facebook;
//    NSArray *permissions;
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Facebook *facebook;
//@property (strong, nonatomic) NSArray *permissions;


@end
