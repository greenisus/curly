//
//  NSString+MMExtras.m
//  Curly
//
//  Created by Mike Mayo on 11/20/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "NSString+MMExtras.h"

@implementation NSString (MMExtras)

- (BOOL)hasValue {
    
    NSString *trimmedSelf = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimmedSelf && ![trimmedSelf isEqualToString:@""];
    
}

@end
