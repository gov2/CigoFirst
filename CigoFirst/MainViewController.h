//
//  MainViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-16.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol AddProjectViewDelegate;

@interface MainViewController : UIViewController <AddProjectViewDelegate, iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *coverflowControl;
@end
