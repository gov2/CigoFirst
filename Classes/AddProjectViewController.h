//
//  AddProjectViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-16.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddProjectViewDelegate;

@interface AddProjectViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *usersTableCell;
@property (weak, nonatomic) IBOutlet UISwitch *remindMeSwitcher;
@property (weak, nonatomic) IBOutlet UITextField *projectNameInput;
- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@property  (nonatomic, assign) id<AddProjectViewDelegate> delegate;
@end

@protocol AddProjectViewDelegate <NSObject>

- (void) projectAddFinished:(AddProjectViewController *) addProjectView withName: (NSString*) name limitTime:(NSDate*) date notification:(BOOL) shouldNofice andUsers:(NSArray*) users;
- (void) projectAddCanceled:(AddProjectViewController *) addProjectView;
@end