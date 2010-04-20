//
//  BodyViewController.h
//  HTTPClient
//
//  Created by Michael Mayo on 4/5/10.
//  Copyright Mike Mayo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface BodyViewController : UIViewController <UITextViewDelegate> {
    IBOutlet UITextView *textView;
    NSString *text;
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) DetailViewController *detailViewController;

-(void)cancelButtonPressed:(id)sender;
-(void)saveButtonPressed:(id)sender;

@end
