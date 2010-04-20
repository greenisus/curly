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
    NSString *text;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *text;

-(void)cancelButtonPressed:(id)sender;

@end
