//
//  Utility.m
//  CigoFirst
//
//  Created by zjugis on 12-10-9.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "Utility.h"
#import "MBProgressHUD.h"

static MBProgressHUD *HUD;
static NSTimer *timer;

@interface Utility()
+ (void)removeHUDOnTimeOut;
@end

@implementation Utility

+ (void)showHUD:(NSString *)msg{
	HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	[[UIApplication sharedApplication].keyWindow addSubview:HUD];
	HUD.labelText = msg;
	[HUD show:YES];
}

+ (void)removeHUD{
	[HUD hide:YES];
	[HUD removeFromSuperViewOnHide];
	[HUD release];
}

+ (void)removeHUDOnTimeOut{
	[HUD hide:YES];
	[HUD removeFromSuperViewOnHide];
	[HUD release];
    [timer invalidate];
    [timer release];
    timer  = nil;
}

+ (void) showHUD:(NSString *)msg withTime:(NSUInteger)duration {
    if (timer.isValid) {
        [Utility removeHUDOnTimeOut];
    }
    [Utility showHUD: msg];
    timer = [NSTimer scheduledTimerWithTimeInterval: duration
                                             target: [Utility class]
                                           selector: @selector(removeHUDOnTimeOut)
                                           userInfo: nil
                                            repeats: NO] ;
    [timer fire];
}


@end
