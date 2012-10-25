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
#define kDynamicSection 1

@interface ProjectDetailViewController (){
    NSDictionary *dateEntryDictionary;
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
    
    //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgnoise.png"]];
    //    NSString *backgroudpath = [[NSBundle mainBundle] pathForResource:@"bgnoise" ofType:@"png"];
    //    UIImage  *backgroudImage = [UIImage imageWithContentsOfFile:backgroudpath];
    //    [self.view setBackgroundColor: [UIColor colorWithPatternImage:backgroudImage]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgnoise.png"]];
    UIImageView *view = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, 320, 160)];
    [view setImage: [UIImage imageNamed: @"banner.png"]];
    [self.view addSubview: view];
    [self.view bringSubviewToFront:view];
    //[self.tableView setBackgroundView:background];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIImageView *view = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, 320, 160)];
        
        [view setImage: [UIImage imageNamed: @"banner.png"]];
        return view;
    }
    return nil;
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
    NSSortDescriptor *createDateDescriptor = [[NSSortDescriptor alloc]initWithKey:@"createTime" ascending:YES];
    NSArray *descriptor = @[createDateDescriptor];
    NSArray *sortedArray = [entrySet sortedArrayUsingDescriptors:descriptor];
    NSMutableArray *dateEntry = [[NSMutableArray alloc]init];
    for (Entry *entry in sortedArray) {
        if (currentDate == nil) {
            currentDate = entry.createTime;
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
    dateEntryDictionary = entryDict;
    _project = project;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"addEntryViewController" ]) {
        //
        AddEntryViewController *addEntryViewController =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        addEntryViewController.delegate = self;
    }
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
        return 160;
    }
    else if (indexPath.row == 0) {
        return 44;
    }
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSLog(@"%d, %d", section, row);
    if (indexPath.section != 1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    ProjectEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectEntryCell"];
    if(!cell)
    {
        cell = [[ProjectEntryCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"ProjectEntryCell"];
    }
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != kDynamicSection) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return dateEntryDictionary.count + 1;
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

@end
