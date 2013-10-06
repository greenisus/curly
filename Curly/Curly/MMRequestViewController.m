//
//  MMRequestViewController.m
//  Curly
//
//  Created by Mike Mayo on 9/29/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "MMRequestViewController.h"

typedef enum {
    MMRequestSection,
    MMHeadersSection,
    MMBodySection,
    MMRequestNumberOfSections
} MMRequestSectionType;

typedef enum {
    MMNameRow,
    MMURLRow,
    MMMethodRow,
    MMMethodPickerRow,
    MMUserAgentRow,
    MMUserAgentPickerRow,
    MMSSLRow,
    MMRequestNumberOfRows
} MMRequestRowType;

/*
 (top right, Done button or Run button)
 
 Request Headers
 ---------------
 multi-row table of headers
 
 Request Body
 ------------
 (text field or build json?)
 
 Responses table row
 
 */

@interface MMRequestViewController () {
    
    BOOL methodPickerActive;
    BOOL userAgentPickerActive;
    
    NSArray *httpMethods;
    MMHTTPMethod *selectedHTTPMethod;

    NSArray *userAgents;
    MMUserAgent *selectedUserAgent;
    
}

- (void)sslSwitchValueChanged:(id)sender;

@property (nonatomic, strong) NSMutableArray *requestHeaders;

@property (nonatomic, strong) UIView *nameTextFieldContainer;
@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UIView *urlTextFieldContainer;
@property (nonatomic, strong) UITextField *urlTextField;
@property (nonatomic, strong) UISwitch *sslSwitch;

@property (nonatomic, strong) UIPickerView *methodPicker;
@property (nonatomic, strong) UITableViewCell *methodPickerCell;

@property (nonatomic, strong) UIPickerView *userAgentPicker;
@property (nonatomic, strong) UITableViewCell *userAgentPickerCell;

@end

@implementation MMRequestViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSupportingData];
    
    [self configureCellAccessories];
    self.requestHeaders = [[NSMutableArray alloc] init];
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
}

#pragma mark - Utilities

- (void)loadSupportingData {

    NSManagedObjectContext *context = [MMAppDelegate context];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSError *error = nil;
    
    NSFetchRequest *methodsRequest = [NSFetchRequest fetchRequestWithEntityName:@"MMHTTPMethod"];
    [methodsRequest setSortDescriptors:@[sortDescriptor]];
    
    httpMethods = [context executeFetchRequest:methodsRequest error:&error];
    if (error) {
        DLog(@"Error loading HTTP methods: %@", error);
    }
    
    for (MMHTTPMethod *method in httpMethods) {
        if ([method.name isEqualToString:@"GET"]) {
            selectedHTTPMethod = method;
        }
    }
    
    NSFetchRequest *userAgentsRequest = [NSFetchRequest fetchRequestWithEntityName:@"MMUserAgent"];
    [userAgentsRequest setSortDescriptors:@[sortDescriptor]];

    userAgents = [context executeFetchRequest:userAgentsRequest error:&error];
    if (error) {
        DLog(@"Error loading HTTP methods: %@", error);
    }
    
    for (MMUserAgent *userAgent in userAgents) {
        if ([userAgent.name isEqualToString:@"Curly"]) {
            selectedUserAgent = userAgent;
        }
    }
    
}

