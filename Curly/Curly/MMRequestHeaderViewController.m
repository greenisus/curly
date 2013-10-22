//
//  MMRequestHeaderViewController.m
//  Curly
//
//  Created by Mike Mayo on 10/15/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "MMRequestHeaderViewController.h"

typedef enum {
    MMNameRow,
    MMValueRow,
    MMNumberOfHeaderRows
} MMHeaderSectionRowType;

typedef enum {
    MMHeaderSection,
    MMUsedHeadersSection,
    MMNumberOfSections
} MMHeaderSectionType;

@interface MMRequestHeaderViewController ()

@property (nonatomic, strong) UIView *nameTextFieldContainer;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UIView *valueTextFieldContainer;
@property (nonatomic, strong) UITextField *valueTextField;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MMRequestHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Header", nil);
    
    if (!self.header) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    }
    
    [self configureTextFields];
    
}

- (void)configureTextFields {
    
    self.nameTextFieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 225, 26)];
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, 225, 24)];
    self.nameTextField.delegate = self;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextField.textAlignment = NSTextAlignmentRight;
    self.nameTextField.placeholder = NSLocalizedString(@"Header Name", nil);
    self.nameTextField.text = @"";
    [self.nameTextFieldContainer addSubview:self.nameTextField];

    self.valueTextFieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 225, 26)];
    self.valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, 225, 24)];
    self.valueTextField.delegate = self;
    self.valueTextField.returnKeyType = UIReturnKeyDone;
    self.valueTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.valueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.valueTextField.textAlignment = NSTextAlignmentRight;
    self.valueTextField.placeholder = NSLocalizedString(@"Header Value", nil);
    self.valueTextField.text = @"";
    [self.valueTextFieldContainer addSubview:self.valueTextField];
    
    [self.nameTextField becomeFirstResponder];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MMNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == MMHeaderSection) {
        return MMNumberOfHeaderRows;
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
        return [sectionInfo numberOfObjects];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == MMHeaderSection) {
        return NSLocalizedString(@"Request Header", nil);
    } else if (section == MMUsedHeadersSection) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
        if ([sectionInfo numberOfObjects] > 0) {
            return NSLocalizedString(@"Recently Used Headers", nil);
        } else {
            return @"";
        }
    } else {
        return @"";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    if (!self.managedObjectContext) {
        self.managedObjectContext = [MMAppDelegate context];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MMRequestHeader" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"last_used" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

/*
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
            break;
    }
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
*/
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == MMHeaderSection) {
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == MMNameRow) {
            cell.textLabel.text = NSLocalizedString(@"Name", nil);
            cell.detailTextLabel.text = nil;
            cell.accessoryView = self.nameTextFieldContainer;
        } else if (indexPath.row == MMValueRow) {
            cell.textLabel.text = NSLocalizedString(@"Value", nil);
            cell.detailTextLabel.text = nil;
            cell.accessoryView = self.valueTextFieldContainer;
        }
        
    } else if (indexPath.section == MMUsedHeadersSection) {

        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [[object valueForKey:@"name"] description];
        cell.detailTextLabel.text = [[object valueForKey:@"value"] description];
        cell.accessoryView = nil;
        
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if ([textField isEqual:self.nameTextField]) {
        [self.valueTextField becomeFirstResponder];
    }
    
    return NO;
    
}

#pragma mark - Button Handlers

- (void)doneButtonPressed:(id)sender {
    
    NSManagedObjectContext *context = [MMAppDelegate context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MMRequestHeader" inManagedObjectContext:context];
    MMRequestHeader *header = [[MMRequestHeader alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    header.name = self.nameTextField.text;
    header.value = self.valueTextField.text;
    header.created = [NSDate date];
    
    [context insertObject:header];
    [self.request addHeadersObject:header];
    
    NSError *error = nil;
    if ([context save:&error]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error description] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil];
        [alert show];
        
    }
    
}

@end
