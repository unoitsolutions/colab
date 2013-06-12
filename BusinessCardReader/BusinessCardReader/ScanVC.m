//
//  ScanVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/7/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ScanVC.h"

@interface ScanVC ()

@end

@implementation ScanVC

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
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setMenuButton:nil];
    [self setDropdownButton:nil];
    [self setEventPickerView:nil];
    [self setEventPickerTableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [BCRAccountManager defaultManager].eventList = self.eventList;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.eventList.count <= 0){
                // update UI
                [self _hideLoadingView];
                
                // show alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have no events." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                // init current event
                [BCRAccountManager defaultManager].currentEvent = [self.eventList objectAtIndex:0];
                
                // update UI
                [self _hideLoadingView];
                [self.eventPickerTableView reloadData];
                [self.dropdownButton setTitle:[NSString stringWithFormat:@"  %@",[BCRAccountManager defaultManager].currentEvent.eventName] forState:UIControlStateNormal];
            }
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

- (IBAction)dropdownButtonTapped:(id)sender
{
    if (self.eventList.count <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have no events." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.eventPickerView.frame = self.view.bounds;
    [self.view addSubview:self.eventPickerView];
    [self.eventPickerTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.eventList indexOfObject:[BCRAccountManager defaultManager].currentEvent] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:cameraButtonTapped:)]) {
        [self.delegate detailVC:self cameraButtonTapped:sender];
    }
}

- (IBAction)createContactButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:createContactButtonTapped:)]) {
        [self.delegate detailVC:self createContactButtonTapped:sender];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_row_bg"]];
        cell.backgroundView = view;
        
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_row_highlighted_bg"]];
        cell.selectedBackgroundView = view;
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    }
    
    BCREvent *event = [self.eventList objectAtIndex:indexPath.row];
    cell.textLabel.text = event.eventName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",
                                 (event.city.length>0 ? [NSString stringWithFormat:@" %@",event.city] : @""),
                                 (event.state.length>0 ? [NSString stringWithFormat:@" %@",event.state] : @""),
                                 (event.country.length>0 ? [NSString stringWithFormat:@" %@",event.country] : @"")
                                 ];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // update session
    BCREvent *event = [self.eventList objectAtIndex:indexPath.row];
    [[BCRAccountManager defaultManager] setCurrentEvent:event];
    [self.dropdownButton setTitle:[NSString stringWithFormat:@"  %@",[BCRAccountManager defaultManager].currentEvent.eventName] forState:UIControlStateNormal];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/event/select&eventId=%@",event.eventID]];
    
    // update ui
    [self.eventPickerView removeFromSuperview];
    
    // open camera
//    [self cameraButtonTapped:nil];
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
