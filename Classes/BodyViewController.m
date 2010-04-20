    //
//  BodyViewController.m
//  HTTPClient
//
//  Created by Michael Mayo on 4/5/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import "BodyViewController.h"
#import "DetailViewController.h"
#import "Request.h"
#import "RootViewController.h"


@implementation BodyViewController

@synthesize textView, text, detailViewController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    textView.font = [UIFont fontWithName:@"Courier" size:17.0];
    textView.text = text;
    textView.delegate = self;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
    [super viewDidAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark -
#pragma mark Button Handlers

-(void)cancelButtonPressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)saveButtonPressed:(id)sender {
    self.detailViewController.request.body = self.textView.text;
    NSLog(@"text view:\n%@", self.textView.text);
    NSLog(@"body is:\n%@", self.detailViewController.request.body);
    [self.detailViewController.rootViewController saveSelectedRequest];
    [self.detailViewController.tableView reloadData];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Text View Delegate

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)someText {
    //self.textView.text = [aTextView.text stringByReplacingCharactersInRange:range withString:someText];
    return YES;
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [textView release];
    [text release];
    [detailViewController release];
    [super dealloc];
}


@end
