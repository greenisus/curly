    //
//  ResponseViewController.m
//  HTTPClient
//
//  Created by Michael Mayo on 4/5/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import "ResponseViewController.h"


@implementation ResponseViewController

@synthesize textView, headerText, bodyText, segmentedControl, webView;
@synthesize text, baseURL;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)segmentedControlChanged:(id)sender {
    if (segmentedControl.selectedSegmentIndex == 0) {
        // raw view
        textView.hidden = NO;
        webView.hidden = YES;
    } else {
        // web view
        textView.hidden = YES;
        webView.hidden = NO;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    webView.hidden = YES;    
    textView.font = [UIFont fontWithName:@"Courier" size:17.0];
    textView.text = text;
    
    // split on first \n\n to avoid changing core data schema for this feature
    NSArray *components = [text componentsSeparatedByString:@"\n\n"];
    NSString *webText = @"";
    if ([components count] > 1) {
        for (int i = 1; i < [components count]; i++) {
            webText = [webText stringByAppendingString:[components objectAtIndex:i]];
        }
    }
    [webView loadHTMLString:webText baseURL:[NSURL URLWithString:baseURL]];
    [segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];    
    [super viewDidLoad];
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


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [textView release];
    [headerText release];
    [bodyText release];
    [segmentedControl release];
    [webView release];
    [text release];
    [baseURL release];
    [super dealloc];
}


@end
