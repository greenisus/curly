//
//  MMHTTPMethodsViewController.m
//  Curly
//
//  Created by Mike Mayo on 10/8/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "MMHTTPMethodsViewController.h"

@implementation MMHTTPMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // only allow the user to delete custom HTTP methods
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [[object valueForKey:@"userCreated"] boolValue];
    
}

- (NSFetchRequest *)fetchRequestForFetchedResultsController {
    
    return [self fetchRequestForEntityName:@"MMHTTPMethod" sortedByKey:@"name" ascending:YES];
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"name"] description];
    
}

@end
