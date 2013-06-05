//
//  EventsVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/20/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "EventsVC.h"
#import "BCRAccountManager.h"
#import "SVPullToRefresh.h"

@interface EventsVC ()

- (void)_showLoadingView;
- (void)_hideLoadingView;

- (void)_doSearchFilter;

@end

@implementation EventsVC

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
//                                             selector:@selector(AESessionManagerNotificationLogoutFinishedHandler:)
//                                                 name:AESessionManagerNotificationLogoutFinished
//                                               object:nil];
    
    // setup pull-to-refresh
    __block EventsVC *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf reloadData];
    }];
    
    self.eventList = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _hideLoadingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTopBar:nil];
    [super viewDidUnload];
}

#pragma mark - Operations

- (void)reloadData
{
    [self _showLoadingView];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        // update list
        self.eventList = [NSMutableArray array];
        NSMutableArray *list = [[DB defaultManager] retrieveAllEventsForAccount:[BCRAccountManager defaultManager].loggedInAccount];
        for (DBEvent *_event in list) {
            BCREvent *event  = [[BCREvent alloc] initWithDBEvent:_event];
            [self.eventList addObject:event];
        }
        self.filteredList = [self.eventList mutableCopy];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // update UI
            [self.tableView reloadData];
            [self _hideLoadingView];
            [self.tableView.pullToRefreshView stopAnimating];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return (tableView == self.searchDisplayController.searchResultsTableView ? self.filteredList.count : self.eventList.count);
    return self.filteredList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    BCREvent *event = [self.filteredList objectAtIndex:indexPath.row];
    cell.textLabel.text = event.eventName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // update session
    BCREvent *event = [self.filteredList objectAtIndex:indexPath.row];
    [[BCRAccountManager defaultManager] setCurrentEvent:event];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/event/select&eventId=%@",event.eventID]];
    
    
    // update ui
    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    [self.navigationItem setLeftBarButtonItem:self.menuBarButton animated:YES];
    
    // open camera
    [self cameraButtonTapped:nil];
}

#pragma mark - UISearchBarDelegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
 shouldReloadTableForSearchString:(NSString *)searchString
{
    DLOG(@"el: %@",self.eventList);
    DLOG(@"fl: %@",self.filteredList);
    [self _doSearchFilter];
    return YES;
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

- (void)_doSearchFilter
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    [self.filteredList removeAllObjects];
    for (BCREvent *event in self.eventList) {
        if (searchString.length > event.eventName.length)
            continue;
        else if([[event.eventName lowercaseString] rangeOfString:[searchString lowercaseString]].location == NSNotFound)
            continue;
        else
            [self.filteredList addObject:event];
    }
}
@end