- (void)configureCellAccessories {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // configure SSL switch
    self.sslSwitch = [[UISwitch alloc] init];
    self.sslSwitch.onTintColor = kMMTintColor;
    self.sslSwitch.on = [defaults boolForKey:kMMValidateSSL];
    [self.sslSwitch addTarget:self action:@selector(sslSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.nameTextFieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 225, 26)];
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, 225, 24)];
    self.nameTextField.delegate = self;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.textAlignment = NSTextAlignmentRight;
    self.nameTextField.placeholder = NSLocalizedString(@"Request Name", nil);
    self.nameTextField.text = @"";
    [self.nameTextFieldContainer addSubview:self.nameTextField];
    
    self.urlTextFieldContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 225, 26)];
    self.urlTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, 225, 24)];
    self.urlTextField.delegate = self;
    self.urlTextField.returnKeyType = UIReturnKeyDone;
    self.urlTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.urlTextField.textAlignment = NSTextAlignmentRight;
    self.urlTextField.placeholder = NSLocalizedString(@"URL", nil);
    self.urlTextField.text = @"";
    [self.urlTextFieldContainer addSubview:self.urlTextField];
    
    // configure HTTP method picker
    self.methodPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.methodPicker.delegate = self;
    self.methodPicker.dataSource = self;
    self.methodPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.methodPickerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.methodPickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.methodPickerCell addSubview:self.methodPicker];
    
    // configure user agent picker
    self.userAgentPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.userAgentPicker.delegate = self;
    self.userAgentPicker.dataSource = self;
    self.userAgentPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.userAgentPickerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.userAgentPickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.userAgentPickerCell addSubview:self.userAgentPicker];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MMRequestNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case MMRequestSection:
            return MMRequestNumberOfRows;
        case MMHeadersSection:
            return [self.requestHeaders count] + 1;
        case MMBodySection:
            return 1;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == MMRequestSection && indexPath.row == MMMethodPickerRow) {
        if (methodPickerActive) {
            return kMMUIPickerViewHeight;
        } else {
            return 0;
        }
    } else if (indexPath.section == MMRequestSection && indexPath.row == MMUserAgentPickerRow) {
        if (userAgentPickerActive) {
            return kMMUIPickerViewHeight;
        } else {
            return 0;
        }
    } else {
        return self.tableView.rowHeight;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case MMRequestSection:
            return NSLocalizedString(@"HTTP Request", nil);
        case MMHeadersSection:
            return NSLocalizedString(@"Headers", nil);
        case MMBodySection:
            return NSLocalizedString(@"Body", nil);
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // default to no accessory
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == MMRequestSection) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == MMNameRow) {
            
            cell.textLabel.text = NSLocalizedString(@"Name", nil);
            cell.detailTextLabel.text = @"";
            self.nameTextField.font = cell.detailTextLabel.font;
            self.nameTextField.textColor = cell.detailTextLabel.textColor;
            cell.accessoryView = self.nameTextFieldContainer;
            
        } else if (indexPath.row == MMURLRow) {
            
            cell.textLabel.text = NSLocalizedString(@"URL", nil);
            cell.detailTextLabel.text = @"";
            self.urlTextField.font = cell.detailTextLabel.font;
            self.urlTextField.textColor = cell.detailTextLabel.textColor;
            cell.accessoryView = self.urlTextFieldContainer;
            
        } else if (indexPath.row == MMMethodRow) {
            
            cell.textLabel.text = NSLocalizedString(@"Method", nil);
            cell.detailTextLabel.text = selectedHTTPMethod.name;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            if (methodPickerActive) {
                cell.detailTextLabel.textColor = kMMTintColor;
            } else {
                cell.detailTextLabel.textColor = [UIColor darkTextColor];
            }

        } else if (indexPath.row == MMMethodPickerRow) {
            
            return self.methodPickerCell;
            
        } else if (indexPath.row == MMSSLRow) {

            cell.textLabel.text = NSLocalizedString(@"Validate SSL Certificates", nil);
            cell.detailTextLabel.text = @"";
            cell.accessoryView = self.sslSwitch;
            
        } else if (indexPath.row == MMUserAgentRow) {

            cell.textLabel.text = NSLocalizedString(@"User Agent", nil);
            cell.detailTextLabel.text = selectedUserAgent.name;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            if (userAgentPickerActive) {
                cell.detailTextLabel.textColor = kMMTintColor;
            } else {
                cell.detailTextLabel.textColor = [UIColor darkTextColor];
            }
            
        } else if (indexPath.row == MMUserAgentPickerRow) {
            
            return self.userAgentPickerCell;
            
        }

    } else if (indexPath.section == MMHeadersSection) {
        
        if (indexPath.row == [self.requestHeaders count]) {
            
            cell.textLabel.text = NSLocalizedString(@"Add Header...", nil);
            cell.detailTextLabel.text = @"";
            
        } else {
            
            // show the header
            
        }
        
    } else {
        
        cell.textLabel.text = @"";
        
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == MMHeadersSection;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == MMHeadersSection) {
        if (indexPath.row == [self.requestHeaders count]) {
            return UITableViewCellEditingStyleInsert;
        } else {
            return UITableViewCellEditingStyleDelete;
        }
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == MMRequestSection && indexPath.row == MMMethodRow) {
        
        methodPickerActive = !methodPickerActive;
        
        if (methodPickerActive) {
            
            [UIView animateWithDuration:0.3 animations:^{
                CGRect r = self.methodPicker.frame;
                self.methodPickerCell.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, kMMUIPickerViewHeight);
            }];
            
        } else {
            
            [UIView animateWithDuration:0.3 animations:^{
                CGRect r = self.methodPicker.frame;
                self.methodPickerCell.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, 0);
            }];
            
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MMMethodRow inSection:MMRequestSection]] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MMMethodRow - 1 inSection:MMRequestSection],
//                                                 [NSIndexPath indexPathForRow:MMMethodPickerRow + 1 inSection:MMRequestSection]] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if (indexPath.section == MMRequestSection && indexPath.row == MMUserAgentRow) {
        
        userAgentPickerActive = !userAgentPickerActive;
        
        if (userAgentPickerActive) {
            
            [UIView animateWithDuration:0.3 animations:^{
                CGRect r = self.userAgentPicker.frame;
                self.userAgentPickerCell.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, kMMUIPickerViewHeight);
            }];
            
        } else {
            
            [UIView animateWithDuration:0.3 animations:^{
                CGRect r = self.userAgentPicker.frame;
                self.userAgentPickerCell.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, 0);
            }];
            
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MMUserAgentRow inSection:MMRequestSection]] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MMUserAgentRow - 1 inSection:MMRequestSection],
//                                                 [NSIndexPath indexPathForRow:MMUserAgentPickerRow + 1 inSection:MMRequestSection]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
                                
