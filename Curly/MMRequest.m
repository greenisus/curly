//
//  MMRequest.m
//  Curly
//
//  Created by Mike Mayo on 10/3/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "MMRequest.h"
#import "MMHTTPMethod.h"
#import "MMRequestHeader.h"
#import "MMResponse.h"


@implementation MMRequest

@dynamic followRedirects;
@dynamic validateSSL;
@dynamic name;
@dynamic url;
@dynamic body;
@dynamic created;
@dynamic updated;
@dynamic responses;
@dynamic userAgent;
@dynamic headers;
@dynamic method;
@dynamic script;

@end
