//
//  ContactListVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactListVC.h"
#import "ContactDetailVC.h"

@interface ContactListVC ()

@end

@implementation ContactListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contactList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isReloading = NO;
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setMenuButton:nil];
    [self setCameraButton:nil];
    [self setTableView:nil];
    [super viewDidUnload];
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
        NSMutableArray *list = [NSMutableArray arrayWithArray:[[DB defaultManager] retrieveAllNonProcessQueueItemContact]];
        self.contactList = [NSMutableArray array];
        for (DBContact *dbcontact in list) {
            BCRContact *contact = [[BCRContact alloc] initWithDBContact:dbcontact];
            [self.contactList addObject:contact];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"contacts_row_bg"]];
        cell.backgroundView = view;
    }
    
    BCRContact *contact = [self.contactList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",(!contact.firstName.isNull ? [NSString stringWithFormat:@"%@ ",contact.firstName] : @""),contact.lastName];
    cell.detailTextLabel.text = contact.company;
    
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
    vc.contact = contact;
    [self.navigationController pushViewController:vc animated:YES];
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
