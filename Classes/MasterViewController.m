//
//  MasterViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-9.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "AddContactViewController.h"
#import "User.h"

@interface MasterViewController (){
    NSInteger selectedIndex;
    TimeScroller *_timeScroller;
    NSMutableArray *_datasource;
}

@property (nonatomic, strong) NSArray* users;
@end

@implementation MasterViewController
@synthesize users = _users;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
    [super viewDidLoad];
    selectedIndex = 0;
    //This is just junk data to be displayed.
    _datasource = [NSMutableArray new];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDate *today = [NSDate date];
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    for (int i = todayComponents.day; i >= -15; i--) {
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        dictionary[@"title"] = @"Title here";
        
        components.year = todayComponents.year;
        components.month = todayComponents.month;
        components.day = i;
        components.hour = arc4random() % 23;
        components.minute = arc4random() % 59;
        
        NSDate *date = [calendar dateFromComponents:components];
        dictionary[@"date"] = date;
        
        [_datasource addObject:dictionary];
        
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        //NSManagedObject *object = [_users objectAtIndex:indexPath.row];
        //[[segue destinationViewController] setDetailItem:object];
    }
    else if ([[segue identifier] isEqualToString: @"showAddContactView"]) {
        [[[[segue destinationViewController] viewControllers] objectAtIndex:0] setDelegate:self];
    }
}

- (NSArray*) users
{
    if (!_users) {
        _users = [User findAll];
    }
    return _users;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [[self.fetchedResultsController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //[self configureCell:cell atIndexPath:indexPath];
    User *user = (User*)[_users objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSManagedObject *object = [_users objectAtIndex:indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

#pragma mark - Add sighting delegate
- (void) contactAddFinished:(AddContactViewController *)addContactView withName:(NSString *)contactName phone:(NSString *)phoneNum andImage:(UIImage *)image {
    if (contactName.length > 0) {
        User *user = [User MR_createEntity];
        user.name = contactName;
        user.phone = phoneNum;
        [[NSManagedObjectContext MR_defaultContext]MR_save];
        _users = [User findAll];
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:NULL ];
}

- (void) contactAddCanceled:(AddContactViewController *)addContactView {
    [self dismissViewControllerAnimated:YES completion:NULL ];
}

#pragma mark - Time Controller delegate
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller
{
    return self.tableView;
}

- (NSDate *)dateForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dictionary = _datasource[indexPath.row % 15];
    NSDate *date = dictionary[@"date"];
    
    return date;
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidScroll];
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


@end
