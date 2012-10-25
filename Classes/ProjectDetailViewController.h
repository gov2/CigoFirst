//
//  ProjectDetailViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-22.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "AddEntryViewController.h"
#import "TimeScroller.h"   

@interface ProjectDetailViewController : UITableViewController <UITableViewDelegate, UIScrollViewDelegate, AddEntryDelegate, TimeScrollerDelegate>

@property (nonatomic, assign) Project *project;

@end
