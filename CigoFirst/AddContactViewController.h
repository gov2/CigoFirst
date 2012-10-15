//
//  AddContactViewController.h
//  CigoFirst
//
//  Created by zjugis on 12-10-10.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddContactDelegate;

@interface AddContactViewController : UITableViewController<UINavigationControllerDelegate,
                    UIImagePickerControllerDelegate, UITextFieldDelegate >

@property (assign) id<AddContactDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *phoneInput;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;
- (IBAction)avatarChoosePressed:(id)sender;

@end


@protocol AddContactDelegate <NSObject>

- (void) contactAddFinished:(AddContactViewController *)addContactView
           withName:(NSString *)contactName
              phone:(NSString *)phoneNum
           andImage:(UIImage *)image;
- (void) contactAddCanceled:(AddContactViewController *)addContactView;
@end