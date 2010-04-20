//
//  MethodViewController.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MethodViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    DetailViewController *detailViewController;
    NSString *method;
}

@property (nonatomic, retain) DetailViewController *detailViewController;
@property (nonatomic, retain) NSString *method;

-(void)cancelButtonPressed:(id)sender;
-(void)saveButtonPressed:(id)sender;

@end
