//
//  Header.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Header : NSObject {
    NSString *name;
    NSString *value;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;

@end
