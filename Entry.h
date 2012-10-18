//
//  Entry.h
//  CigoFirst
//
//  Created by zjugis on 12-10-15.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, User;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * eid;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) User *user;

@end
