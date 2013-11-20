//
//  MMRequestHeader.h
//  Curly
//
//  Created by Mike Mayo on 10/3/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MMRequestHeader : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSManagedObject *request;

@end
