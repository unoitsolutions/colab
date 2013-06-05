//
//  TopicsVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/20/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicsVC;
@protocol TopicsVCDelegate <NSObject>

- (void)topicsVC:(TopicsVC *)topicsVC didFinishPickingTopicsWithInfo:(NSDictionary *)info;

@end

@interface TopicsVC : UIViewController

@property (strong, nonatomic) NSMutableArray *topicList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) id<TopicsVCDelegate> delegate;

- (IBAction)nextButtonTapped:(id)sender;

@end
