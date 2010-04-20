//
//  UIViewController+SpinnerView.h
//  RackspaceCloud
//
//  Created by Michael Mayo on 2/10/10.
//  Copyright 2010 Mike Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpinnerViewController;

@interface UIViewController (SpinnerView)

-(void)showSpinnerView:(NSString *)text;
-(void)showSpinnerView;
-(void)hideSpinnerView;

-(void)alert:(NSString *)title message:(NSString *)message;

@end
