//
//  DetailVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "DetailVC.h"
#import "BCRAccountManager.h"

@interface DetailVC ()

@end

@implementation DetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setHidesBottomBarWhenPushed:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(AEThemeChangedNotificationHandler:)
//                                                 name:AEThemeChangedNotification
//                                               object:nil];
    
    self.view.backgroundColor = [[BCRAccountManager defaultManager] defaultBGColor];
    self.navigationBar.backgroundColor = [[BCRAccountManager defaultManager] defaultNavbarBGColor];
    [self.menuButton setBackgroundImage:[[BCRAccountManager defaultManager] defaultNavbarMenuBGImage] forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[[BCRAccountManager defaultManager] defaultNavbarCameraBGImage] forState:UIControlStateNormal];
    
    // menu button
    self.menuBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"]
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(menuBarButtonItemTapped:)];
//    self.navigationBar navigationItem.leftBarButtonItem = self.menuBarButton;
    
    // logo
    UIImageView *view= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ateventIcon114"]];
    [view setContentMode:UIViewContentModeScaleAspectFit];
    view.frame =  CGRectMake(0, 0, 32, 32);
    self.navigationItem.titleView = view;
    
    // logout
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(logoutBarButtonItemTapped:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Operations

- (void)slideRight
{
    CGRect destination = self.navigationController.view.frame;
    destination.origin.x = 258;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.navigationController.view.frame = destination;
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void)slideLeft
{
    CGRect destination = self.navigationController.view.frame;
    destination.origin.x = 0;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.navigationController.view.frame = destination;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Action Methods

- (void)menuBarButtonItemTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:menuBarButtonTapped:)]) {
        [self.delegate detailVC:self menuBarButtonTapped:sender];
    }
}

- (void)logoutBarButtonItemTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:logoutButtonTapped:)]) {
        [self.delegate detailVC:self logoutButtonTapped:sender];
    }
}

#pragma mark - DetailVC protocol Methods

- (UIButton *)menuButton
{
    // this is the default implementation
    return nil;
}

- (UIButton *)cameraButton
{
    // this is the default implementation
    return nil;
}

#pragma mark - Notification Handlers

//- (void)AEThemeChangedNotificationHandler:(NSNotification *)note
//{
//    DLOG(@"");
//    self.view.backgroundColor = [[BCRAccountManager defaultManager] defaultBGColor];
//}

@end
