//
//  UserGuideViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-26.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_pageScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.frame))];
    _pageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pageScrollView.pagingEnabled = YES;
    _pageScrollView.delegate = self;
    
    [self.view addSubview:_pageScrollView];
    
    _imageArray = [self.delegate userGuideImageArray:self];
    NSInteger imageCount = _imageArray.count;
    int i;
    for (i = 0; i < imageCount;  i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage: [_imageArray objectAtIndex:i]];
        [imageView setFrame: CGRectMake(i * 320, 0, 320, 460)];
        [_pageScrollView addSubview:imageView];
    }
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _pageControl.frame = CGRectMake(141, 420, 38, 36);
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = imageCount;
    _pageControl.currentPage = 0;
    
    _pageScrollView.contentSize = CGSizeMake(self.view.frame.size.width * imageCount, self.view.frame.size.height);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

@end
