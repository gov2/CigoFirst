//
//  User.h
//  CigoFirst
//
//  Created by zjugis on 12-10-10.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <IBAForms/IBAForms.h>

@interface User : NSManagedObject<IBAPickListOption>

@property (nonatomic, retain) NSNumber * inContacts;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * phone;

@end
