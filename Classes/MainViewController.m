//
//  MainViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-16.
//  Copyright (c) 2012年 cigo. All rights reserved.
//
#import "AddProjectViewController.h"
#import "Project.h"
#import "MainViewController.h"
#import "NewProjectViewController.h"
#import "NewProjectDataSource.h"
#import "ProjectDetailViewController.h"
#import "Utility.h"
#import "User.h"    

#import <AddressBook/AddressBook.h>

#define ITEM_SPACING 210.0f
#define INCLUDE_PLACEHOLDERS YES

@interface MainViewController () <UIAlertViewDelegate> {
    NewProjectViewController *newProjectViewController_;
    NSInteger selectedIndex_;
}
@property (nonatomic, strong) NSArray *projects;
@end

@implementation MainViewController

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
    _coverflowControl.decelerationRate = 0.5;
    _coverflowControl.type = iCarouselTypeCoverFlow2;
    self.title = NSLocalizedString(@"main_view_title", nil);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSArray* array = [User findAll];
    if (array.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert_empty_user_title", nil)
                                                            message:NSLocalizedString(@"alert_empty_user_message", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"alert_empty_user_cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"alert_empty_user_ok", nil), nil];
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    // Import addressbook (name/phone/photo)
    [Utility showHUD: NSLocalizedString(@"import_addbook_mssage", nil)];
    NSInteger numAdded = 0;
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    NSString *name = nil;
    NSString *phone = nil;
    NSData *photo = nil;
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        ABRecordType type = ABRecordGetRecordType( ref);
        if (type == kABPersonType) {
            ABMultiValueRef contactnumber = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            for(CFIndex j = 0; j < ABMultiValueGetCount(contactnumber); j++)
            {
                CFStringRef contactnumberRef = ABMultiValueCopyValueAtIndex(contactnumber, j);
                phone = (__bridge NSString *)contactnumberRef;
                NSLog(@"%@", phone);
                if ([phone length] > 0) {
                    break;
                }
            }
            
            NSString *firstName = (__bridge NSString*)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString*)ABRecordCopyValue(ref,kABPersonLastNameProperty);
            if (firstName == nil) firstName = @"";
            if (lastName == nil) lastName = @"";
            name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
            
            photo = (__bridge NSData*)ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail);
            
            User *user= [User MR_createEntity];
            user.name = name;
            user.phone = phone;
            user.photo = photo;
            
            numAdded++;
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    [Utility removeHUD];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:[NSString stringWithFormat:NSLocalizedString(@"import_addbook_finished", nil), numAdded]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddProjectView"]) {
        AddProjectViewController *addProejctView =[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [addProejctView setDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"showProjectDetailView"]){
        Project *project = [_projects objectAtIndex:selectedIndex_];
        if (project) {
            ProjectDetailViewController *projectDetailViewController = [segue destinationViewController];
            projectDetailViewController.title = project.name;
            [projectDetailViewController setProject:project];
        }
    }
}

- (void)projectAddCanceled:(AddProjectViewController *)addProjectView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)projectAddFinished:(AddProjectViewController *)addProjectView
                  withName:(NSString *)name
                 limitTime:(NSDate *)date
              notification:(BOOL)shouldNofice
                  andUsers:(NSArray *)users
{
    if (name.length > 0) {
        Project *project = [Project MR_createEntity];
        project.name = name;
        project.limitTime = date;
        project.isFinished = NO;
        project.inNotification = [NSNumber numberWithBool:shouldNofice];
        project.createTime = [NSDate date];
        NSLog(@"Create a new Project:\name:%@\nlimitTime:%@\n", name, date);
        [[NSManagedObjectContext MR_defaultContext]MR_save];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - iCl
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (!_projects) {
        _projects = [self getSortedProjects];
    }
    return _projects.count + 1;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        [self showNewProjectForm];
        //[self performSegueWithIdentifier:@"AddProjectView" sender: self];
    }
    else{
        selectedIndex_ = index - 1;
        [self performSegueWithIdentifier:@"showProjectDetailView" sender: self];
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]];
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, 240, 90)];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [label.font fontWithSize:25];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] objectAtIndex:0];
	}
    
    if (index == 0 && view.subviews.count < 2) {
        UIImageView *mount = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"add.png"]];
        [mount setFrame: CGRectMake(20, 90, 200, 200)];
        [mount setAlpha:0];
        [view addSubview:mount];
    }
	
    //set label
    if (index == 0) {
        label.text = @"";
    }
    else{
        label.text = [[_projects objectAtIndex:index - 1] name];
    }
    
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return ITEM_SPACING;
}

-(CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionWrap) {
        return _projects.count > 3;
    }
    return value;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _coverflowControl.itemWidth);
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    // end of carouse scroll animation
    if (carousel.currentItemIndex == 0)
    {
        UIView *currentView = carousel.currentItemView;
        NSLog(@"%d", currentView.subviews.count);
        UIImageView *mount = [currentView.subviews objectAtIndex:1];
        if (mount) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [mount setAlpha: 1.0];
            [UIView commitAnimations];
        }
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    if (carousel.currentItemIndex == 0)
    {
        UIView *currentView = carousel.currentItemView;
        UIImageView *mount = [currentView.subviews objectAtIndex:1];
        if (mount) {
            [UIView beginAnimations:nil context:(__bridge void *)mount];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            [mount setAlpha: 0.0];
            [UIView commitAnimations];
        }
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if (context) {
        UIView *view = (__bridge UIView *)context;
        view.hidden = YES;
    }
}

- (IBAction)newProjectPressed:(id)sender {
    [self showNewProjectForm];
}

- (void)showNewProjectForm {
    Project *project = [ Project MR_createEntity];
    NewProjectDataSource *newProjectDataSource = [[NewProjectDataSource alloc] initWithModel:project];
    newProjectViewController_ =[[NewProjectViewController alloc] initWithNibName:nil bundle:nil formDataSource:newProjectDataSource];
    [[IBAInputManager sharedIBAInputManager] setInputNavigationToolbarEnabled:YES];
    
	UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self
                                                                                 action:@selector(createNewProjectForm)] autorelease];
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                   target:self
                                                                                   action:@selector(dismissNewProjectForm)] autorelease];
    
    newProjectViewController_.navigationItem.rightBarButtonItem = doneButton;
    newProjectViewController_.navigationItem.leftBarButtonItem = cancelButton;
    UINavigationController *formNavigationController = [[[UINavigationController alloc] initWithRootViewController:newProjectViewController_] autorelease];
    formNavigationController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    [rootViewController presentModalViewController:formNavigationController animated:YES];
}

- (void)createNewProjectForm {
    if ([newProjectViewController_ formDataSource]) {
        Project *project = [newProjectViewController_ formDataSource].model;
        if (project && [project.name length] > 0) {
            project.createTime = [NSDate date];
            NSLog(@"Create a new Project:\name:%@\nlimitTime:%@\n", project.name, project.limitTime);
            [[NSManagedObjectContext MR_defaultContext]MR_save];
        }
    }
	[[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:^{
        // Add project animation
        _projects = [self getSortedProjects];
        [_coverflowControl insertItemAtIndex:_projects.count - 1 animated:YES];
        [_coverflowControl reloadData];
        [_coverflowControl scrollToItemAtIndex:_projects.count animated:YES];
    }];
}

- (NSArray *)getSortedProjects
{
    NSArray *projects = [Project findAll];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    return [projects sortedArrayUsingDescriptors:@[descriptor]];
}

- (void)dismissNewProjectForm {
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:NULL];
}
@end
