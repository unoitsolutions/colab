//
//  ContactsVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/21/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"

@interface ContactsVC : DetailVC <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray *contactList;
@property (strong, nonatomic) NSMutableArray *processingContactList;
@property (nonatomic) BOOL isReloading;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cameraButtonTapped:(id)sender;

- (void)reloadData;

@end
