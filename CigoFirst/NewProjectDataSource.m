//
//  NewProjectDataSource.m
//  CigoFirst
//
//  Created by zjugis on 12-10-19.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import "NewProjectDataSource.h"
#import "Project.h" 
#import <IBAForms/IBAForms.h>
#import "User.h"

@implementation NewProjectDataSource

- (id)initWithModel:(id)model
{
    if (self=[super initWithModel:model]) {
        IBAFormSection *baseSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"project_new_header", nil) footerTitle:nil];
        
        IBAFormFieldStyle *fieldStyle = [[IBAFormFieldStyle alloc] init];
        fieldStyle.labelTextColor = [UIColor darkGrayColor];
        fieldStyle.labelFont = [UIFont systemFontOfSize: 17];
        fieldStyle.labelTextAlignment = UITextAlignmentLeft;
        fieldStyle.valueTextAlignment = UITextAlignmentRight;
        fieldStyle.valueTextColor = [UIColor blackColor];
        fieldStyle.activeColor = [UIColor colorWithRed:0.934 green:0.791 blue:0.905 alpha:1.000];
       
        baseSection.formFieldStyle = fieldStyle;
        [baseSection addFormField:[[IBATextFormField alloc] initWithKeyPath:@"name" title: NSLocalizedString(@"project_name", nil)]];
        
        NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
		[dateTimeFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateTimeFormatter setTimeStyle:NSDateFormatterNoStyle];
		[dateTimeFormatter setDateFormat:@"EEE d MMM  h:mm a"];
        [baseSection addFormField:[[IBADateFormField alloc] initWithKeyPath:@"limitTime"
                                                      title:NSLocalizedString(@"project_limit_time", nil)
                                               defaultValue:[NSDate date]
                                                       type:IBADateFormFieldTypeDateTime
                                              dateFormatter:dateTimeFormatter]];
        
        [baseSection addFormField:[[IBABooleanFormField alloc] initWithKeyPath:@"isFinished" title:NSLocalizedString(@"project_notice", nil) type:IBABooleanFormFieldTypeSwitch]];
        
        IBAFormSection *usersSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"project_new_users_header", nil) footerTitle:nil];
        
        NSArray *users = [User findAll];
        NSMutableArray *usersName = [NSMutableArray arrayWithCapacity:[users count]];
        for (User* user in users) {
            [usersName addObject: user.name];
        }
             
        NSArray *userListOptions = [IBAPickListFormOption pickListOptionsForStrings:usersName];
        
        IBAPickListFormOptionsStringTransformer *transformer = [[IBAPickListFormOptionsStringTransformer alloc] initWithPickListOptions:userListOptions];
		[usersSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"users"
                                                                           title:NSLocalizedString(@"project_new_users", nil)
                                                                valueTransformer:transformer
                                                                   selectionMode:IBAPickListSelectionModeMultiple
                                                                         options:userListOptions]];
        
    }
    return self;
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath
{
    if (![keyPath isEqualToString:@"users"]) {
        [super setModelValue:value forKeyPath:keyPath];
    }
}

@end
