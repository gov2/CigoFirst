//
//  ProjectEntryCell.m
//  CigoFirst
//
//  Created by zjugis on 12-10-22.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "ProjectEntryCell.h"

@implementation ProjectEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        top_ = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"prj_entry_top.png"]];
        [top_ setFrame: CGRectMake(0, 0, 320, 44)];
        [self addSubview:top_];
        middle_ = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"prj_entry_middle.png"]];
        [middle_ setFrame:CGRectMake(0, 44, 320, self.frame.size.height - 88)];
        // [self addSubview:middle_];
        bottom_ = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"prj_entry_bottom.png"]];
        [bottom_ setFrame: CGRectMake(0, 44, 320, 44)];
        [self addSubview:bottom_];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier entries:(NSArray *) entries
{
    if ((self = [self initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {
        self.entries = entries;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
