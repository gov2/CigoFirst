//
//  UserGuideViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-26.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserGuideDelegate;
@interface UserGuideViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, assign) id<UserGuideDelegate> delegate;
@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, readonly) NSArray *imageArray;
@end


@protocol UserGuideDelegate <NSObject>

@required
- (NSArray *)userGuideImageArray:(UserGuideViewController *)view;

@optional
- (void)userGuideButtonPressed:(UserGuideViewController *)view;
- (CGRect)userGuideButtonFrame:(UserGuideViewController *)view;
- (UIImage *)userGuideButtonImage:(UserGuideViewController *)view;
@end