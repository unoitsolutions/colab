//
//  ContactListTableViewCell.h
//  BusinessCardReader
//
//  Created by Patricia Marie Cesar on 6/9/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RMSwipeTableViewCell.h"
#import "BCRContact.h"

@protocol ContactListCellDelegate;

@interface ContactListCell : RMSwipeTableViewCell <RMSwipeTableViewCellDelegate>

@property (nonatomic, strong) BCRContact *contact;
@property (nonatomic, strong) UIView *backgroundViewCell;
@property (nonatomic, strong) UIImageView *checkmarkGreyImageView;
@property (nonatomic, strong) UIImageView *checkmarkGreenImageView;
@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;
@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, assign) id<ContactListCellDelegate> swipeListener;

- (void)setUpCellContents:(BCRContact *)contact;

@end

@protocol ContactListCellDelegate <NSObject>

@optional
- (void)didSwipeLeft:(ContactListCell *)cell;
- (void)didSwipeRight:(ContactListCell *)cell;

@end