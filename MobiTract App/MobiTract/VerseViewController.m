//
//  VerseViewController.m
//  MobiTract
//
//  Created by William Saults on 3/7/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import "VerseViewController.h"

@implementation VerseViewController

@synthesize verseOutlet, scriptureOutlet, stepper, verseArray, scriptureArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Evangelical Scriptures";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Verse" ofType:@"plist"];
    verseArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    path = [[NSBundle mainBundle] pathForResource:@"Scripture" ofType:@"plist"];
    scriptureArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    // Get a random number to select a tract from the array with
    verseIndex = 0;
    verseOutlet.text = [verseArray objectAtIndex:verseIndex];
    scriptureOutlet.text = [scriptureArray objectAtIndex:verseIndex];
    
    stepper = [[UIStepper alloc] init];
    stepper.maximumValue = (double)[verseArray count]-1;
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    double stepperValue = [sender value];
    
    verseOutlet.text = [verseArray objectAtIndex:(int)stepperValue];
    scriptureOutlet.text = [scriptureArray objectAtIndex:(int)stepperValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
