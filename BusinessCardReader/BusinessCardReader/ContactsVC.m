//
//  ContactsVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/21/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactsVC.h"
#import "ContactInfoVC.h"
#import "QueueManager.h"

@interface ContactsVC ()

- (void)_showLoadingView;
- (void)_hideLoadingView;

@end

@implementation ContactsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.title = @"Contacts";
    self.navigationItem.rightBarButtonItem = nil;
    
    self.isReloading = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QueueManagerDidEnqueueContactNotificationHandler:)
                                                 name:QueueManagerDidEnqueueContactNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QueueManagerDidDequeueContactNotificationHandler:)
                                                 name:QueueManagerDidDequeueContactNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/contact/list"]];
    
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
        self.processingContactList = [NSMutableArray array];
        self.contactList = [NSMutableArray arrayWithArray:[[DB defaultManager] retrieveAllNonProcessQueueItemContact]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self _hideLoadingView];
            
            self.isReloading = NO;
        });
    });
}

#pragma mark - Action Methods

- (IBAction)cameraButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:cameraButtonTapped:)]) {
        [self.delegate detailVC:self cameraButtonTapped:sender];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.processingContactList.count;
    }else if (section == 1) {
        return self.contactList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    BCRContact *contact = (indexPath.section == 0 ? [self.processingContactList objectAtIndex:indexPath.row] : [self.contactList objectAtIndex:indexPath.row]);
    
    cell.textLabel.text = (contact.firstName.length > 0 ? contact.firstName : @"<Unnamed>");
    cell.detailTextLabel.text = contact.company;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
//    BCRContact *contact = (indexPath.section == 0 ? [self.processingContactList objectAtIndex:indexPath.row] : [self.contactList objectAtIndex:indexPath.row]);
    
//    ContactInfoVC *vc = [[ContactInfoVC alloc] initWithNibName:nil bundle:nil];
//    vc.contact = contact;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NSNotification Handlers

- (void)QueueManagerDidEnqueueContactNotificationHandler:(NSNotification *)note
{
    [self reloadData];
}

- (void)QueueManagerDidDequeueContactNotificationHandler:(NSNotification *)note
{
    [self reloadData];
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

@end
