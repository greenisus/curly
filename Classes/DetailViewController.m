//
//  DetailViewController.m
//  HTTPClient
//
//  Created by Michael Mayo on 4/4/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "UISwitchCell.h"
#import "MethodViewController.h"
#import "TextFieldCell.h"
#import "Request.h"
#import "Header.h"
#import "ResponseViewController.h"
#import "BodyViewController.h"
#import "ASIHTTPRequest.h"
#import "HeaderViewController.h"
#import "OptionsViewController.h"
#import "UIViewController+SpinnerView.h"

#define kNameSection 0
#define kSetupSection 1
#define kHeadersSection 2
#define kBodySection 3
#define kRequestSection -4
#define kResponseSection 4

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, rootViewController;
@synthesize tableView, editButton, nibLoadedCell, optionsButton;
@synthesize request;
@synthesize footerView, performRequestButton;
@synthesize actionSheet;

#pragma mark -
#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex	== 0) {
        // email request details
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        vc.mailComposeDelegate = self;		
        [vc setSubject:[NSString stringWithFormat:@"HTTP Request: %@", request.name]];        
        [vc setMessageBody:[request toEmail] isHTML:NO];
        vc.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentModalViewController:vc animated:YES];
        [vc release];        
    } else if (buttonIndex == 1) {
        // copy curl command
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[request toCurl]];
    }
}

#pragma mark Mail Composer Delegate

// Dismisses the email composition interface when users tap Cancel or Send.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark HTTP Handlers

- (void)requestFinished:(ASIHTTPRequest *)httpRequest {
    [self hideSpinnerView];
    NSString *responseBody = [httpRequest responseString];
    NSString *response = [NSString stringWithFormat:@"%@\n", [httpRequest responseStatusMessage]];
    
    NSArray *headerKeys = [[httpRequest responseHeaders] allKeys];
    for (int i = 0; i < [headerKeys count]; i++) {
        NSString *key = [headerKeys objectAtIndex:i];
        NSString *value = [[httpRequest responseHeaders] objectForKey:key];
        response = [response stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", key, value]];
    }
    
    response = [response stringByAppendingString:[NSString stringWithFormat:@"\n%@", responseBody]];
    
    self.request.response = response;
    NSLog(@"response: %@", self.request.response);
    [self.rootViewController saveSelectedRequest];
    [self.tableView reloadData];    
}


- (void)requestFailed:(ASIHTTPRequest *)httpRequest {
    [self hideSpinnerView];
    NSError *error = [httpRequest error];    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark Button Handlers

- (IBAction)insertNewObject:(id)sender {	
	[rootViewController insertNewRequest:sender];	
}

- (IBAction)editButtonPressed:(id)sender {
    if (tableView.editing) {
        [tableView setEditing:NO animated:YES];
        editButton.style = UIBarButtonItemStyleBordered;
        editButton.title = @"Edit";
    } else {
        [tableView setEditing:YES animated:YES];
        editButton.style = UIBarButtonItemStyleDone;
        editButton.title = @"Done";
    }
    
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self showSpinnerView];
    NSURL *url = [NSURL URLWithString:self.request.url];
    ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:url];
    [httpRequest setRequestMethod:self.request.method];
    

    if (self.request.body != nil && ![self.request.body isEqualToString:@""]) {
        [httpRequest appendPostData:[self.request.body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSArray *headerKeys = [self.request.headers allKeys];
    for (int i = 0; i < [headerKeys count]; i++) {
        NSString *key = [headerKeys objectAtIndex:i];
        NSString *value = [self.request.headers objectForKey:key];
        [httpRequest addRequestHeader:key value:value];
    }
    
    NSLog(@"url string: %@", self.request.url);
    
    [httpRequest setDelegate:self];
    [httpRequest startAsynchronous];
    
}

- (IBAction)optionsButtonPressed:(id)sender {
    
    
    if (self.actionSheet.visible) {
        [self.actionSheet dismissWithClickedButtonIndex:-1 animated:NO];
    }
    
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }		
    
    [actionSheet showFromBarButtonItem:optionsButton animated:YES];
}

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(NSManagedObject *)managedObject {
    
	if (detailItem != managedObject) {
		[detailItem release];
		detailItem = [managedObject retain];
		
        // Update the view.
        [self configureView];
	}
    
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }		
}


- (void)configureView {
    // Update the user interface for the detail item.
    // detailDescriptionLabel.text = [[detailItem valueForKey:@"timeStamp"] description];
    NSLog(@"configureView");
}


#pragma mark -
#pragma mark Split view support

- (void)showMasterInPopover:(id)sender {
    if (self.actionSheet.visible) {
        [self.actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }
    [splitViewController showMasterInPopover:sender];
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Requests";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
    self.rootViewController.navigationController.navigationBar.tintColor = nil;
    
    splitViewController = barButtonItem.target;
    barButtonItem.target = self;
    barButtonItem.action = @selector(showMasterInPopover:);
    //showMasterInPopover
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
    self.rootViewController.navigationController.navigationBar.tintColor = toolbar.tintColor;
}


#pragma mark -
#pragma mark Rotation support

- (void)resizePerformRequestButton {
    CGRect frame = self.performRequestButton.frame;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        // 678
        frame.size.width = 678.0;
    } else {
        // 617
        frame.size.width = 617.0;
    }
    self.performRequestButton.frame = frame;
}

- (void)orientationDidChange:(NSNotification *)notification {
	// reload the table view to correct UILabel widths
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(resizePerformRequestButton) userInfo:nil repeats:NO];
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}

