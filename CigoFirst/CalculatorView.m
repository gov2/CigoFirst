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
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)buttonOperationPressed:(id)sender {
}

- (IBAction)buttonDigitPressed:(id)sender {
}

- (IBAction)buttonClearPressed:(id)sender {
    
}
@end
