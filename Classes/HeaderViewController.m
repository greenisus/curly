//
//  HeaderViewController.m
//  HTTPClient
//
//  Created by Michael Mayo on 4/5/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import "HeaderViewController.h"
#import "TextFieldCell.h"
#import "DetailViewController.h"
#import "Request.h"
#import "RootViewController.h"


@implementation HeaderViewController

@synthesize tableView, footerView, detailViewController;
@synthesize key, value;
@synthesize indexPath;

#pragma mark -
#pragma mark View lifecycle

/**/
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = self.footerView;
}
//*/
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Header Details";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {        
        cell = [[[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
		CGRect rect = cell.textField.frame;
		rect.size.width -= 150; // to account for ipad modal width
        
		//rect.origin.x += 232; // portrait
		//rect.origin.x += 169; // landscape
        
        cell.textField.frame = rect;
        
    }
    
    //cell.textField.delegate = self;    
    
    // Configure the cell...
    if (anIndexPath.row == 0) {
        cell.textLabel.text = @"Name";
        nameTextField = cell.textField;
        nameTextField.delegate = self;
        nameTextField.returnKeyType = UIReturnKeyNext;
        if (key != nil && ![key isEqualToString:@""]) {
            nameTextField.text = key;
        }
    } else {
        cell.textLabel.text = @"Value";
        valueTextField = cell.textField;
        valueTextField.delegate = self;
        if (value != nil && ![value isEqualToString:@""]) {
            valueTextField.text = value;
        }
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Button Handlers

-(void)cancelButtonPressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
    [self.detailViewController.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
}

-(void)saveButtonPressed:(id)sender {

    if (nameTextField.text == nil || [nameTextField.text isEqualToString:@""] || valueTextField.text == nil || [valueTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a name and value for the header." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        if (key != nil && ![key isEqualToString:@""]) {
            [self.detailViewController.request.headers removeObjectForKey:key];
        }
        
        [self.detailViewController.request.headers setValue:valueTextField.text forKey:nameTextField.text];
        [self.detailViewController.rootViewController saveSelectedRequest];
        [self.detailViewController.tableView reloadData];
        [self dismissModalViewControllerAnimated:YES];
        [self.detailViewController.tableView deselectRowAtIndexPath:self.indexPath animated:YES];
    }    
}

-(void)deleteButtonPressed:(id)sender {
    if (key != nil && ![key isEqualToString:@""]) {
        [self.detailViewController.request.headers removeObjectForKey:key];
    }        
    [self.detailViewController.rootViewController saveSelectedRequest];
    [self.detailViewController.tableView reloadData];
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == nameTextField) {
        [valueTextField becomeFirstResponder];
    } else if (textField == valueTextField) {
        [self saveButtonPressed:nil];
    }
    return NO;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [tableView release];
    [footerView release];
    [detailViewController release];
    [key release];
    [value release];
    [indexPath release];
    [super dealloc];
}


@end

