//
//  ContactListVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"

@interface ContactListVC : DetailVC

@property (strong, nonatomic) NSMutableArray *contactList, *contactListBackUp;
@property (nonatomic) BOOL isReloading;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;

- (void)reloadData;

@end
