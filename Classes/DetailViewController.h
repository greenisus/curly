//
//  DetailViewController.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class RootViewController, Request;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    UISplitViewController *splitViewController;
    
    NSManagedObject *detailItem;
    UILabel *detailDescriptionLabel;

    RootViewController *rootViewController;
    
    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *editButton;
    IBOutlet UIBarButtonItem *optionsButton;
    IBOutlet UITableViewCell *nibLoadedCell;
    
    Request *request;

    UITextField *nameTextField;
    UITextField *groupTextField;
    UITextField *urlTextField;
    
    IBOutlet UIView *footerView;
    IBOutlet UIButton *performRequestButton;
    
    UIActionSheet *actionSheet;
    BOOL actionSheetVisible;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *optionsButton;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;

@property (nonatomic, retain) Request *request;

@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UIButton *performRequestButton;

@property (nonatomic, retain) UIActionSheet *actionSheet;

- (IBAction)insertNewObject:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)optionsButtonPressed:(id)sender;

@end
