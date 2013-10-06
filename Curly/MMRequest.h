//
//  MMRequest.h
//  Curly
//
//  Created by Mike Mayo on 10/3/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MMHTTPMethod, MMRequestHeader, MMResponse;

@interface MMRequest : NSManagedObject

@property (nonatomic, retain) NSNumber * followRedirects;
@property (nonatomic, retain) NSNumber * validateSSL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSOrderedSet *responses;
@property (nonatomic, retain) NSManagedObject *userAgent;
@property (nonatomic, retain) NSSet *headers;
@property (nonatomic, retain) MMHTTPMethod *method;
@property (nonatomic, retain) NSManagedObject *script;
@end

@interface MMRequest (CoreDataGeneratedAccessors)

- (void)insertObject:(MMResponse *)value inResponsesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromResponsesAtIndex:(NSUInteger)idx;
- (void)insertResponses:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeResponsesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInResponsesAtIndex:(NSUInteger)idx withObject:(MMResponse *)value;
- (void)replaceResponsesAtIndexes:(NSIndexSet *)indexes withResponses:(NSArray *)values;
- (void)addResponsesObject:(MMResponse *)value;
- (void)removeResponsesObject:(MMResponse *)value;
- (void)addResponses:(NSOrderedSet *)values;
- (void)removeResponses:(NSOrderedSet *)values;
- (void)addHeadersObject:(MMRequestHeader *)value;
- (void)removeHeadersObject:(MMRequestHeader *)value;
- (void)addHeaders:(NSSet *)values;
- (void)removeHeaders:(NSSet *)values;

@end
