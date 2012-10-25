//
//  AddEntryViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-14.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "CalculatorView.h"  

@protocol  CalculatorDelegate, AddEntryDelegate;

@interface AddEntryViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, CalculatorDelegate>
- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, assign) id<AddEntryDelegate> delegate;
@property (nonatomic, assign) Project *project;
@end

@protocol AddEntryDelegate <NSObject>
@optional
- (void) entryAddFinished:(AddEntryViewController *)addEntryViewController;
- (void) entryAddCanceled:(AddEntryViewController *)addEntryViewController;
@end