//
//  ContactCreateVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/27/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"
#import "TopicPickerVC.h"
#import "ActionPickerVC.h"


@class ContactCreateVC;
@protocol ContactCreateVCDelegate <NSObject>

- (void)contactCreateVC:(ContactCreateVC *)createVC didCreateContact:(BCRContact *)contact;

@end

@interface ContactCreateVC : DetailVC <UITextFieldDelegate, BCRContactDelegate, TopicPickerVCDelegate, ActionPickerVCDelegate>

@property (strong, nonatomic) BCRContact *contact;

@property (strong, nonatomic) TopicPickerVC *topicPicker;
@property (strong, nonatomic) ActionPickerVC *actionPicker;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;

@end
