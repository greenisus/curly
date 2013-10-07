//
//  MMSettingsViewController.m
//  Curly
//
//  Created by Mike Mayo on 10/6/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "MMSettingsViewController.h"

typedef enum {
    MMRequestOptionsSection,
    MMCodeSharingSection, // curl, obj-c, ruby, etc (link to curly in the email, do an html email)
    MMAboutSection,
    MMNumberOfSections
} MMSettingsSections;

typedef enum {
    MMRequestOptionHTTPMethodsRow,
    MMRequestOptionUserAgentsRow,
    MMRequestOptionsNumberOfRows
} MMRequestOptionsRows;

typedef enum {
    MMCodeSharingCurlRow,
    MMCodeSharingObjCRow,
    MMCodeSharingRubyRow,
    MMCodeSharingPythonRow,
    MMCodeSharingPHPRow,
    MMCodeSharingJavaRow,
    MMCodeSharingNumberOfRows
} MMCodeSharingRows;

@interface MMSettingsViewController ()

@end

@implementation MMSettingsViewController

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == MMRequestOptionsSection) {
        return NSLocalizedString(@"HTTP Request Options", nil);
    } else if (section == MMCodeSharingSection) {
        return NSLocalizedString(@"Code Sharing", nil);
    } else if (section == MMAboutSection) {
        return NSLocalizedString(@"About Curly", nil);
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == MMCodeSharingSection) {
        return NSLocalizedString(@"The commands and programming examples to send when sharing a request.", nil);
    } else {
        return @"";
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MMNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == MMRequestOptionsSection) {
        return MMRequestOptionsNumberOfRows;
    } else if (section == MMCodeSharingSection) {
        return MMCodeSharingNumberOfRows;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (indexPath.section == MMRequestOptionsSection) {
        
    } else if (indexPath.section == MMCodeSharingSection) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (indexPath.row == MMCodeSharingCurlRow) {
            cell.textLabel.text = @"curl";
        } else if (indexPath.row == MMCodeSharingObjCRow) {
            cell.textLabel.text = @"Objective-C";
        } else if (indexPath.row == MMCodeSharingRubyRow) {
            cell.textLabel.text = @"Ruby";
        } else if (indexPath.row == MMCodeSharingPythonRow) {
            cell.textLabel.text = @"Python";
        } else if (indexPath.row == MMCodeSharingPHPRow) {
            cell.textLabel.text = @"PHP";
        } else if (indexPath.row == MMCodeSharingJavaRow) {
            cell.textLabel.text = @"Java";
        } else {
            cell.textLabel.text = @"";
        }
        
    } else {
        cell.textLabel.text = @"";
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Button Handlers

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end