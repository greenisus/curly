//
//  Request.m
//  HTTPClient
//
//  Created by Mike Mayo on 4/4/10.
//  Copyright 2010 Mike Mayo. All rights reserved.
//

#import "Request.h"


@implementation Request

@synthesize name, group, body, followRedirects, method, rawRequest, response, url, headers;

-(id)init {
	self = [super init];
    self.headers = [[NSMutableDictionary alloc] init];
	return self;
}

-(NSString *)toCurl {
    // curl -verbose -X <method> -H "key: value" -H "key: value" -d "body" <url>    
    NSString *headerString = @"";
    NSString *bodyString = @"";

    if (headers != nil && [headers count] > 0) {
        NSArray *keys = [headers allKeys];
        for (int i = 0; i < [keys count]; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [headers objectForKey:key];
            headerString = [headerString stringByAppendingString:[NSString stringWithFormat:@"-H \"%@: %@\" ", key, value]];
        }
    }
    
    if (body != nil && ![body isEqualToString:@""]) {
        bodyString = [NSString stringWithFormat:@"-d \"%@\"", body];
    }
    
    return [NSString stringWithFormat:@"curl -verbose -X %@ %@ %@ %@", method, headerString, bodyString, url];
}

-(NSString *)toEmail {
    NSString *email = [NSString stringWithFormat:@"Request: %@\n\n%@\n\nURL: %@\nMethod: %@\n\n", name, [self toCurl], url, method];
    
    NSString *headerString = @"";
    NSString *bodyString = @"";
    NSString *responseString = @"";
    
    if (headers != nil && [headers count] > 0) {
        headerString = @"Headers:\n";
        NSArray *keys = [headers allKeys];
        for (int i = 0; i < [keys count]; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [headers objectForKey:key];
            headerString = [headerString stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", key, value]];
        }
        headerString = [headerString stringByAppendingString:@"\n"];
    }
    
    if (body != nil && ![body isEqualToString:@""]) {
        bodyString = [NSString stringWithFormat:@"Body:\n%@\n\n", body];
    }

    if (response != nil && ![response isEqualToString:@""]) {
        responseString = [NSString stringWithFormat:@"Response:\n%@\n\n", response];
    }
    
    email = [email stringByAppendingString:headerString];
    email = [email stringByAppendingString:bodyString];
    email = [email stringByAppendingString:responseString];
    
    return email;
}

-(void)dealloc {
    [name release];
    [group release];
    [body release];
    [method release];
    [rawRequest release];
    [response release];
    [url release];
    [headers release];
    [super dealloc];
}

@end
