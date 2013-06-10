//
//  ContactEditVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/22/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicPickerVC.h"
#import "ActionPickerVC.h"
#import "PhotoViewerVC.h"

@interface ContactEditVC : UIViewController <UITextFieldDelegate,  BCRContactDelegate, TopicPickerVCDelegate, ActionPickerVCDelegate>

@property (strong, nonatomic) BCRContact *contact;
@property (copy, nonatomic) BCRContact *contactCopy;

@property (strong, nonatomic) TopicPickerVC *topicPicker;
@property (strong, nonatomic) ActionPickerVC *actionPicker;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)zoomButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;

@end
