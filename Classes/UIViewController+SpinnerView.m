//
//  UIViewController+SpinnerView.m
//  RackspaceCloud
//
//  Created by Michael Mayo on 2/10/10.
//  Copyright Mike Mayo 2010. All rights reserved. Inc. All rights reserved.
//

#import "UIViewController+SpinnerView.h"
#import "SpinnerViewController.h"

#define kSpinnerTag 777

@implementation UIViewController (SpinnerView)

#pragma mark -
#pragma mark Spinner View

-(void)showSpinnerView:(NSString *)text {
	SpinnerViewController *vc = [[SpinnerViewController alloc] initWithNibName:@"SpinnerViewController" bundle:nil];
	CGPoint center = self.view.center;
	CGPoint offset = CGPointZero;
    
    if (!(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        center.x = 351.5;
    }
    

    NSLog(@"center: (%f, %f)", center.x, center.y);
    
	@try {
		UIScrollView *scrollView = (UIScrollView *) self.view;
		offset = scrollView.contentOffset;
	}
	@catch (NSException * e) {
		// do nothing if this fails
	}
	
	////NSLog(@"center: %f, %f", center.x, center.y);
	center.y = center.y / 3; // move it up a bit
	
	center.y = center.y + offset.y;
	
	vc.view.center = center;
	vc.label.text = text;
	vc.view.tag = kSpinnerTag;
	[self.view addSubview:vc.view];
    self.view.userInteractionEnabled = NO;
	[vc release];
}

-(void) showSpinnerView {
	[self showSpinnerView:@"Please wait..."];
}

-(void)hideSpinnerView {
    self.view.userInteractionEnabled = YES;
	UIView *spinner = [self.view viewWithTag:kSpinnerTag];
	if (spinner != nil) {
		[spinner removeFromSuperview];
	}
}

#pragma mark -
#pragma mark Alert Helpers

-(void)alert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
