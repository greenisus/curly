//
//  HeaderViewController.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/5/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface HeaderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    IBOutlet UIView *footerView;
    UITextField *nameTextField;
    UITextField *valueTextField;
    DetailViewController *detailViewController;
    NSString *key;
    NSString *value;
    NSIndexPath *indexPath;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) DetailViewController *detailViewController;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSIndexPath *indexPath;

-(void)cancelButtonPressed:(id)sender;
-(void)saveButtonPressed:(id)sender;
-(void)deleteButtonPressed:(id)sender;

@end
