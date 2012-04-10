//
//  AppDelegate.m
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

static NSString* kAppId = @"184071918359528";

@implementation AppDelegate

@synthesize window = _window;
@synthesize facebook;
//@synthesize permissions = _permissions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Create image for navigation background - portrait
    UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"NavigationPortraitBackground"] 
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Create image for navigation background - landscape
    UIImage *NavigationLandscapeBackground = [[UIImage imageNamed:@"NavigationLandscapeBackground"] 
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image all UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:NavigationPortraitBackground 
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:NavigationLandscapeBackground 
                                       forBarMetrics:UIBarMetricsLandscapePhone];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    // Facebook integration
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    // Check for previously saved access token information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    // Initialize user permissions
//    _permissions =  [NSArray arrayWithObjects: @"read_stream", @"offline_access",nil];
//    [facebook authorize:_permissions];
    
    // Check for a valid session and if it is not valid call the 
    // authorize method which will both log the user in and prompt the user to authorize the app
//    if (![facebook isSessionValid]) {
//        [facebook authorize:nil];
//    }
    
    return YES;
}

// Facebook Integration
// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

// Implement the fbDidLogin method from the FBSessionDelegate implementation. 
// In this method you will save the user's credentials specifically the access token and corresponding expiration date
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

- (void)fbDidNotLogin:(BOOL)cancelled {
}
- (void)fbDidLogout {
}
- (void)fbSessionInvalidated {
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
