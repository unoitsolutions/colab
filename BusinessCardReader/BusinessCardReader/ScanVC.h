//
//  ScanVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/7/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"

@interface ScanVC : DetailVC

@property (strong, nonatomic) NSMutableArray *eventList;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *dropdownButton;
@property (strong, nonatomic) IBOutlet UIView *eventPickerView;
@property (weak, nonatomic) IBOutlet UITableView *eventPickerTableView;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)dropdownButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)createContactButtonTapped:(id)sender;

- (void)reloadData;

@end
