//
//  ActionPickerVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/13/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ActionPickerVC.h"

@interface ActionPickerVC ()

@end

@implementation ActionPickerVC

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
    
    if(!self.actionList) self.self.actionList = [[BCRAccountManager defaultManager] currentEvent].topicOptionList;
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishButtonTapped:(id)sender
{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if(indexPaths.count > 0){
        BCRContact *contact = (self.contact ? self.contact : [[BCRAccountManager defaultManager] currentContact]);
        for (NSIndexPath *indexPath in indexPaths) {
            if (contact.followupList.length > 0) {
                contact.followupList = [NSString stringWithFormat:@"%@, %@",contact.followupList, [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            }else{
                contact.followupList = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            }
        }
        
        
        if ([self.delegate respondsToSelector:@selector(actionPicker:didFinishPickingFollowupActionsWithInfo:)]) {
            [self.delegate actionPicker:self didFinishPickingFollowupActionsWithInfo:nil];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please select a follow up action."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_row_bg"]];
        cell.backgroundView = view;
        
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_row_highlighted_bg"]];
        cell.selectedBackgroundView = view;
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    }
    
    BCRContact *contact = (self.contact ? self.contact : [[BCRAccountManager defaultManager] currentContact]);
    NSString *action = [self.actionList objectAtIndex:indexPath.row];
    cell.textLabel.text = action;
    for (NSString *_topic in contact.followupOptionList) {
        if ([_topic isEqualToString:action]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