#pragma mark -
#pragma mark Text Field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == nameTextField) {
        self.request.name = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self.rootViewController saveSelectedRequest];
    } else if (textField == groupTextField) {
        self.request.group = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self.rootViewController saveSelectedRequest];
    } else if (textField == urlTextField) {
        self.request.url = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self.rootViewController saveSelectedRequest];
    }
    
    
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.request == nil) {
        self.tableView.tableFooterView = nil;
        return 1;
    } else {
        self.tableView.tableFooterView = self.footerView;
        return 5;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.request == nil) {
        return 0;
    } else {
        if (section == kNameSection) {
            return 1;
        } else if (section == kSetupSection) {
            return 2;
        } else if (section == kHeadersSection) {
            return [self.request.headers count] + 1;
        } else if (section == kBodySection) {
            return 1;
        } else if (section == kRequestSection) {
            return 1;
        } else if (section == kResponseSection) {
            return 1;
        } else {
            return 0;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.request == nil) {
        return @""; //No Requests";
    } else {        
        if (section == kNameSection) {
            return @"Name";
        } else if (section == kSetupSection) {
            return @"Request Details";
        } else if (section == kHeadersSection) {
            return @"Headers";
        } else if (section == kBodySection) {
            return @"Body";
        } else if (section == kRequestSection) {
            return @"Request";
        } else if (section == kResponseSection) {
            return @"Response";
        } else {
            return @"";
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (self.request == nil) {
		return @"Tap the + button to create a new HTTP Request";
	} else {
		return @"";
	}
}

+ (CGFloat) findLabelHeight:(NSString*) text font:(UIFont *)font label:(UILabel *)label {
    CGSize textLabelSize = CGSizeMake(label.frame.size.width, 9000.0f);
    // pad \n\n to fix layout bug
    CGSize stringSize = [text sizeWithFont:font constrainedToSize:textLabelSize lineBreakMode:UILineBreakModeCharacterWrap];
    return stringSize.height;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// might be slower to make the extra cellForRowAtIndexPath call, but it's flexible and DRY
    if (indexPath.section == kBodySection || indexPath.section == kRequestSection || indexPath.section == kResponseSection) {
        return ((UITableViewCell *)[self tableView:aTableView cellForRowAtIndexPath:indexPath]).frame.size.height;
    } else {
        return 44.0;
    }
}

- (UITableViewCell *)switchCell:(UITableView *)aTableView label:(NSString *)label action:(SEL)action value:(BOOL)value {
	UISwitchCell *cell = (UISwitchCell *)[aTableView dequeueReusableCellWithIdentifier:label];
	
	if (cell == nil) {
		cell = [[UISwitchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:label delegate:self action:action value:value];
	}
    
    // handle orientation placement issues
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        CGRect frame = CGRectMake(574.0, 9.0, 94.0, 27.0);
        cell.uiSwitch.frame = frame;
    } else {
        CGRect frame = CGRectMake(513.0, 9.0, 94.0, 27.0);
        cell.uiSwitch.frame = frame;
    }
    
	cell.textLabel.text = label;
	
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView dataCellForRowAtIndexPath:(NSIndexPath *)indexPath value:(NSString *)value pad:(BOOL)pad {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell"];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"DataCell" owner:self options:NULL]; 
		cell = nibLoadedCell;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	UILabel *label = (UILabel *) [cell viewWithTag:1];
    
    if (value == nil || [value isEqualToString:@""]) {
        label.text = @"\n";
    } else {
        if (pad) {
            //label.text = [NSString stringWithFormat:@"\n%@\n\n", value];
            label.text = [NSString stringWithFormat:@"%@\n\n", value];
        } else {
            label.text = value;
        }
    }
    
	// set the height of the title label to fit the size of the string
	CGFloat originalHeight = label.frame.size.height;	
	CGFloat textHeight = [DetailViewController findLabelHeight:label.text font:label.font label:label];
	
	CGRect labelRect = label.frame;
	labelRect.size.height += textHeight;
	label.frame = labelRect;
	
	CGRect cellRect = cell.frame;
	cellRect.size.height += textHeight - originalHeight;
	cell.frame = cellRect;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView textFieldCellForRowAtIndexPath:(NSIndexPath *)indexPath label:(NSString *)label textField:(UITextField **)textField value:(NSString *)value {
    static NSString *CellIdentifier = @"NameCell";
    
    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // handle orientation placement issues
    
    
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        CGRect frame = CGRectMake(250.0, cell.textField.frame.origin.y, cell.textField.frame.size.width, cell.textField.frame.size.height);
        cell.textField.frame = frame;
    } else {
        CGRect frame = CGRectMake(187.0, cell.textField.frame.origin.y, cell.textField.frame.size.width, cell.textField.frame.size.height);
        cell.textField.frame = frame;
    }
    
    cell.textField.delegate = self;    
    cell.textLabel.text = label;
    cell.textField.text = value;
    *textField = cell.textField;
    
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.backgroundView = nil;
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == kNameSection) {
        if (indexPath.row == 0) {
            return [self tableView:aTableView textFieldCellForRowAtIndexPath:indexPath label:@"Name" textField:&nameTextField value:self.request.name];
        } else if (indexPath.row == 1) {
            return [self tableView:aTableView textFieldCellForRowAtIndexPath:indexPath label:@"Group" textField:&groupTextField value:self.request.group];
        }
    } else if (indexPath.section == kSetupSection) {
        if (indexPath.row == 0) {
            return [self tableView:aTableView textFieldCellForRowAtIndexPath:indexPath label:@"URL" textField:&urlTextField value:self.request.url];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Method";
            cell.detailTextLabel.text = self.request.method;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2) {
            //cell.textLabel.text = @"Follow Redirects";
            
            //switchCell:(UITableView *)aTableView label:(NSString *)label action:(SEL)action value:(BOOL)value {
            return [self switchCell:aTableView label:@"Follow Redirects" action:nil value:NO];
            
        }
    } else if (indexPath.section == kHeadersSection) {
        //cell.textLabel.text = @"X-Auth-Token";
        //cell.detailTextLabel.text = @"awfoija32982h9f223g2gsdsfww";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row < [self.request.headers count]) {
            
            NSArray *keys = [self.request.headers allKeys];
            NSString *key = [keys objectAtIndex:indexPath.row];
            cell.textLabel.text = key;
            cell.detailTextLabel.text = [self.request.headers objectForKey:key];
            
            //Header *header = [self.request.headers objectAtIndex:indexPath.row];
            //cell.textLabel.text = header.name;
            //cell.detailTextLabel.text = header.value;
        } else {
            cell.textLabel.text = @"Add a header...";
            cell.detailTextLabel.text = @"";
        }
    } else if (indexPath.section == kBodySection) {
        return [self tableView:aTableView dataCellForRowAtIndexPath:indexPath value:self.request.body pad:YES];
    } else if (indexPath.section == kRequestSection) {
        return [self tableView:aTableView dataCellForRowAtIndexPath:indexPath value:self.request.rawRequest pad:NO];
    } else if (indexPath.section == kResponseSection) {
        return [self tableView:aTableView dataCellForRowAtIndexPath:indexPath value:self.request.response pad:NO];
    } else {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
	}
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == kHeadersSection;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.section == kNameSection) {
	} else if (indexPath.section == kSetupSection) {
        if (indexPath.row == 0) { // URL
        } else if (indexPath.row == 1) { // Method
            MethodViewController *vc = [[MethodViewController alloc] initWithNibName:@"MethodViewController" bundle:nil];
            //vc.detailViewController = self;
            vc.detailViewController = self;
            vc.method = self.request.method;
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentModalViewController:vc animated:YES];
        } else if (indexPath.row == 2) { // Follow Redirects
        }
    } else if (indexPath.section == kHeadersSection) {
        HeaderViewController *vc = [[HeaderViewController alloc] initWithNibName:@"HeaderViewController" bundle:nil];
        vc.detailViewController = self;        
        vc.indexPath = indexPath;
        NSArray *keys = [self.request.headers allKeys];
        
        if (indexPath.row != [keys count]) {        
            NSString *key = [keys objectAtIndex:indexPath.row];
            vc.key = key;
            vc.value = [self.request.headers objectForKey:key];
        }
        
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:vc animated:YES];
    } else if (indexPath.section == kBodySection) {
        BodyViewController *vc = [[BodyViewController alloc] initWithNibName:@"BodyViewController" bundle:nil];
        vc.detailViewController = self;
        vc.text = self.request.body;
        NSLog(@"vc text is:\n%@", vc.text);
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:vc animated:YES];
	} else if (indexPath.section == kResponseSection) {
        ResponseViewController *vc = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
        vc.text = self.request.response;
        NSLog(@"vc text is:\n%@", vc.text);
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:vc animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kHeadersSection) {
        if (indexPath.row == 0) {
            return UITableViewCellEditingStyleDelete;
        } else {
            return UITableViewCellEditingStyleInsert;
        }
    } else {
        return UITableViewCellEditingStyleNone;
    }
}



#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.tableFooterView = self.footerView;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Email Request Details", @"Copy curl Command", nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(orientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.rootViewController preselectRequestForDetailView];
    [super viewWillAppear:animated];
}

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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	
    [popoverController release];
    [toolbar release];
	
	[detailItem release];
	[detailDescriptionLabel release];
    
    [tableView release];
    [editButton release];
    [optionsButton release];
    [nibLoadedCell release];
    
    [request release];
    [footerView release];
    [performRequestButton release];
    
    [actionSheet release];
    
	[super dealloc];
}	


@end
