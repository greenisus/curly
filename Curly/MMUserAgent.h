//
//  MMUserAgent.h
//  Pods
//
//  Created by Mike Mayo on 10/5/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MMRequest;

@interface MMUserAgent : NSManagedObject

@property (nonatomic, retain) NSString * agent;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * grouping;
@property (nonatomic, retain) NSNumber * userCreated;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSSet *requests;
@end

@interface MMUserAgent (CoreDataGeneratedAccessors)

- (void)addRequestsObject:(MMRequest *)value;
- (void)removeRequestsObject:(MMRequest *)value;
- (void)addRequests:(NSSet *)values;
- (void)removeRequests:(NSSet *)values;

@end
