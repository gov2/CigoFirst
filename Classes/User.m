//
//  User.m
//  CigoFirst
//
//  Created by zjugis on 12-10-10.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic inContacts;
@dynamic name;
@dynamic photo;
@dynamic uid;
@dynamic phone;

-(UIImage *)iconImage
{
    return [UIImage imageWithData: self.photo];
}

- (UIFont *)font
{
    return nil;
}

@end
