//
//  TractsTableViewController.h
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TractsTableViewController : UITableViewController {
    
}

@property (strong, nonatomic) NSMutableArray *tracts;
@property (strong, nonatomic) NSMutableArray *devotionals;
@property (strong, nonatomic) NSMutableArray *listOfTracts;

@property (strong, nonatomic) NSMutableArray *tractSubtitles;
@property (strong, nonatomic) NSMutableArray *devotionalSubtitles;
@property (strong, nonatomic) NSMutableArray *listOfSubtitles;

@property (strong, nonatomic) NSMutableArray *allDocs;

-(void)downloadPDF:(UIControl *)sender;

@end
