//
//  NewProjectViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-19.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "NewProjectViewController.h"

@implementation NewProjectViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)loadView {
	[super loadView];
    
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	
	UITableView *formTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
	
	[view addSubview:formTableView];
	[self setView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

@end
