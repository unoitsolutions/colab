//
//  EventsVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/20/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"
#import "BCRAccountManager.h"

@interface EventsVC : DetailVC <UISearchBarDelegate, BCRAccountManagerDelegate>

@property (strong, nonatomic) NSMutableArray *eventList;
@property (strong, nonatomic) NSMutableArray *filteredList;

@property (weak, nonatomic) IBOutlet UIToolbar *topBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)cameraButtonTapped:(id)sender;

- (void)reloadData;

@end
