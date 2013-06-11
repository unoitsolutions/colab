//
//  ContactListVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactListVC.h"
#import "ContactEditVC.h"
#import "ContactDetailVC.h"
#import "ContactListCell.h"
#import <objc/runtime.h>

#define SAVE_CONTACT_TITLE @"Save Contact"
#define SAVE_CONTACT_DESC @"Save contact to device?"
#define DELETE_CONTACT_TITLE @"Delete Contact"
#define CONTACT_KEY @"contact"

@interface ContactListVC () <UITextFieldDelegate, UIAlertViewDelegate, ContactListCellDelegate>

@end

@implementation ContactListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contactList = [NSMutableArray array];
        self.contactListBackUp = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldCharacterChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ContactEditSuccessfulNotificationHandler:) name:ContactEditSuccessfulNotificationName object:nil];
    
    self.isReloading = NO;
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ContactEditSuccessfulNotificationName object:nil];
    
    [self setNavigationBar:nil];
    [self setMenuButton:nil];
    [self setCameraButton:nil];
    [self setTableView:nil];
    [self setSearchTextField:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/contact/list"]];
    [self.searchTextField setText:@""];
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Operations

- (void)reloadData
{
    if (self.isReloading) return;
    self.isReloading = YES;
    
    [self _showLoadingView];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSMutableArray *list = [NSMutableArray arrayWithArray:[[DB defaultManager] retrieveAllNonProcessQueueItemContact]];
        self.contactList = [NSMutableArray array];
        self.contactListBackUp = [NSMutableArray array];
        for (DBContact *dbcontact in list) {
            BCRContact *contact = [[BCRContact alloc] initWithDBContact:dbcontact];
            
            if (contact.status == BCRContactDeletedStatus) {
                continue;
            }
            
            [self.contactList addObject:contact];
            [self.contactListBackUp addObject:contact];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self _hideLoadingView];
            
            self.isReloading = NO;
        });
    });
}

#pragma mark - Action Methods

- (IBAction)menuButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:menuBarButtonTapped:)]) {
        [self.delegate detailVC:self menuBarButtonTapped:sender];
    }
}

- (IBAction)cameraButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:cameraButtonTapped:)]) {
        [self.delegate detailVC:self cameraButtonTapped:sender];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ContactListCell *cell = (ContactListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    BCRContact *contact = [self.contactList objectAtIndex:indexPath.row];
    [cell setUpCellContents:contact];
    cell.swipeListener = self;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    BCRContact *contact = [self.contactList objectAtIndex:indexPath.row];

    ContactDetailVC *vc = [[ContactDetailVC alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self.delegate;
    vc.contact = contact;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Convenience Methods

- (void)_showLoadingView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [self.menuBarButton setEnabled:NO];
}

- (void)_hideLoadingView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.menuBarButton setEnabled:YES];
}

#pragma mark - Search 

- (void)textFieldCharacterChange:(NSNotification *)notification
{
    if([notification.object isKindOfClass:[UITextField class]]){
        self.contactList = self.contactListBackUp;
        self.contactList = [self searchContactListWithString:[notification.object text]];
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)searchContactListWithString:(NSString *)keyWord
{
    if([keyWord length] == 0){
        return self.contactList;
    }else{
        
        NSMutableArray *searchTableData = [[NSMutableArray alloc] init];
        for (BCRContact *contact in self.contactList) {
            NSString *contactName = [contact.firstName stringByAppendingFormat:@" %@", contact.lastName];
            if([contactName containsStringNoCase:keyWord])
                [searchTableData addObject:contact];
            
        }
        return searchTableData;
    }
}

#pragma mark - ContactListCell method

// Save contact
- (void)didSwipeRight:(ContactListCell *)cell;
{
    UIAlertView *save = [[UIAlertView alloc]
                         initWithTitle:SAVE_CONTACT_TITLE
                         message:SAVE_CONTACT_DESC
                         delegate:self
                         cancelButtonTitle:@"No"
                         otherButtonTitles:@"Yes", nil];
    [save show];
    objc_setAssociatedObject(save, CONTACT_KEY, cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Delete contact
- (void)didSwipeLeft:(ContactListCell *)cell;
{
    UIAlertView *delete = [[UIAlertView alloc]
                           initWithTitle:DELETE_CONTACT_TITLE
                           message:[NSString stringWithFormat:@"Are you sure you want to delete %@ %@ ?", cell.contact.firstName, cell.contact.lastName]
                           delegate:self
                           cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [delete show];
    objc_setAssociatedObject(delete, CONTACT_KEY, cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UIAlertView delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ContactListCell *cell = objc_getAssociatedObject(alertView, CONTACT_KEY);
    
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    
    if(buttonIndex == 1) {
        if([alertView.title isEqualToString:DELETE_CONTACT_TITLE]) {
            /* insert code here for deleting contact */
//            [self.contactListBackUp removeObjectAtIndex:indexPath.row];
//            [self.contactList removeObjectAtIndex:indexPath.row];
//            [self.tableView reloadData];
            
            // update status
            BCRContact *contact = [self.contactList objectAtIndex:indexPath.row];
            [contact setStatus:BCRContactDeletedStatus];
            [[DB defaultManager] updateContact:contact];
            [self reloadData];

        }
        else if([alertView.title isEqualToString:SAVE_CONTACT_TITLE]){
            // SAVE
            NSError *error = [cell.contact saveToDevice];
            if(!error){
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/contact/list/saveToDevice"]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Contact is saved to device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/contact/list/saveToDevice?error=%@",[error description]]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save contact to device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
    }
}

#pragma mark - ContactEditSuccessfulNotificationHandler methods

- (void)ContactEditSuccessfulNotificationHandler:(NSNotification *)note
{
    // TODO: reload data
    DLOG(@"RELOAD!!!!!!!!!!!!!!!!!!!!!!");
}

@end
