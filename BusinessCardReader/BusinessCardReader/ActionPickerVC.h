//
//  ActionPickerVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/13/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"

@class ActionPickerVC;
@protocol ActionPickerVCDelegate <DetailVCDelegate>

- (void)actionPicker:(ActionPickerVC *)picker didFinishPickingFollowupActionsWithInfo:(NSDictionary *)info;

@end

@interface ActionPickerVC : DetailVC

@property (strong, nonatomic) BCRContact *contact;
@property (strong, nonatomic) NSMutableArray *actionList;
@property (weak, nonatomic) id<ActionPickerVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)finishButtonTapped:(id)sender;

@end
