//
//  Request.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Request : NSObject {
    NSString *name;
    NSString *group;
    NSString *body;
    BOOL followRedirects;
    NSString *method;
    NSString *rawRequest;
    NSString *response;
    NSString *url;
    NSMutableDictionary *headers;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSString *body;
@property (assign) BOOL followRedirects;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSString *rawRequest;
@property (nonatomic, retain) NSString *response;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableDictionary *headers;

-(id)init;
-(NSString *)toCurl;
-(NSString *)toEmail;

@end
