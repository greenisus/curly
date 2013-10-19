//
//  MMFetchedResultsTableViewController.h
//  Curly
//
//  Created by Mike Mayo on 10/18/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMFetchedResultsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSFetchRequest *)fetchRequestForFetchedResultsController;
- (UITableViewCellStyle)cellStyle;

@end
