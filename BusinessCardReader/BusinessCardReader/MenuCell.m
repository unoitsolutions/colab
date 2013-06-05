//
//  MenuCell.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/2/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
//        self.textLabel.textColor = [[AETheme sharedInstance] defaultBackgroundColor];
//        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
//        self.textLabel.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
//        self.textLabel.shadowOffset = CGSizeMake(-1, 1);
//        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

//    self.imageView.highlighted = selected;
//    if (selected) {
//        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg_highlighted"]];
//        self.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
////        self.textLabel.shadowColor = [[AETheme sharedInstance] defaultBackgroundColor];
//    }else{
//        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];
////        self.textLabel.textColor = [[AETheme sharedInstance] defaultBackgroundColor];
//        self.textLabel.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
//    }
}

@end
