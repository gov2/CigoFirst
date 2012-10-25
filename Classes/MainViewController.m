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
            name = [NSString stringWithFormat:@"%@%@", firstName, lastName];
            
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
                                                   message:[NSString stringWithFormat:NSLocalizedString(@"", nil), numAdded]
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
        _projects = [Project findAll];
    }
    return _projects.count + 1;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        [self performSegueWithIdentifier:@"AddProjectView" sender: self];
    }
    else{
        selectedIndex_ = index - 1;
        [self performSegueWithIdentifier:@"showProjectDetailView" sender: self];
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    static UIImage *imageNew = nil, *imageNomal = nil;
    if (!imageNew) {
        imageNew = [UIImage imageNamed:@"add.png"];
    }
    if (!imageNomal) {
        imageNomal = [UIImage imageNamed:@"page.png"];
    }
    //create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[UIImageView alloc] initWithImage:imageNomal];
		label = [[UILabel alloc] initWithFrame:view.bounds];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [label.font fontWithSize:25];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
    UIImageView *imageView = (UIImageView *)view;
    if (index == 0) {
        [imageView setImage: imageNew];
    }
    else{
        [imageView setImage: imageNomal];
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

- (IBAction)newProjectPressed:(id)sender {
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
    formNavigationController.modalPresentationStyle = UIModalPresentationPageSheet;
    [rootViewController presentModalViewController:formNavigationController animated:YES];
}

- (void)createNewProjectForm {
    if ([newProjectViewController_ formDataSource]) {
        Project *project = [newProjectViewController_ formDataSource].model;
        if (project && [project.name length] > 0) {
            [[NSManagedObjectContext MR_defaultContext]MR_save];
        }
    }
	[[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissModalViewControllerAnimated:YES];
}

- (void)dismissNewProjectForm {
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissModalViewControllerAnimated:YES];
}
@end
