//
//  ShareVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Social/Social.h>
#import "ShareVC_old.h"
#import "MBProgressHUD.h"

@interface ShareVC_old ()

@end

@implementation ShareVC_old

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
    
//    self.navigationItem.title = @"Share";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"Twitter";
        cell.imageView.image = [UIImage imageNamed:@"Twitter"];
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"Facebook";
        cell.imageView.image = [UIImage imageNamed:@"Facebook"];
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"Tumblr";
        cell.imageView.image = [UIImage imageNamed:@"Tumblr"];
    }else if(indexPath.row == 3){
        cell.textLabel.text = @"Linkedin";
        cell.imageView.image = [UIImage imageNamed:@"Linkedin"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    if(NSClassFromString(@"SLComposeViewController") == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"The installed iOS version in your device does not support this feature. Please upgrade to the latest iOS version and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if(indexPath.row == 0){
            SLComposeViewController *composerVC = [SLComposeViewController composeViewControllerForServiceType:
                                                   SLServiceTypeTwitter];
            [composerVC addURL:[NSURL URLWithString:SHARE_URL]];
            [composerVC addImage:[UIImage imageNamed:@"ateventIcon1024"]];
            [composerVC setInitialText:@"Check this out!"];
            
            [self presentViewController:composerVC
                               animated:YES
                             completion:^{
                                 
                             }];
        }else if(indexPath.row == 1){
            SLComposeViewController *composerVC = [SLComposeViewController composeViewControllerForServiceType:
                                                   SLServiceTypeFacebook];
            [composerVC addURL:[NSURL URLWithString:SHARE_URL]];
            [composerVC addImage:[UIImage imageNamed:@"ateventIcon1024"]];
            [composerVC setInitialText:@"Check this out!"];
            
            [self presentViewController:composerVC
                               animated:YES
                             completion:^{
                                 
                             }];
        }else if(indexPath.row == 2){
            //        cell.textLabel.text = @"Tumblr";
        }else if(indexPath.row == 3){
            //        cell.textLabel.text = @"Linkedin";
        }
    }
    
    
}

@end
