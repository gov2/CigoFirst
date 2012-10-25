//
//  AddEntryViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-14.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CalculatorDelegate, AddEntryDelegate;

@interface AddEntryViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, CalculatorDelegate>
@property (nonatomic, weak) id<AddEntryDelegate> delegate;
@end

@protocol AddEntryDelegate <NSObject>
@optional
- (void) entryAddFinished:(AddEntryViewController *)addEntryViewController;
- (void) entryAddCanceled:(AddEntryViewController *)addEntryViewController;
@end