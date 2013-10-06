//
//  MMResponse.h
//  Curly
//
//  Created by Mike Mayo on 10/3/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MMResponse : NSManagedObject

@property (nonatomic, retain) NSData * body;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * headers;
@property (nonatomic, retain) NSNumber * responseTime;
@property (nonatomic, retain) NSNumber * statusCode;
@property (nonatomic, retain) NSManagedObject *request;

@end
