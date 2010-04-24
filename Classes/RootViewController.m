//
//  RootViewController.m
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Request.h"

/*
 This template does not ensure user interface consistency during editing operations in the table view. You must implement appropriate methods to provide the user experience you require.
 */

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end



@implementation RootViewController

@synthesize detailViewController, fetchedResultsController, managedObjectContext;
@synthesize selectedRequest, managedRequest;

#pragma mark -
#pragma mark Header Utilities

-(NSMutableDictionary *)headerDictionary {
    NSData *data = [[NSMutableData alloc] initWithData:[self.managedRequest valueForKey:@"headers"]];    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableDictionary *myDictionary = [[unarchiver decodeObjectForKey:@"Some Key Value"] retain];
    
    NSArray *keys = [myDictionary allKeys];
    for (int i = 0; i < [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSLog(@"dictionary - %@: %@", key, [myDictionary objectForKey:key]);
    }
    
    if (myDictionary == nil) {
        myDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [unarchiver finishDecoding];
    [unarchiver release];
    [data release];
    return myDictionary;
}

-(NSData *)headerData {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.selectedRequest.headers forKey:@"Some Key Value"];
    [archiver finishEncoding];
    [archiver release];
    return data;
}

- (Request *)requestFromObject:(NSManagedObject *)object {
    if (object == nil) {
        return nil;
    } else {
        Request *request = [[Request alloc] init];
        request.name = [object valueForKey:@"request_name"];
        NSLog(@"Request name: %@", request.name);
        request.body = [object valueForKey:@"body"];
        request.followRedirects = [((NSNumber *)[object valueForKey:@"follow_redirects"]) boolValue];
        request.group = [object valueForKey:@"group"];
        
        request.method = [object valueForKey:@"method"];
        request.rawRequest = [object valueForKey:@"raw_request"];
        request.response = [object valueForKey:@"response"];
        request.url = [object valueForKey:@"url"];
        request.headers = [self headerDictionary];
        return request;
    }
}

/*
 
 Don't both with JSON for this. There's a much easier way - just archive it.
 
 Code:
 NSMutableData *data = [[NSMutableData alloc] init];
 NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
 [archiver encodeObject:yourDictionary forKey:@"Some Key Value"];
 [archiver finishEncoding];
 [archiver release];
 
 // Here, data holds the serialized version of your dictionary
 // do what you need to do with it before you:
 [data release];
 You can do this with any class that conforms to NSCoding, and all the collection classes do. you can then reverse the process
 
 Code:
 NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
 NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
 NSDictionary *myDictionary = [[unarchiver decodeObjectForKey:@"Some Key Value"] retain];
 [unarchiver finishDecoding];
 [unarchiver release];
 [data release];
 Hope that helps.
 
 */


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"There was an error accessing your local request data.  Please quit the application by pressing the home button." 
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.    
    return YES;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
    cell.textLabel.text = [[managedObject valueForKey:@"request_name"] description];
    if ([cell.textLabel.text isEqualToString:@""]) {
        cell.textLabel.text = @"Untitled";
    }
    
    NSString *url = [[managedObject valueForKey:@"url"] description];
    if (url == nil) {
        url = @"";
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [[managedObject valueForKey:@"method"] description], url];
        
}


#pragma mark -
#pragma mark Add a new request

- (void)insertNewRequest:(id)sender {
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }    
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    NSLog(@"Entity name: %@", [entity name]);
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:@"" forKey:@"request_name"];
    [newManagedObject setValue:[NSNumber numberWithBool:NO] forKey:@"follow_redirects"];
    [newManagedObject setValue:@"GET" forKey:@"method"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"There was an error accessing your local request data.  Please quit the application by pressing the home button." 
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        
    } else {
        NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:newManagedObject];
        [self.tableView selectRowAtIndexPath:insertionPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        detailViewController.detailItem = newManagedObject;

        // select it fully
        // Set the detail item in the detail view controller.
        NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:insertionPath];
        detailViewController.detailItem = selectedObject;
        managedRequest = selectedObject;
        selectedRequest = [self requestFromObject:selectedObject];
        detailViewController.request = selectedRequest;
        [detailViewController.tableView reloadData];
        
    }    
}

