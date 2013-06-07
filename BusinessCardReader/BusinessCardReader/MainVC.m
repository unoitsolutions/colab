//
//  MainVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

- (void)_showScanVC;
- (void)_showContactsVC;
- (void)_showShareVC;
- (void)_showContactUsVC;
- (void)_showAboutVC;
- (void)_showContactCreateVC;

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(AESessionManagerNotificationLogoutFinishedHandler:)
//                                                 name:AESessionManagerNotificationLogoutFinished
//                                               object:nil];
    
    /****************************
     *      Setup MenuVC
     ****************************/
    
    self.menuVC = [[MenuVC alloc] initWithNibName:nil bundle:nil];
    self.menuVC.delegate = self;
    self.menuVC.selectedMenu = 0.0;
    self.menuVC.view.frame = CGRectMake(0, 0, 262, self.view.frame.size.height);
    [self.view addSubview:self.menuVC.view];
    
    /****************************
     *      Setup DetailVC
     ****************************/
    self.scanVC = [[ScanVC alloc] initWithNibName:nil bundle:nil];
    self.scanVC.delegate = self;
    self.scanVC.view.frame = self.view.bounds;
    self.detailVC = self.scanVC;
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.scanVC];
    self.navController.navigationBarHidden = YES;
    self.navController.view.frame = self.view.bounds;
    [self.view addSubview:self.navController.view];
    
    /****************************
     *      Setup LoginVC
     ****************************/
    
    self.loginVC = [[LoginVC alloc] initWithNibName:nil bundle:nil];
    self.loginVC.delegate = self;
    [self.view addSubview:self.loginVC.view];
    
    /****************************
     *      Init Account
     ****************************/
    
    if ([[BCRAccountManager defaultManager] loggedInAccount]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
       // sync contacts
        [[BCRAccountManager defaultManager] setDelegate:self];
        [[BCRAccountManager defaultManager] syncContactList];
        
        // update UI
        CGRect destination = self.loginVC.view.frame;
        destination.origin.y = self.view.frame.size.height;
        self.loginVC.view.frame = destination;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotate
{ 
    return NO;
}

- (BOOL)supportedInterfaceOrientations
{ 
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - MenuVCDelegate

- (void)menuVC:(MenuVC *)vc didSelectMenu:(Menu)menu
{
    
    if (menu == MenuScan) {
        [self _showScanVC];
    }
    else if (menu == MenuContacts) {
        [self _showContactsVC];
    }
    else if (menu == MenuShare) {
        [self _showShareVC];
    }
    else if (menu == MenuContactUs) {
        [self _showContactUsVC];
    }
    else if (menu == MenuAbout) {
        [self _showAboutVC];
    }
    else if (menu == MenuLogout) {
        self.detailVC = self.scanVC;
        [self.navController setViewControllers:@[self.detailVC]];
        
        [self.menuVC.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [[BCRAccountManager defaultManager] setDelegate:self];
        [[BCRAccountManager defaultManager] logout];
    }
    
    [self.detailVC slideLeft];
}

#pragma mark - DetailVCDelegate

- (void)detailVC:(DetailVC *)vc menuBarButtonTapped:(id)sender
{
    CGRect destination = vc.navigationController.view.frame;
    if (destination.origin.x > 0){
        [vc slideLeft];
    }else{
        [vc slideRight];
    }
}

- (void)detailVC:(DetailVC *)vc cameraButtonTapped:(id)sender
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"No camera found on this device."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(![BCRAccountManager defaultManager].currentEvent){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please select an event first."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }else{
        [MBProgressHUD showHUDAddedTo:self.navController.view animated:NO];
        [self performSelector:@selector(_showCardCaptureVC) withObject:nil afterDelay:0.2];
    }
}

- (void)detailVC:(DetailVC *)vc logoutButtonTapped:(id)sender
{
    [[BCRAccountManager defaultManager] setDelegate:self];
    [[BCRAccountManager defaultManager] logout];
}

- (void)detailVC:(DetailVC *)vc createContactButtonTapped:(id)sender
{
#warning uncomment this
//    if(![BCRAccountManager defaultManager].currentEvent){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"Please select an event first."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    [self _showContactCreateVC];
}

#pragma mark - LoginVCDelegate

- (void)loginVC:(LoginVC *)vc didLoginWithInfo:(NSDictionary *)info
{
    assert(![info objectForKey:@"error"]);
    
    CGRect destination = self.loginVC.view.frame;
    destination.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.loginVC.view.frame = destination;
                     }
                     completion:^(BOOL finished) {
                         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                         
                         // sync contacts
                         [[BCRAccountManager defaultManager] setDelegate:self];
                         [[BCRAccountManager defaultManager] syncContactList];
                     }];
}

#pragma mark - BCRAccountManagerDelegate Methods

