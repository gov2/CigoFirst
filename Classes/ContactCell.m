//
//  ContactCell.m
//  CigoFirst
//
//  Created by zjugis on 12-10-17.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "ContactCell.h"

#pragma mark -
#pragma mark Constants
NSString const *kContactCellTextKey = @"ContactCellText";
NSString const *kContactCellImageKey = @"ContactCellImage";

#pragma mark -
#pragma mark Implementation
@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.clipsToBounds = YES;
		
		UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f) green:(44.0f/255.0f) blue:(58.0f/255.0f) alpha:1.0f];
		self.selectedBackgroundView = bgView;
		
		self.imageView.contentMode = UIViewContentModeCenter;
		
		self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		self.textLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(76.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine2.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine2];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:bottomLine];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	self.textLabel.frame = CGRectMake(50.0f, 0.0f, 200.0f, 43.0f);
	self.imageView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 43.0f);
}

@end
