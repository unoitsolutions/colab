//
//  TopicPickerVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/13/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "TopicPickerVC.h"

@interface TopicPickerVC ()

@end

@implementation TopicPickerVC

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
    
    self.tableView.allowsMultipleSelection = YES;
    if(!self.topicList) self.topicList = [[BCRAccountManager defaultManager] currentEvent].topicOptionList;
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

- (IBAction)nextButtonTapped:(id)sender
{
    DLOG(@"");
    
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if(indexPaths.count > 0){
        BCRContact *contact = (self.contact ? self.contact : [[BCRAccountManager defaultManager] currentContact]);
        for (NSIndexPath *indexPath in indexPaths) {
            if (contact.topicList.length > 0) {
                contact.topicList = [NSString stringWithFormat:@"%@, %@",contact.topicList, [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            }else{
                contact.topicList = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            }
        }
        
        if([self.delegate respondsToSelector:@selector(topicPicker:didFinishPickingTopicsWithInfo:)]){
            [self.delegate topicPicker:self didFinishPickingTopicsWithInfo:nil];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please select a topic."
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
    return self.topicList.count;
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
    NSString *topic = [self.topicList objectAtIndex:indexPath.row];
    cell.textLabel.text = topic;
    for (NSString *_topic in contact.topicOptionList) {
        if ([_topic isEqualToString:topic]) {
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
