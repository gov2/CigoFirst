//
//  CalculatorView.m
//  CigoFirst
//
//  Created by zjugis on 12-10-10.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "CalculatorView.h"

@interface CalculatorView(){
    bool isp;
    int pcount;
}

@end

@implementation CalculatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalculatorView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        [self reset];
    }
    return self;
}

- (IBAction)buttonOperationPressed:(id)sender {
    currentNumber = (CGFloat)[self.expression floatValue];
    if (currentOperator == 0 && _expression.length > 0) {
        _result = currentNumber;
    }else{
        _result = [self calculate:_result by:currentOperator right:currentNumber];
    }
    currentOperator = [sender tag];
    _expression = @"";
    if ([self.delegate respondsToSelector:@selector(calculator:withExpression:)]) {   
        [self.delegate calculator: self
               withExpression: [[self floatToString: _result] stringByAppendingString: [self operatorFromInteger:currentOperator]]];
    }
    if ([self.delegate respondsToSelector:@selector(calculator:withResult:)]) {
        [self.delegate calculator:self withResult:_result];
    }
    if ([self.delegate respondsToSelector:@selector(calculator:withKeyPress:)]) {
        [self.delegate calculator:self withKeyPress: [sender tag] + 20];
    }
}

-(float)calculate:(float) left by:(int)operator right:(float)right
{
    float returnResult = left;
    switch (operator) {
        case 1:
            returnResult = left + right;
            break;
        case 2:
            returnResult = left - right;
            break;
        case 3:
            returnResult = left * right;
            break;
        case 4:
            if (right != 0) {
                returnResult = left / right;
            }
            break;
        default:
            break;
    }
    return returnResult;
}
- (NSString*) operatorFromInteger:(NSInteger) operator
{
    switch (operator) {
        case 1:
            return @" + ";
            break;
        case 2:
            return @" - ";
            break;
        case 3:
            return @" * ";
            break;
        case 4:
            return @" ÷ ";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *) floatToString:(float) val {
    NSString *ret = [NSString stringWithFormat:@"%.2f", val];
    int index = [ret length] - 1;
    BOOL trim = FALSE;
    while (([ret characterAtIndex:index] == '0' ||
            [ret characterAtIndex:index] == '.' ) &&
           index > 0)
    {
        index--;
        trim = TRUE;
    }
    if (trim)
        ret = [ret substringToIndex:index + 1];
    return ret;
}

- (IBAction)buttonDigitPressed:(id)sender {
    static NSCharacterSet *dotSet = nil;
    if(!dotSet) dotSet = [NSCharacterSet characterSetWithCharactersInString:@"."];
    int tag = [sender tag];
    if (tag == 10) {
        if ([self.expression rangeOfCharacterFromSet:dotSet].location != NSNotFound) {
            return;
        }
        else {
            _expression = [_expression stringByAppendingString:@"."];
        }
    }
    else {
        if ([@"0" isEqualToString:_expression]) {
            if(tag == 0) {
                return;
            }
            _expression = [NSString stringWithFormat:@"%d", tag];
        }
        else{
            _expression = [_expression stringByAppendingFormat:@"%d", tag];
        }
    }
    if ([self.delegate respondsToSelector:@selector(calculator:withExpression:)]) {
        [self.delegate calculator: self withExpression:  self.expression];
    }
    
    if ([self.delegate respondsToSelector:@selector(calculator:withResult:)]) {
        [self.delegate calculator:self withResult:_expression.floatValue];
    }
    
    if ([self.delegate respondsToSelector:@selector(calculator:withKeyPress:)]) {
        [self.delegate calculator:self withKeyPress: tag];
    }
}

- (IBAction)buttonClearPressed:(id)sender {
    int tag = [sender tag];
    switch (tag) {
        case 0:
            //backspace
            if (_expression && ![@"0" isEqualToString:_expression]) {
                if (_expression.length == 1) {
                    _expression = @"0";
                }
                else{
                    _expression = [_expression substringToIndex:[_expression length] - 1];
                }
            }
            break;
        case 1:
            // clear input
            _expression = @"0";
            break;
        case 2:
            // clear expression
            [self reset];
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(calculator:withExpression:)]) {
        [self.delegate calculator: self withExpression:  self.expression];
    }
    
    if ([self.delegate respondsToSelector:@selector(calculator:withResult:)]) {
        [self.delegate calculator:self withResult:_expression.floatValue];
    }
    
    if ([self.delegate respondsToSelector:@selector(calculator:withKeyPress:)]) {
        [self.delegate calculator:self withKeyPress: tag + 30];
    }
}

- (void) reset
{
    _expression = @"0";
    _result = 0;
    currentNumber = 0;
    currentOperator = 0;
    isp = NO;
    pcount = 0;
}
@end
