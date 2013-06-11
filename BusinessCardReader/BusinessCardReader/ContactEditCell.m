//
//  ContactEditCell.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/27/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactEditCell.h"

@implementation ContactEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:11];
        //        self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //        self.textField.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews]; // layouts the cell as UITableViewCellStyleValue2 would normally look like
    
    // change frame of one or more labels
    self.textLabel.frame = CGRectMake(5, 0, 65, self.contentView.frame.size.height);
    //    self.detailTextLabel.frame = CGRectMake(55, 0, 232, self.contentView.frame.size.height);
    self.textField.frame = CGRectMake(75, 0, 212, self.contentView.frame.size.height); //CGRectMake(55, 8, 232, 21);
}

@end
