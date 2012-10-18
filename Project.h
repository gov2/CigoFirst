//
//  Project.h
//  CigoFirst
//
//  Created by zjugis on 12-10-15.
//  Copyright (c) 2012年 cigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, User;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * isFinished;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSDate * limitTime;
@property (nonatomic, retain) NSDate * finishTime;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) NSSet *users;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
