//
//  MMRequestHeaderViewController.h
//  Curly
//
//  Created by Mike Mayo on 10/15/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMRequestHeaderViewControllerDelegate;

@interface MMRequestHeaderViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MMRequest *request;
@property (nonatomic, strong) MMRequestHeader *header;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) id<MMRequestHeaderViewControllerDelegate> delegate;

@end

@protocol MMRequestHeaderViewControllerDelegate

- (void)headerViewControllerSelectedHeader:(MMRequestHeader *)header;

@end
