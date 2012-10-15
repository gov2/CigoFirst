//
//  AddEntryViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-14.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "AddEntryViewController.h"
#import "CalculatorView.h"

@interface AddEntryViewController ()

@end

@implementation AddEntryViewController

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
    CalculatorView *calView = [[CalculatorView alloc] initWithFrame:CGRectMake(0, 216, 320, 200)];
    [calView setFrame:CGRectMake(0, 238, 320, 200)];
    [calView setBackgroundColor:[UIColor clearColor]];
    [calView setBackgroundColor:[ UIColor colorWithRed:36 green:37 blue:51 alpha:1]];
    calView.delegate = self;
    [self.view addSubview: calView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Picker view data source
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return component * 2 + 1;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

#pragma mark - Picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger selectedRow = -1;
    if (component > 0) {
        selectedRow = [pickerView selectedRowInComponent:component - 1];
    }
    return [NSString stringWithFormat:@"%d[%d][%d]", selectedRow, row, component];
}
/*
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view;{
    return view;
}
*/

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component;
{
    if (component < pickerView.numberOfComponents - 1) {
        [pickerView reloadComponent:component + 1];
        [pickerView selectRow:0 inComponent:component + 1 animated:YES];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 145;
            break;
            
        default:
            break;
    }
    return 175;
}

- (void)calculator:(CalculatorView *)calculatorView withExpression:(NSString *)expression
{
    [self setTitle:expression];
}

- (void)calculator:(CalculatorView *)calculatorView withResult:(float)result
{
    
}

@end
