//
//  ContactDetailVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"
#import "PhotoViewerVC.h"

@interface ContactDetailVC : DetailVC

@property (strong, nonatomic) BCRContact *contact;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)editButtonTapped:(id)sender;
- (IBAction)zoomButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;

- (void)reloadData;

@end
