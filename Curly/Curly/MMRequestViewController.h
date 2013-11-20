//
//  MMRequestViewController.h
//  Curly
//
//  Created by Mike Mayo on 9/29/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRequestHeaderViewController.h"

@interface MMRequestViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MMRequestHeaderViewControllerDelegate>

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end
