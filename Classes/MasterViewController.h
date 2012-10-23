//
//  MasterViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-9.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "AddContactViewController.h"


@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddContactDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
