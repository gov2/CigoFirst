//
//  AddContactViewController.m
//  CigoFirst
//
//  Created by zjugis on 12-10-10.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "AddContactViewController.h"
#import "Utility.h"

@interface AddContactViewController ()

@end

@implementation AddContactViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
        
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)cancelPressed:(id)sender {
    [self.delegate contactAddCanceled:self];
}

- (IBAction)donePressed:(id)sender {
    [self.delegate contactAddFinished:self withName:_nameInput.text phone:_phoneInput.text andImage: _avatarImage.image];
}

- (IBAction)avatarChoosePressed:(id)sender {
    UISegmentedControl *chooseControl = (UISegmentedControl *)sender;
    NSUInteger selectedIndex = chooseControl.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 1:
            [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
            break;
        default:
            break;
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if (self.avatarImage.isAnimating)
        [self.avatarImage stopAnimating];
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init] ;
        self.imagePickerController.delegate = self;
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        self.imagePickerController.sourceType = sourceType;
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            self.imagePickerController.showsCameraControls = NO;
            
            if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
            {
                // setup our custom overlay view for the camera
                //
                // ensure that our custom view's frame fits within the parent frame
                CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
                CGRect newFrame = CGRectMake(0.0,
                                             CGRectGetHeight(overlayViewFrame) -
                                             self.view.frame.size.height - 10.0,
                                             CGRectGetWidth(overlayViewFrame),
                                             self.view.frame.size.height + 10.0);
                self.view.frame = newFrame;
                [self.imagePickerController.cameraOverlayView addSubview:self.view];
            }
        }
    }
    [self presentViewController:self.imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // give the taken picture to our delegate
    [self.avatarImage setImage: image];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    //[Utility showHUD:@"选择成功！" withTime: 1.5];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameInput || textField == _phoneInput) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
