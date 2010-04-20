//
//  ResponseViewController.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/5/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResponseViewController : UIViewController {
    IBOutlet UITextView *textView;
    NSString *headerText;
    NSString *bodyText;
    NSString *text;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIWebView *webView;
    NSString *baseURL;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *headerText;
@property (nonatomic, retain) NSString *bodyText;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *baseURL;

-(void)cancelButtonPressed:(id)sender;

@end