- (void)manager:(BCRAccountManager *)manager didLogoutWithInfo:(NSDictionary *)info
{
    DLOG(@"info: %@",info);
    manager.delegate = nil;

//    [self.eventsVC.eventList removeAllObjects];
//    [self.contactsVC.contactList removeAllObjects];
//    [self.contactsVC.processingContactList removeAllObjects];

    CGRect destination = self.loginVC.view.frame;
    destination.origin.y -= self.view.frame.size.height;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.loginVC.view.frame = destination;
                         [self.view bringSubviewToFront:self.loginVC.view];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)manager:(BCRAccountManager *)manager didSyncContactListWithInfo:(NSDictionary *)info
{
    DLOG(@"info: %@",info);
    manager.delegate = nil;
    
    // update UI
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if ([info objectForKey:@"error"]) {
        NSError *apiError = [info objectForKey:@"apiError"];
        if (apiError.code == APIManagerAuthenticationErrorType) {
            self.detailVC = self.scanVC;
            [self.navController setViewControllers:@[self.detailVC]];
            
            [self.menuVC.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [[BCRAccountManager defaultManager] setDelegate:self];
            [[BCRAccountManager defaultManager] logout];
            return;
        }
    }
    
    // TODO: start QueueManager
    
    // update ContactsVC
    [self.contactListVC reloadData];
    
    // update UI
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // sync event list
    [[BCRAccountManager defaultManager] setDelegate:self];
    [[BCRAccountManager defaultManager] syncEventList];
}

- (void)manager:(BCRAccountManager *)manager didSyncEventListWithInfo:(NSDictionary *)info
{
    DLOG(@"info: %@",info);
    manager.delegate = nil;
    
    // update UI
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    // error handling
    if ([info objectForKey:@"error"]) {
        NSError *apiError = [info objectForKey:@"apiError"];
        if (apiError.code == APIManagerAuthenticationErrorType) {
            self.detailVC = self.scanVC;
            [self.navController setViewControllers:@[self.detailVC]];
            
            [self.menuVC.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            [[BCRAccountManager defaultManager] setDelegate:self];
            [[BCRAccountManager defaultManager] logout];
            return;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Unable to retrieve event list from server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
    }
    
    [self.scanVC reloadData];
}

#pragma mark - CardCaptureVCDelegate Methods

- (void)cardCaptureVC:(CardCaptureVC *)vc didFinishCardCaptureWithInfo:(NSDictionary *)info
{
    [MBProgressHUD hideAllHUDsForView:self.navController.view animated:NO];
    if ([info objectForKey:@"cancel"]) return;
    
    [self _showContactsVC];
}

#pragma mark - ContactCreateVCDelegate Methods

- (void)contactCreateVC:(ContactCreateVC *)createVC didCreateContact:(BCRContact *)contact
{
    [self _showContactsVC];
}

#pragma mark - Notification Handlers

//- (void)AEThemeChangedNotificationHandler:(NSNotification *)note
//{
//    DLOG(@"");
//    self.navController.navigationBar.tintColor = [[AETheme sharedInstance] defaultMainColor]; 
//    [self.navController.navigationBar setNeedsDisplay];
//    
//}

#pragma mark - Convenience methods

- (void)_showScanVC
{
    if (self.scanVC == nil) {
        self.scanVC = [[ScanVC alloc] initWithNibName:nil bundle:nil];
        self.scanVC.delegate = self;
    }
    self.detailVC = self.scanVC;
    [self.navController setViewControllers:@[self.detailVC]];
}

- (void)_showContactsVC
{
    if(self.contactListVC == nil){
        self.contactListVC = [[ContactListVC alloc] initWithNibName:nil bundle:nil];
        self.contactListVC.delegate = self;
    }
    self.detailVC = self.contactListVC;
    [self.navController setViewControllers:@[self.detailVC]];
}

- (void)_showShareVC
{
    if(self.shareVC == nil){
        self.shareVC = [[ShareVC alloc] initWithNibName:nil bundle:nil];
        self.shareVC.delegate = self;
    }
    self.detailVC = self.shareVC;
    [self.navController setViewControllers:@[self.detailVC]];
}

- (void)_showContactUsVC
{
    if(self.contactUsVC == nil){
        self.contactUsVC = [[ContactUsVC alloc] initWithNibName:nil bundle:nil];
        self.contactUsVC.delegate = self;
    }
    self.detailVC = self.contactUsVC;
    [self.navController setViewControllers:@[self.detailVC]];
}

- (void)_showAboutVC
{
    if(self.aboutVC == nil){
        self.aboutVC = [[AboutVC alloc] initWithNibName:nil bundle:nil];
        self.aboutVC.delegate = self;
    }
    self.detailVC = self.aboutVC;
    [self.navController setViewControllers:@[self.detailVC]];
}

- (void)_showContactCreateVC
{
    if(self.contactCreateVC == nil){
        self.contactCreateVC = [[ContactCreateVC alloc] initWithNibName:nil bundle:nil];
        self.contactCreateVC.delegate = self;
    }
    self.detailVC = self.contactCreateVC;
    [self.navController setViewControllers:@[self.detailVC]];
}

- (void)_showCardCaptureVC
{
    self.cardCaptureVC = [[CardCaptureVC alloc] init];
    self.cardCaptureVC.delegate = self;
    [self.cardCaptureVC presentInViewController:self animated:YES completion:^{
        
    }];
}


@end
