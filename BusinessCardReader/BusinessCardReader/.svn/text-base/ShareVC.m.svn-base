//
//  ShareVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Social/Social.h>
#import "ShareVC.h"
#import "MBProgressHUD.h"

@interface ShareVC ()

@end

@implementation ShareVC

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setMenuButton:nil];
    [self setCameraButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)facebookButtonTapped:(id)sender
{
    if(NSClassFromString(@"SLComposeViewController") == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"The installed iOS version in your device does not support this feature. Please upgrade to the latest iOS version and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    SLComposeViewController *composerVC = [SLComposeViewController composeViewControllerForServiceType:
                                           SLServiceTypeFacebook];
    [composerVC addURL:[NSURL URLWithString:SHARE_URL]];
    [composerVC addImage:[UIImage imageNamed:@"ateventIcon1024"]];
    [composerVC setInitialText:@"Check this out!"];
    
    [self presentViewController:composerVC
                       animated:YES
                     completion:^{
                         
                     }];
}

- (IBAction)twitterButtonTapped:(id)sender
{
    if(NSClassFromString(@"SLComposeViewController") == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"The installed iOS version in your device does not support this feature. Please upgrade to the latest iOS version and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    SLComposeViewController *composerVC = [SLComposeViewController composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    [composerVC addURL:[NSURL URLWithString:SHARE_URL]];
    [composerVC addImage:[UIImage imageNamed:@"ateventIcon1024"]];
    [composerVC setInitialText:@"Check this out!"];
    
    [self presentViewController:composerVC
                       animated:YES
                     completion:^{
                         
                     }];
}

- (IBAction)linkedinButtonTapped:(id)sender
{
}

@end
