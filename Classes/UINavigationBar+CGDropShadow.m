//
//  UINavigationBar+CGDropShadow.m
//  CigoFirst
//
//  Created by zjugis on 12-10-22.
//  Copyright (c) 2012年 cigo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+CGDropShadow.h"

@implementation UINavigationBar (CGDropShadow)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"top_line_bg.png"];
    [image drawInRect:CGRectMake(0, 0, 320, 44)];
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}

- (void)applyDefaultStyle {
    // Add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 4);
    self.layer.shadowOpacity = 0.25;
    CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height - 6, self.layer.bounds.size.width + 20, 5);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}

@end