//    [self performSegueWithIdentifier:kMMMethodSegue sender:self];
                                
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:kMMMethodSegue]) {
//        
//        MMHTTPMethodViewController *vc = (MMHTTPMethodViewController *)[segue destinationViewController];
//        DLog(@"vc: %@", vc);
//        
//    }
//    
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.nameTextField]) {
        [textField resignFirstResponder];
        [self.urlTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.methodPicker]) {
        return [httpMethods count];
    } else if ([pickerView isEqual:self.userAgentPicker]) {
        return [userAgents count];
    } else {
        return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([pickerView isEqual:self.methodPicker]) {
        return [httpMethods[row] valueForKey:@"name"];
    } else if ([pickerView isEqual:self.userAgentPicker]) {
        return [userAgents[row] valueForKey:@"name"];
    } else {
        return @"";
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([pickerView isEqual:self.methodPicker]) {
        selectedHTTPMethod = httpMethods[row];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:MMMethodRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
    }
    
}


#pragma mark - Button Handlers

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)doneButtonPressed:(id)sender {
    
    NSManagedObjectContext *context = [MMAppDelegate context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MMRequest" inManagedObjectContext:context];
    
    MMRequest *request = [[MMRequest alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    request.name = self.nameTextField.text;
    
    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
    
    request.url = self.urlTextField.text;
    
    
//    NSDictionary *itemAttributes = [[HLAPIClient sharedClient] attributesForRepresentation:firstArg ofEntity:entity fromResponse:nil];
//    [roomItem safelySetValuesForKeysWithDictionary:itemAttributes];
    
//    [context rollback];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sslSwitchValueChanged:(id)sender {
    // set whatever the switch is to the default value going forward
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.sslSwitch.on forKey:kMMValidateSSL];
    [defaults synchronize];
}

@end