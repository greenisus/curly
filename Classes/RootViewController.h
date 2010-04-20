//
//  RootViewController.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class DetailViewController, Request;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    DetailViewController *detailViewController;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    
    Request *selectedRequest;
    NSManagedObject *managedRequest;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) Request *selectedRequest;
@property (nonatomic, retain) NSManagedObject *managedRequest;

- (void)insertNewRequest:(id)sender;
- (void)saveSelectedRequest;
- (void)preselectRequest;
- (void)preselectRequestForDetailView;

@end
