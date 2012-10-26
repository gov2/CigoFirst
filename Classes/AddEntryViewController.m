//
//  AddEntryViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-14.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "CalculatorView.h"
#import "User.h"
#import "Entry.h"

#import "AddEntryViewController.h"

@interface AddEntryViewController (){
    NSArray *_users;
    NSDictionary *_usersEntry;
    NSString *_expression;
    float _currentResult;
    int _selectedEntryIndex;
    int _selectedUserIndex;
}

@end

@implementation AddEntryViewController

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
	// Do any additional setup after loading the view.
    CalculatorView *calView = [[CalculatorView alloc] initWithFrame:CGRectMake(0, 240, 320, 200)];
    [calView setFrame:CGRectMake(0, 260, 320, 200)];
    [calView setBackgroundColor:[UIColor clearColor]];
    [calView setBackgroundColor:[ UIColor colorWithRed:36 green:37 blue:51 alpha:1]];
    calView.delegate = self;
    [self.view addSubview: calView];
}

-(void)viewWillAppear:(BOOL)animated
{
    User* user = [_users objectAtIndex:0];
    NSArray *entries = [_usersEntry objectForKey: user.objectID];
    [_pickerView selectRow: entries.count inComponent:1 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProject:(Project *)project
{
    _users = [project.users allObjects];
    NSMutableDictionary *userEntryDict = [[NSMutableDictionary alloc] initWithCapacity:[_users count]];
    for (User *user in _users) {
        NSMutableArray *userEntry = [[NSMutableArray alloc] init];
        [userEntryDict setObject:userEntry forKey:user.objectID];
    }
    for (Entry *entry in project.entries) {
        NSMutableArray *userEntry = [userEntryDict objectForKey: entry.user.objectID];
        [userEntry addObject:entry];
    }
    _usersEntry = userEntryDict;
    _project = project;
}

#pragma mark - Picker view data source
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [_project.users count];
            break;
        case 1:
            return [[_usersEntry objectForKey:[[_users objectAtIndex: _selectedUserIndex] objectID]] count] + 1;
        default:
            return 0;
            break;
    }
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

#pragma mark - Picker view delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger selectedRow = -1;
    if (component == 0) {
        User* user = [_users objectAtIndex:row];
        return user.name;
    }
    
    selectedRow = [pickerView selectedRowInComponent:component - 1];
    User* user = [_users objectAtIndex:selectedRow];
    
    NSArray *entries = [_usersEntry objectForKey: user.objectID];
    if (row == entries.count) {
        return _expression;
    }
    else {
        Entry* entry = [entries objectAtIndex:row];
        NSString *amount = [NSString stringWithFormat:@"%@", entry.amount];
        return amount;
    }
    
}
/*
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view;{
    return view;
}
*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (component == 0) {
        _selectedUserIndex = row;
        [pickerView reloadComponent:component + 1];
        User* user = [_users objectAtIndex:row];
        NSArray *entries = [_usersEntry objectForKey: user.objectID];
        [pickerView selectRow: entries.count inComponent:component + 1 animated:NO];
    }
    if (component == 1) {
        _selectedEntryIndex = row;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 145;
            break;
            
        default:
            break;
    }
    return 175;
}

#pragma mark - Calculator delegate

- (void)calculator:(CalculatorView *)calculatorView withExpression:(NSString *)expression
{
    //[self setTitle:expression];
    _expression = expression;
    [_pickerView reloadComponent:1];
}

- (void)calculator:(CalculatorView *)calculatorView withResult:(float)result
{
    _currentResult = result;
}

- (void)calculator:(CalculatorView *)calculatorView withKeyPress:(CGOCalculatorKey)key
{
    if (key == CGOCalculatorKeyReturn) {
        User *user = [_users objectAtIndex:_selectedUserIndex];
        NSMutableArray *entries = [_usersEntry objectForKey: user.objectID];
        Entry *entry = [Entry MR_createEntity];
        entry.project = _project;
        entry.user = user;
        entry.amount = [NSNumber numberWithFloat: _currentResult];
        [entries addObject:entry];
        [_project addEntriesObject:entry];
        _expression = @"";
        [_pickerView reloadComponent:1];
        [_pickerView selectRow: entries.count inComponent:1 animated:NO];
    }
}

#pragma ------

- (IBAction)donePressed:(id)sender {
    NSDate *currentDate = [NSDate date];

    for (Entry *entry in _project.entries) {
        if (!entry.createTime) {
            entry.createTime = currentDate;
        }
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
    if([self.delegate respondsToSelector:@selector(entryAddFinished:)]) {
		[self.delegate entryAddFinished:self];
	}
}

- (IBAction)cancelPressed:(id)sender {
    
    NSMutableArray *willClearEntries = [[NSMutableArray alloc] init];
    // clear entries new added
    for (Entry* entry in _project.entries) {
        if (!entry.createTime) {
            [willClearEntries addObject:entry];
        }
    }
    [_project removeEntries:[NSSet setWithArray:willClearEntries]];
    
    if([self.delegate respondsToSelector:@selector(entryAddCanceled:)]) {
		[self.delegate entryAddCanceled:self];
	}
}

- (void)viewDidUnload {
    [self setPickerView:nil];
    [super viewDidUnload];
}
@end
