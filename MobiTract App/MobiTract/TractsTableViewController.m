//
//  TractsTableViewController.m
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import "TractsTableViewController.h"
#import "TractDetailViewController.h"

@implementation TractsTableViewController

@synthesize tracts, devotionals, listOfTracts, tractSubtitles, devotionalSubtitles, listOfSubtitles ,allDocs;
dispatch_queue_t pdfDownloadQueue;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    NSLog(@"list of tracts count: %i", [listOfTracts count]);
    return [listOfTracts count];;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Tracts";
	else
		return @"Devotionals";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Number of rows it should expect should be based on the section
	NSDictionary *dictionary = [listOfTracts objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Content"];
	return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        for(UIView *subview in [cell subviews]) {
            if([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }
    } else {
        //NSLog(@"The file does not exist");
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        downloadButton.frame = CGRectMake(215, 12, 75, 20);
        downloadButton.titleLabel.font = [UIFont fontWithName: @"Arial" size: 10.0];
        downloadButton.tag = indexPath.row;
        [downloadButton addTarget:self action:@selector(downloadPDF:) forControlEvents:UIControlEventTouchUpInside];
        [downloadButton setTitle:@"Download" forState:UIControlStateNormal];
        [cell addSubview:downloadButton];
    }
    
    return cell;
}

-(void)downloadPDF:(UIControl *)sender {
    pdfDownloadQueue = dispatch_queue_create("com.test.downloadPDF", NULL);
    
    // Cell activity indicator
    NSArray *visible = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *path = (NSIndexPath*)[visible objectAtIndex:sender.tag];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.accessoryView = nil;
    cell.accessoryView = activityView;
    [activityView startAnimating];
    
    for(UIView *subview in [cell subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
            NSLog(@"Remove button - line 221");
        } else {
            // Do nothing - not a UIButton or subclass instance
        }
    }
    
    dispatch_async(pdfDownloadQueue, ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSLog(@"Downloading => %@", [allDocs objectAtIndex:sender.tag]);
        NSString *fileName = [NSString stringWithFormat:@"%@", [allDocs objectAtIndex:sender.tag]];
        fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@""];
        
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:
                           [NSURL URLWithString:[NSString stringWithFormat:@"http://mobitract.utvca.com/tracts/%@.pdf", fileName]]];
            
        //Store the Data locally as PDF File
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", documentsDirectory,fileName,@".pdf"];
            
        [pdfData writeToFile:filePath atomically:YES];
        [self.tableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
    
//    [activityView stopAnimating];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

#pragma mark - Table view delegate
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
        [tableView reloadData];
    }
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"File no found." message:@"Unable to delte." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
