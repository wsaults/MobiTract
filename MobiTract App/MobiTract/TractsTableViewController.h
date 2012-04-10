//
//  TractsTableViewController.h
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerseViewController.h"

@interface TractsTableViewController : UITableViewController {
    NSMutableArray *tracts;
    NSMutableArray *devotionals;
    NSMutableArray *listOfTracts;
}

@property (strong, nonatomic) NSMutableArray *tracts;
@property (strong, nonatomic) NSMutableArray *devotionals;
@property (strong, nonatomic) NSMutableArray *listOfTracts;

@end
