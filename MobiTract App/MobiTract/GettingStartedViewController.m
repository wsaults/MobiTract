//
//  GettingStartedViewController.m
//  MobiTract
//
//  Created by Will Saults on 9/6/12.
//  Copyright (c) 2012 Fossil. All rights reserved.
//

#import "GettingStartedViewController.h"

@interface GettingStartedViewController ()

@end

@implementation GettingStartedViewController

@synthesize contentView, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Getting Started";
    
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = contentView.frame.size;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
