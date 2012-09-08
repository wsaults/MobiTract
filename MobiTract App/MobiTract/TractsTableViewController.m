//
//  TractsTableViewController.m
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import "TractsTableViewController.h"
#import "TractDetailViewController.h"
#import "Reachability.h"

@implementation TractsTableViewController

@synthesize tracts, devotionals, listOfTracts, tractSubtitles, devotionalSubtitles, listOfSubtitles ,allDocs, backgroundUpdateTask;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /** Tracts */
    listOfTracts = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TractArray" ofType:@"plist"];
    NSString *pathForDevotionals = [[NSBundle mainBundle] pathForResource:@"DevotionalArray" ofType:@"plist"];
    
    NSMutableArray *tractArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSMutableArray *devotionalArray = [[NSMutableArray alloc] initWithContentsOfFile:pathForDevotionals];
    
    self.tracts = tractArray;
    self.devotionals = devotionalArray;
    self.allDocs = [[NSMutableArray alloc] initWithArray:tractArray];
    [allDocs addObjectsFromArray:devotionalArray];
    //    NSLog(@"alldocs: %@", allDocs);
    
    NSDictionary *tractsDict = [NSDictionary dictionaryWithObject:tractArray forKey:@"Content"];
    NSDictionary *devotionalDict = [NSDictionary dictionaryWithObject:devotionalArray forKey:@"Content"];
    
    [listOfTracts addObject:tractsDict];
    [listOfTracts addObject:devotionalDict];
    
    /** Subtitles */
    listOfSubtitles = [[NSMutableArray alloc] init];
    
    NSString *tractSubtitlePath = [[NSBundle mainBundle] pathForResource:@"TractSubtitleArray" ofType:@"plist"];
    NSString *devotionalsSubtitlePath = [[NSBundle mainBundle] pathForResource:@"DevotionalSubtitleArray" ofType:@"plist"];
    
    NSMutableArray *tractSubtitleArray = [[NSMutableArray alloc] initWithContentsOfFile:tractSubtitlePath];
    NSMutableArray *devotionalSubtitleArray = [[NSMutableArray alloc] initWithContentsOfFile:devotionalsSubtitlePath];
    
    self.tractSubtitles = tractSubtitleArray;
    self.devotionalSubtitles = devotionalSubtitleArray;
    
    NSDictionary *tractSubtitleDict = [NSDictionary dictionaryWithObject:tractSubtitleArray forKey:@"Content"];
    NSDictionary *devotionalSubtitleDict = [NSDictionary dictionaryWithObject:devotionalSubtitleArray forKey:@"Content"];
    
    [listOfSubtitles addObject:tractSubtitleDict];
    [listOfSubtitles addObject:devotionalSubtitleDict];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostname:@"www.mobitract.utvca.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    //    NSLog(@"list of tracts count: %i", [listOfTracts count]);
    
    //    return [listOfTracts count];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    //	if(section == 0)
    return @"Tracts";
    //	else
    //		return @"Devotionals";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Number of rows it should expect should be based on the section
	NSDictionary *dictionary = [listOfTracts objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Content"];
	return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TractCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    NSDictionary *dictionary = [listOfTracts objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"Content"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
    
    // Subtitle
    NSDictionary *subtitleDictionary = [listOfSubtitles objectAtIndex:indexPath.section];
	NSArray *subtitleArray = [subtitleDictionary objectForKey:@"Content"];
	NSString *subtitleValue = [subtitleArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellValue;
    cell.detailTextLabel.text = subtitleValue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font  = [UIFont fontWithName: @"Arial" size: 18.0 ];
    
    // Check if the file exists.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    cellValue = [cellValue stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    cellValue = [cellValue stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory,cellValue,@".pdf"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //NSLog(@"The file exists");
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        //NSLog(@"The file does not exist");
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    NSDictionary *dictionary = [listOfTracts objectAtIndex:path.section];
	NSArray *array = [dictionary objectForKey:@"Content"];
	NSString *cellValue = [array objectAtIndex:path.row];
    
    cellValue = [cellValue stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    cellValue = [cellValue stringByReplacingOccurrencesOfString:@"?" withString:@""];
    NSLog(@"cellValue: %@", cellValue);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory,cellValue,@".pdf"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"The file exists, performSegue");
        [self performSegueWithIdentifier:@"ShowTract" sender:self];
    } else {
        NSLog(@"The file does not exist - didSelectRowAtIndexPath");
        switch (netStatus)
        {
            case ReachableViaWiFi:
            {
                NSLog(@"WIFI");
                [self downloadPdfAtIndexPath:indexPath];
                break;
            }
            case ReachableViaWWAN:
            {
                NSLog(@"WWAN");
                [self downloadPdfAtIndexPath:indexPath];
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cellular Network" message:@"For better performance connect to WiFi." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                //                [alert show];
                break;
            }
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There was an error with the network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
        [tableView reloadData];
    }
}

- (void)downloadPdfAtIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self beingBackgroundUpdateTask:indexPath];
        
        NSLog(@"Downloading => %@", [allDocs objectAtIndex:indexPath.row]);
        NSString *fileName = [NSString stringWithFormat:@"%@", [allDocs objectAtIndex:indexPath.row]];
        fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@""];
        
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:
                           [NSURL URLWithString:[NSString stringWithFormat:@"http://mobitract.utvca.com/tracts/%@.pdf", fileName]]];
        
        //Store the Data locally as PDF File
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory,fileName,@".pdf"];
        
        [pdfData writeToFile:filePath atomically:YES];
        [self endBackgroundUpdateTask:indexPath];
    });
    
    //    [activityView stopAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
    if ([segue.identifier isEqualToString:@"ShowTract"]) {
        TractDetailViewController *tdvc = [segue destinationViewController];
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *dictionary = [listOfTracts objectAtIndex:path.section];
        NSArray *array = [dictionary objectForKey:@"Content"];
        NSString *cellValue = [array objectAtIndex:path.row];
        
        tdvc.title = cellValue;
        tdvc.selectedTract = cellValue;
    }
}

- (void)beingBackgroundUpdateTask:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Cell activity indicator
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.accessoryView = nil;
    cell.accessoryView = activityView;
    [activityView startAnimating];
    
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask:indexPath];
    }];
}

- (void)endBackgroundUpdateTask:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Cell activity indicator
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = nil;
    
    [self.tableView reloadData];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"Delete the downloaded file");
        NSIndexPath *path = indexPath;
        
        NSDictionary *dictionary = [listOfTracts objectAtIndex:path.section];
        NSArray *array = [dictionary objectForKey:@"Content"];
        NSString *cellValue = [array objectAtIndex:path.row];
        
        cellValue = [cellValue stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        cellValue = [cellValue stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSLog(@"cellValue: %@", cellValue);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory,cellValue,@".pdf"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSLog(@"The file exists: %@", filePath);
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"File deleted" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [av show];
            [self.tableView reloadData];
        } else {
            NSLog(@"The file does not exist: %@", filePath);
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"File no found." message:@"Unable to delete." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [av show];
            return;
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            internetActive = NO;
            netStatus = NotReachable;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            internetActive = YES;
            netStatus = ReachableViaWiFi;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            internetActive = YES;
            netStatus = ReachableViaWWAN;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            hostActive = YES;
            
            break;
        }
    }
}

@end
