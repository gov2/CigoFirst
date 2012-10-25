//
//  ProjectEntryCell.h
//  CigoFirst
//
//  Created by zjugis on 12-10-22.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EGOImageButtonDelegate;
@interface ProjectEntryCell : UITableViewCell //<EGOImageButtonDelegate>
{
    UIImageView *top_;
    UIImageView *bottom_;
    UIImageView *middle_;
}
@property (nonatomic, assign) NSArray *entries;

@end
