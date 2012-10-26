//
//  ProjectDetailViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-22.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectEntryCell.h"
#import "Entry.h"
#import "TimeScroller.h"

#define kDynamicSection 1
#define kBannerYOffset -22

@interface ProjectDetailViewController (){
    NSDictionary *_dateEntryDictionary;
    TimeScroller *_timeScroller;
    NSArray *_dateArray;
    UIImageView *_topView;
}

@end

@implementation ProjectDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgnoise.png"]];
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    [_topView setImage: [UIImage imageNamed: @"banner.png"]];
    UIImageView *startView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 116, 320, 44)];
    [startView setImage: [UIImage imageNamed: @"prj_entry_start.png"]];
    [_topView addSubview:startView];
    [self.view addSubview:_topView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.tableView setFrame: CGRectMake(0, 160, 320, 256)];
    //[self.tableView setContentOffset: CGPointMake(0, -160) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"ShowEntryAddView" ]) {
        //
        AddEntryViewController *addEntryViewController =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        addEntryViewController.project = _project;
        [addEntryViewController setDelegate: self];
    }
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.tableView setContentOffset:CGPointMake(0, -160) animated:YES];
}

- (void)setProject:(Project *)project
{
    NSMutableDictionary *entryDict = [[NSMutableDictionary alloc]init];
    NSDate *currentDate;
    NSSet *entrySet = project.entries;
    NSSortDescriptor *createDateDescriptor = [[NSSortDescriptor alloc]initWithKey:@"createTime" ascending:NO];
    NSArray *sortedArray = [entrySet sortedArrayUsingDescriptors:@[createDateDescriptor]];
    NSMutableArray *dateEntry = [[NSMutableArray alloc]init];
    NSMutableArray *dateArray = [[NSMutableArray alloc]init];
    for (Entry *entry in sortedArray) {
        if (currentDate == nil) {
            currentDate = entry.createTime;
            [dateArray addObject:currentDate];
        }
        if ([entry.createTime isEqualToDate: currentDate]) {
            [dateEntry addObject: entry];
        }
        else {
            [entryDict setObject:dateEntry forKey:currentDate.copy];
            dateEntry = [[NSMutableArray alloc]init];
            currentDate = nil;
        }
    }
    if (currentDate != nil) {
        [entryDict setObject:dateEntry forKey:currentDate.copy];
    }
    _dateArray = dateArray;
    _dateEntryDictionary = entryDict;
    _project = project;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDynamicSection && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ShowEntryAddView" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else if (indexPath.row == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [self calculateCellHeight:indexPath.row - 1];
}

- (CGFloat)calculateCellHeight:(NSInteger)index
{
    NSArray *entries = [_dateEntryDictionary objectForKey: [_dateArray objectAtIndex:index]];
    return (entries.count + 1) * 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1 || indexPath.row == 0) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
    ProjectEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectEntryCell"];
    if(!cell)
    {
        cell = [[ProjectEntryCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"ProjectEntryCell"];
    }
    NSArray *entries = [_dateEntryDictionary objectForKey: [_dateArray objectAtIndex:indexPath.row - 1]];
    cell.entries = entries;
    [cell resizeHeight];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [super tableView:tableView viewForHeaderInSection:section];
    //    if (section == 0) {
    //        UIImageView *view = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, 320, 160)];
    //
    //        [view setImage: [UIImage imageNamed: @"banner.png"]];
    //        return view;
    //    }
    //    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != kDynamicSection) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return _dateArray.count + 1;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    // if dynamic section make all rows the same indentation level as row 0
    if (section == kDynamicSection) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidScroll];
    CGFloat y  = scrollView.contentOffset.y;
    CGFloat topHeight = CGRectGetHeight(_topView.frame);
    NSLog(@"%f", y);
    if (y <= -44) {
        [_topView setFrame:CGRectMake(0, scrollView.contentOffset.y + 44, 320, topHeight)];
    }
    else if (y > topHeight - 44 - kBannerYOffset) {
        [_topView setFrame:CGRectMake(0, scrollView.contentOffset.y + 44 - topHeight + kBannerYOffset, 320, topHeight)];
    }
    else {
        [_topView setFrame:CGRectMake(0, 0, 320, topHeight)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [_timeScroller scrollViewDidEndDecelerating];
    }
}

#pragma mark - Add Entry delegate
- (void)entryAddCanceled:(AddEntryViewController *)addEntryViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)entryAddFinished:(AddEntryViewController *)addEntryViewController
{
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Timer Scroll delegate

- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller
{
    return self.tableView;
}

- (NSDate *)dateForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        return _project.createTime;
    }
    if (indexPath.row == 0) {
        return [NSDate date];
    }
    
    return [_dateArray objectAtIndex: indexPath.row -1];
}

@end
