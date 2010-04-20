//
//  UISwitchCell.m
//  RackspaceCloud
//
//  Created by Michael Mayo on 2/27/10.
//  Copyright 2010 Mike Mayo All rights reserved.
//

#import "UISwitchCell.h"


@implementation UISwitchCell

@synthesize uiSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id)delegate action:(SEL)action value:(BOOL)value {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code

        CGRect frame = CGRectMake(513.0, 9.0, 94.0, 27.0);
        
        
		uiSwitch = [[UISwitch alloc] initWithFrame:frame];
        //uiSwitch.bounds = CGRectMake(513.0, 9.0, 94.0, 27.0);
		
        // in case the parent view draws with a custom color or gradient, use a transparent color
        /*
		self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
        uiSwitch.backgroundColor = [UIColor clearColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		*/
		
		[uiSwitch addTarget:delegate action:action forControlEvents:UIControlEventValueChanged];
		
		uiSwitch.on = value;
		
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
		[self.contentView addSubview:uiSwitch];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[uiSwitch release];
    [super dealloc];
}


@end
