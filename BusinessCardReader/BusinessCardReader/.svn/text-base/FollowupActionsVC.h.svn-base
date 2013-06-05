//
//  FollowupActionsVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/20/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FollowupActionsVC;
@protocol FollowupActionsVCDelegate <NSObject>

- (void)followupActionsVC:(FollowupActionsVC *)followupActionsVC didFinishPickingFollowupActionsWithInfo:(NSDictionary *)info;

@end

@interface FollowupActionsVC : UIViewController

@property (strong, nonatomic) NSMutableArray *actionList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) id<FollowupActionsVCDelegate> delegate;

- (IBAction)submitButtonTapped:(id)sender;

@end
