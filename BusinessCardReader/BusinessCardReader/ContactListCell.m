//
//  ContactListTableViewCell.m
//  BusinessCardReader
//
//  Created by Patricia Marie Cesar on 6/9/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactListCell.h"

@implementation ContactListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"contacts_row_bg"]]];
        
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        self.delegate = self;
    }
    return self;
}

- (void)setUpCellContents:(BCRContact *)contact
{
    self.contact = contact;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@",(!contact.firstName.isNull ? [NSString stringWithFormat:@"%@ ",contact.firstName] : @""),contact.lastName];
    self.detailTextLabel.text = contact.company;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIImageView*)checkmarkGreyImageView {
    if (!_checkmarkGreyImageView) {
        _checkmarkGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [_checkmarkGreyImageView setImage:[UIImage imageNamed:@"CheckmarkGrey"]];
        [_checkmarkGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_checkmarkGreyImageView];
    }
    return _checkmarkGreyImageView;
}

- (UIImageView*)checkmarkGreenImageView {
    if (!_checkmarkGreenImageView) {
        _checkmarkGreenImageView = [[UIImageView alloc] initWithFrame:self.checkmarkGreyImageView.bounds];
        [_checkmarkGreenImageView setImage:[UIImage imageNamed:@"CheckmarkGreen"]];
        [_checkmarkGreenImageView setContentMode:UIViewContentModeCenter];
        [self.checkmarkGreyImageView addSubview:_checkmarkGreenImageView];
    }
    return _checkmarkGreenImageView;
}

-(UIImageView*)deleteGreyImageView {
    if (!_deleteGreyImageView) {
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [_deleteGreyImageView setImage:[UIImage imageNamed:@"DeleteGrey"]];
        [_deleteGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_deleteGreyImageView];
    }
    return _deleteGreyImageView;
}

-(UIImageView*)deleteRedImageView {
    if (!_deleteRedImageView) {
        _deleteRedImageView = [[UIImageView alloc] initWithFrame:self.deleteGreyImageView.bounds];
        [_deleteRedImageView setImage:[UIImage imageNamed:@"DeleteRed"]];
        [_deleteRedImageView setContentMode:UIViewContentModeCenter];
        [self.deleteGreyImageView addSubview:_deleteRedImageView];
    }
    return _deleteRedImageView;
}

-(void)prepareForReuse {
	[super prepareForReuse];
	self.textLabel.textColor = [UIColor blackColor];
	self.detailTextLabel.text = nil;
	self.detailTextLabel.textColor = [UIColor grayColor];
	[self setUserInteractionEnabled:YES];
	self.imageView.alpha = 1;
	self.accessoryView = nil;
	self.accessoryType = UITableViewCellAccessoryNone;
    [self.contentView setHidden:NO];
    [self cleanupBackView];
}

- (void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super animateContentViewForPoint:point velocity:velocity];
    if (point.x > 0) {
        // set the checkmark's frame to match the contentView
        [self.checkmarkGreyImageView setFrame:CGRectMake(MIN(CGRectGetMinX(self.contentView.frame) - CGRectGetWidth(self.checkmarkGreyImageView.frame), 0), CGRectGetMinY(self.checkmarkGreyImageView.frame), CGRectGetWidth(self.checkmarkGreyImageView.frame), CGRectGetHeight(self.checkmarkGreyImageView.frame))];
        if (point.x >= CGRectGetHeight(self.frame) && self.isSaved == NO) {
            [self.checkmarkGreenImageView setAlpha:1];
        } else if (self.isSaved == NO) {
            [self.checkmarkGreenImageView setAlpha:0];
        } else if (point.x >= CGRectGetHeight(self.frame) && self.isSaved == YES) {
            // already a favourite; animate the green checkmark drop when swiped far enough for the action to kick in when user lets go
            if (self.checkmarkGreyImageView.alpha == 1) {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     CATransform3D rotate = CATransform3DMakeRotation(-0.4, 0, 0, 1);
                                     [self.checkmarkGreenImageView.layer setTransform:CATransform3DTranslate(rotate, -10, 20, 0)];
                                     [self.checkmarkGreenImageView setAlpha:0];
                                 }];
            }
        } else if (self.isSaved == YES) {
            // already a favourite; but user panned back to a lower value than the action point
            CATransform3D rotate = CATransform3DMakeRotation(0, 0, 0, 1);
            [self.checkmarkGreenImageView.layer setTransform:CATransform3DTranslate(rotate, 0, 0, 0)];
            [self.checkmarkGreenImageView setAlpha:1];
        }
    } else if (point.x < 0) {
        // set the X's frame to match the contentView
        [self.deleteGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.deleteGreyImageView.frame), CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetHeight(self.deleteGreyImageView.frame))];
        if (-point.x >= CGRectGetHeight(self.frame)) {
            [self.deleteRedImageView setAlpha:1];
        } else {
            [self.deleteRedImageView setAlpha:0];
        }
    }
}

- (void)cleanupBackView
{
    [super cleanupBackView];
    [_checkmarkGreyImageView removeFromSuperview];
    _checkmarkGreyImageView = nil;
    [_checkmarkGreenImageView removeFromSuperview];
    _checkmarkGreenImageView = nil;
    [_deleteGreyImageView removeFromSuperview];
    _deleteGreyImageView = nil;
    [_deleteRedImageView removeFromSuperview];
    _deleteRedImageView = nil;
}

#pragma mark - Swipe Table View Cell Delegate

- (void)swipeTableViewCellWillResetState:(ContactListCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        // Full swipe to right - SAVE
        [self.swipeListener didSwipeRight:swipeTableViewCell];
    } else if (point.x < 0 && -point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        // Full swipe to left - DELETE
        [self.swipeListener didSwipeLeft:swipeTableViewCell];

    }
}


@end
