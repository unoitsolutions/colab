//
//  TopicPickerVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/13/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"

@class TopicPickerVC;
@protocol TopicPickerVCDelegate <DetailVCDelegate>

- (void)topicPicker:(TopicPickerVC *)picker didFinishPickingTopicsWithInfo:(NSDictionary *)info;

@end

@interface TopicPickerVC : DetailVC

@property (strong, nonatomic) BCRContact *contact;
@property (strong, nonatomic) NSMutableArray *topicList;
@property (weak, nonatomic) id<TopicPickerVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;

@end
