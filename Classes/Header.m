//
//  Header.m
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import "Header.h"


@implementation Header

@synthesize name, value;

-(void)dealloc {
    [name release];
    [value release];
    [super dealloc];
}

@end
