//
//  TextFieldCell.h
//  Rackspace
//
//  Created by Michael Mayo on 9/26/09.
//  Copyright 2010 Mike Mayo All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldCell : UITableViewCell {
	UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

@end
