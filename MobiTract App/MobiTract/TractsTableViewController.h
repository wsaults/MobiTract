//
//  TractsTableViewController.h
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;

@interface TractsTableViewController : UITableViewController {
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
    int netStatus;
}

@property (strong, nonatomic) NSMutableArray *tracts;
@property (strong, nonatomic) NSMutableArray *devotionals;
@property (strong, nonatomic) NSMutableArray *listOfTracts;

@property (strong, nonatomic) NSMutableArray *tractSubtitles;
@property (strong, nonatomic) NSMutableArray *devotionalSubtitles;
@property (strong, nonatomic) NSMutableArray *listOfSubtitles;

@property (strong, nonatomic) NSMutableArray *allDocs;
@property UIBackgroundTaskIdentifier backgroundUpdateTask;

- (void)downloadPdfAtIndexPath:(NSIndexPath *)indexPath;
- (void)beingBackgroundUpdateTask:(NSIndexPath *)indexPath;
- (void)endBackgroundUpdateTask:(NSIndexPath *)indexPath;
- (void)checkNetworkStatus:(NSNotification *)notice;

@end
