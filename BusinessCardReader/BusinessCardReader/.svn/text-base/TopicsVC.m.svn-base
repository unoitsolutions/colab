//
//  TopicsVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/20/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "TopicsVC.h"
#import "FollowupActionsVC.h"
#import "BCRAccountManager.h"

@interface TopicsVC ()

@end

@implementation TopicsVC

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
    
    // logo
    UIImageView *view= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ateventIcon114"]];
    [view setContentMode:UIViewContentModeScaleAspectFit];
    view.frame =  CGRectMake(0, 0, 32, 32);
    self.navigationItem.titleView = view;
    
//    [self.view setBackgroundColor:[[AETheme sharedInstance] defaultBackgroundColor]];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.nextButton];
    
    self.topicList = [[BCRAccountManager defaultManager] currentEvent].topicOptionList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setNextButton:nil];
    [super viewDidUnload];
}

#pragma mark - Action Methods

- (IBAction)nextButtonTapped:(id)sender
{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    if(indexPaths.count > 0){
        BCRContact *contact = [[BCRAccountManager defaultManager] currentContact];
        for (NSIndexPath *indexPath in indexPaths) {
            if (contact.topicList.length > 0) {
                contact.topicList = [NSString stringWithFormat:@"%@, %@",contact.topicList, [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            }else{
                contact.topicList = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            }
        }

        if([self.delegate respondsToSelector:@selector(topicsVC:didFinishPickingTopicsWithInfo:)]){
            [self.delegate topicsVC:self didFinishPickingTopicsWithInfo:nil];
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [self.topicList objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
