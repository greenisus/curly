//
//  MMUserAgentsViewController.m
//  Curly
//
//  Created by Mike Mayo on 10/8/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "MMUserAgentsViewController.h"

@implementation MMUserAgentsViewController

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSFetchRequest *)fetchRequestForFetchedResultsController {
    
    return [self fetchRequestForEntityName:@"MMUserAgent" sortedByKey:@"name" ascending:YES];
    
}

@end
