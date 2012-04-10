//
//  TractsTableViewController.m
//  MobiTract
//
//  Created by William Saults on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TractsTableViewController.h"
#import "TractDetailViewController.h"


@implementation TractsTableViewController

@synthesize tracts, devotionals, listOfTracts;

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
    
    
    listOfTracts = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TractArray" ofType:@"plist"];
    NSString *pathForDevotionals = [[NSBundle mainBundle] pathForResource:@"DevotionalArray" ofType:@"plist"];
    
    NSMutableArray *tractArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSMutableArray *devotionalArray = [[NSMutableArray alloc] initWithContentsOfFile:pathForDevotionals];
    
    self.tracts = tractArray;
    self.devotionals = devotionalArray;
    
    NSDictionary *tractsDict = [NSDictionary dictionaryWithObject:tractArray forKey:@"Content"];
    NSDictionary *devotionalDict = [NSDictionary dictionaryWithObject:devotionalArray forKey:@"Content"];
    
    [listOfTracts addObject:tractsDict];
    [listOfTracts addObject:devotionalDict];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    
    cell.textLabel.text = cellValue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if ([segue.identifier isEqualToString:@"ShowTract"]) {
        TractDetailViewController *tdvc = [segue destinationViewController];
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *dictionary = [listOfTracts objectAtIndex:path.section];
        NSArray *array = [dictionary objectForKey:@"Content"];
        NSString *cellValue = [array objectAtIndex:path.row];
        
        tdvc.title = cellValue;

        tdvc.selectedTract = cellValue;
        
    } else if ([segue.identifier isEqualToString:@"ShowVerseView"]) {
        UINavigationController *navController = (UINavigationController *) [segue destinationViewController];
        
        VerseViewController *vvc = (VerseViewController *)[navController topViewController];
        
        vvc.title = @"Evangelical Scriptures";
    } else {
        
    }
}

//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TractDetailViewController *tdvc = [[TractDetailViewController alloc] 
//                                                            initWithNibName:@"TractDetailViewController" bundle:nil];
//    
//    NSDictionary *dictionary = [listOfTracts objectAtIndex:indexPath.section];
//	NSArray *array = [dictionary objectForKey:@"Content"];
//	NSString *cellValue = [array objectAtIndex:indexPath.row];
//    
//    tdvc.title = cellValue;
//    tdvc.selectedTract = cellValue;
//    
//    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:tdvc animated:YES];
//}

@end
