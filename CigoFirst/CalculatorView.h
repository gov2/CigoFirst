//
//  CalculatorView.h
//  CigoFirst
//
//  Created by zjugis on 12-10-10.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatorDelegate;
@interface CalculatorView : UIView {
    float currentNumber;
    int currentOperator;
}

@property (nonatomic) float result;
@property (nonatomic, copy) NSString* expression;
@property (assign) id<CalculatorDelegate> delegate;

- (IBAction)buttonOperationPressed:(id)sender;
- (IBAction)buttonDigitPressed:(id)sender;
- (IBAction)buttonClearPressed:(id)sender;

@end

@protocol CalculatorDelegate <NSObject>

@optional
- (void) calculator:(CalculatorView *)calculatorView withExpression:(NSString *)expression;
- (void) calculator:(CalculatorView *)calculatorView withResult:(float)result;

@end
