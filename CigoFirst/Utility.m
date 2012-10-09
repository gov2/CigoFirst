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

@end
