//
//  UISwitchCell.h
//  RackspaceCloud
//
//  Created by Michael Mayo on 2/27/10.
//  Copyright 2010 Mike Mayo All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UISwitchCell : UITableViewCell {
	UISwitch *uiSwitch;
}

@property (nonatomic, retain) UISwitch *uiSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate action:(SEL)action value:(BOOL)value;

@end