- (void)saveSelectedRequest {
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSError *error = nil;
	
    [self.managedRequest setValue:self.selectedRequest.name forKey:@"request_name"];
    [self.managedRequest setValue:self.selectedRequest.body forKey:@"body"];
    [self.managedRequest setValue:[NSNumber numberWithBool:self.selectedRequest.followRedirects] forKey:@"follow_redirects"];
    [self.managedRequest setValue:self.selectedRequest.group forKey:@"group"];
    
    [self.managedRequest setValue:[self headerData] forKey:@"headers"];
    
    [self.managedRequest setValue:self.selectedRequest.method forKey:@"method"];
    [self.managedRequest setValue:self.selectedRequest.rawRequest forKey:@"raw_request"];
    [self.managedRequest setValue:self.selectedRequest.response forKey:@"response"];
    [self.managedRequest setValue:self.selectedRequest.url forKey:@"url"];
    
    //[self.note setValue:[NSDate date] forKey:@"modified"];
	
    if (![context save:&error]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                            message:@"There was an error accessing your local request data.  Please quit the application by pressing the home button." 
                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
    } else {
        
        self.selectedRequest.name = [self.managedRequest valueForKey:@"request_name"];
        self.selectedRequest.body = [self.managedRequest valueForKey:@"body"];
        self.selectedRequest.followRedirects = [((NSNumber *)[self.managedRequest valueForKey:@"follow_redirects"]) boolValue];
        self.selectedRequest.group = [self.managedRequest valueForKey:@"group"];
        
        self.selectedRequest.headers = [self headerDictionary];
        
        
        
        self.selectedRequest.method = [self.managedRequest valueForKey:@"method"];
        self.selectedRequest.rawRequest = [self.managedRequest valueForKey:@"raw_request"];
        self.selectedRequest.response = [self.managedRequest valueForKey:@"response"];
        self.selectedRequest.url = [self.managedRequest valueForKey:@"url"];
	}
    
    // hides keyboard
    //[self.detailViewController.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    if ([sectionInfo numberOfObjects] > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NSManagedObject *objectToDelete = [fetchedResultsController objectAtIndexPath:indexPath];
        if (detailViewController.detailItem == objectToDelete) {
            detailViewController.detailItem = nil;
        }
        
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        [context deleteObject:objectToDelete];
                
        NSError *error;
        if (![context save:&error]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"There was an error accessing your local request data.  Please quit the application by pressing the home button." 
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
            NSInteger count = [sectionInfo numberOfObjects];
            
            if (indexPath.row == count) {
                indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
            }
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            NSManagedObject *selectedObject;
            if (indexPath.row == -1) {
                [self setEditing:NO];
                selectedObject = nil;
            } else {
                selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                //[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
            
            detailViewController.detailItem = selectedObject;
            managedRequest = selectedObject;
            selectedRequest = [self requestFromObject:selectedObject];
            detailViewController.request = selectedRequest;
            [detailViewController.tableView reloadData];
        }
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;
    managedRequest = selectedObject;
    selectedRequest = [self requestFromObject:selectedObject];
    detailViewController.request = selectedRequest;
    [detailViewController.tableView reloadData];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"request_name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
}    

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];

            id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
            NSInteger count = [sectionInfo numberOfObjects];

            if (count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                detailViewController.detailItem = selectedObject;
                managedRequest = selectedObject;
                selectedRequest = [self requestFromObject:selectedObject];
                detailViewController.request = selectedRequest;
                [detailViewController.tableView reloadData];
                
            } 
            
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
            NSInteger count = [sectionInfo numberOfObjects];
            
            if (count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
                detailViewController.detailItem = selectedObject;
                managedRequest = selectedObject;
                selectedRequest = [self requestFromObject:selectedObject];
                detailViewController.request = selectedRequest;
                [detailViewController.tableView reloadData];
                
            }
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)preselectRequest {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    if ([sectionInfo numberOfObjects] > 0) {
        
        if (selectedRequest == nil) {
            // select it fully
            // Set the detail item in the detail view controller.
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            detailViewController.detailItem = selectedObject;
            managedRequest = selectedObject;
            selectedRequest = [self requestFromObject:selectedObject];
            detailViewController.request = selectedRequest;
            [detailViewController.tableView reloadData];
        }
    }
}

- (void)preselectRequestForDetailView {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    if ([sectionInfo numberOfObjects] > 0) {
        
        if (selectedRequest == nil) {
            // select it fully
            // Set the detail item in the detail view controller.
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            //[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            detailViewController.detailItem = selectedObject;
            managedRequest = selectedObject;
            selectedRequest = [self requestFromObject:selectedObject];
            detailViewController.request = selectedRequest;
            [detailViewController.tableView reloadData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self preselectRequest];
    [super viewWillAppear:animated];
}

- (void)dealloc {
    
    [detailViewController release];
    [fetchedResultsController release];
    [managedObjectContext release];
    
    [selectedRequest release];
    [managedRequest release];
    
    [super dealloc];
}

@end
