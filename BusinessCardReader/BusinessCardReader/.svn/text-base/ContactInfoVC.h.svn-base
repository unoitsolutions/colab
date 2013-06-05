//
//  ContactInfoVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/23/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCRContact.h"
#import "ELCTextFieldCell.h"

typedef enum{
    ContactInfoVCModeDefault,
    ContactInfoVCModeEdit,
} ContactInfoVCMode;

@interface ContactInfoVC : UIViewController <ELCTextFieldDelegate>

@property (strong, nonatomic) BCRContact *contact;
@property (nonatomic) ContactInfoVCMode mode;

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButton;

- (IBAction)editBarButtonTapped:(id)sender;

@end
