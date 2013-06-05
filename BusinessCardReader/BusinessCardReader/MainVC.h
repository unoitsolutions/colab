//
//  MainVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "MenuVC.h"
#import "CardCaptureVC.h"

#import "ScanVC.h"
#import "ContactListVC.h"
#import "ShareVC.h"
#import "ContactUsVC.h"
#import "AboutVC.h"
#import "ContactCreateVC.h"

@interface MainVC : UIViewController <MenuVCDelegate, DetailVCDelegate, LoginVCDelegate, CardCaptureVCDelegate, BCRAccountManagerDelegate>

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) MenuVC *menuVC;
@property (strong, nonatomic) LoginVC *loginVC;

// detail VCs
@property (weak, nonatomic) DetailVC *detailVC;
@property (strong, nonatomic) ScanVC *scanVC;
@property (strong, nonatomic) ContactListVC *contactListVC;
@property (strong, nonatomic) ShareVC *shareVC;
@property (strong, nonatomic) ContactUsVC *contactUsVC;
@property (strong, nonatomic) AboutVC *aboutVC;
@property (strong, nonatomic) ContactCreateVC *contactCreateVC;

// cardCaptureVC
@property (strong, nonatomic) CardCaptureVC *cardCaptureVC;

@end
