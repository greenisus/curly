//
//  MMHTTPMethod.h
//  Curly
//
//  Created by Mike Mayo on 10/3/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MMHTTPMethod : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * userCreated;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSSet *requests;
@end

@interface MMHTTPMethod (CoreDataGeneratedAccessors)

- (void)addRequestsObject:(NSManagedObject *)value;
- (void)removeRequestsObject:(NSManagedObject *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

@end
