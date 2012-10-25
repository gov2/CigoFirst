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

@interface PickListFormOptionsUserTransformer : NSValueTransformer {
    NSDictionary *userDicts_;
}

- (id)initWithPickListOptions:(NSArray *)pickListOptions;
- (id)initWithUsers:(NSArray *)users;
@property (nonatomic, copy) NSArray *pickListOptions;
@property (nonatomic, copy) NSArray *users;
@end

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
        
        NSArray *userListOptions = [User findAll];
        
        PickListFormOptionsUserTransformer *transformer = [[PickListFormOptionsUserTransformer alloc] initWithUsers:userListOptions];
		[usersSection addFormField:[[IBAPickListFormField alloc] initWithKeyPath:@"users"
                                                                           title:NSLocalizedString(@"project_new_users", nil)
                                                                valueTransformer:transformer
                                                                   selectionMode:IBAPickListSelectionModeMultiple
                                                                         options:transformer.pickListOptions]];
        
    }
    return self;
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath
{
    [super setModelValue:value forKeyPath:keyPath];
    if (![keyPath isEqualToString:@"users"]) {
       
    }
    else {
        // Project* project = self.model;
        // project.users = value;
    }
}

@end


@implementation PickListFormOptionsUserTransformer

- (id)initWithPickListOptions:(NSArray *)pickListOptions
{
    if((self = [super init]) != nil)
    {
        self.pickListOptions = pickListOptions;
    }
    return self;
}

-(id)initWithUsers:(NSArray *) users
{
    if((self = [super init]) != nil)
    {
        NSMutableArray *pickListOptions = [[NSMutableArray alloc] initWithCapacity: users.count];
        IBAPickListFormOption *option = nil;
        for (User *user in users) {
            option = [[IBAPickListFormOption alloc]initWithName:user.name iconImage:[UIImage imageWithData: user.photo ] font:nil];
            [pickListOptions addObject:option];
        }
        self.pickListOptions = pickListOptions;
        self.users = users;
    }
    return self;
}

+ (Class)transformedValueClass {
	return [NSSet class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	NSMutableSet *users = [[NSMutableSet alloc] init];
	for (IBAPickListFormOption *option in value) {
		User *user = [self userWithName:[option name]];
		if (user != nil) {
			[users addObject:user];
		}
	}
    
	return users;
}

- (id)reverseTransformedValue:(id)value {
	NSMutableSet *options = [[NSMutableSet alloc] init];
	for (User *user in value) {
        IBAPickListFormOption *option = [self optionWithName:[user name]];
        if (option != nil) {
            [options addObject:option];
        }
	}
    
	return options;
}

- (IBAPickListFormOption *)optionWithName:(NSString *)optionName {
	NSArray *filteredOptions = [self.pickListOptions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", optionName]];
	return (filteredOptions.count > 0) ? [filteredOptions lastObject] : nil;
}


-(User*) userWithName:(NSString *)name{
    NSArray *filteredUsers = [self.users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
	return (filteredUsers.count > 0) ? [filteredUsers lastObject] : nil;
}

@end
