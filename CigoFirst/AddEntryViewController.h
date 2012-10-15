//
//  AddEntryViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-14.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  CalculatorDelegate;

@interface AddEntryViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, CalculatorDelegate>

@end
