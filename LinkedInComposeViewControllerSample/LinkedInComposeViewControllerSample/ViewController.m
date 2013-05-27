//
//  ViewController.m
//  LinkedInComposeViewController
//
//  Created by Patricia Marie Cesar on 5/22/13.
//  Copyright (c) 2013 Patricia Marie Cesar. All rights reserved.
//

#import "ViewController.h"
#import "LinkedInComposeViewController.h"
#import "OAuthLoginView.h"
#import "LinkedInStatusUpdater.h"

@interface ViewController () <LinkedInComposeViewControllerDelegate>
{
    __block LinkedInComposeViewController *composeViewController;
    __block OAuthLoginView *oAuthLoginView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)linkedInButtonPressed:(id)sender
{
    [self showLinkedInComposeSheet];
}


- (void)showLinkedInComposeSheet
{
    composeViewController = [[LinkedInComposeViewController alloc]init];
    composeViewController.hasAttachment = YES;
    composeViewController.delegateLinkedIn = self;
    [composeViewController setPlaceholder:LINKEDIN_SHEET_TEXT_PLACEHOLDER];
    [composeViewController setInitialText:LINKEDIN_SHEET_TEXT_INITIAL];
    
    __block ViewController *vc = self;
    
    composeViewController.linkedInCompletionHandler = ^(LinkedInComposeViewController *composeViewController, LinkedInComposeViewControllerResult result) {
        if(result == LinkedInComposeViewControllerResultDone){
            [vc showLinkedInOAuthPage];
        }
    };
    
    [composeViewController presentFromRootViewController];
}

- (void)showLinkedInOAuthPage
{
    oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    
    [self presentViewController:oAuthLoginView animated:YES completion:^{
    }];
    
    __block LinkedInStatusUpdater *statusUpdater = [[LinkedInStatusUpdater alloc]init];
    
    oAuthLoginView.loginCompletionHandler = ^(OAuthLoginResult result, OAToken *token, OAConsumer *consumer){
        if(result == OAuthPostResultSuccess){
            statusUpdater.consumerKey = consumer;
            statusUpdater.accessToken = token;
            [statusUpdater postStatus:composeViewController.text];
        }
    };
    
    statusUpdater.statusUpdaterCompletionHandler = ^(LinkedInStatusUpdaterResult result){
        [oAuthLoginView dismissModalViewControllerAnimated:YES];
    };
}

#pragma mark - LinkedInComposeViewControllerDelegate method

//- (void)linkedInComposeViewController:(LinkedInComposeViewController *)composeViewController didFinishWithResult:(LinkedInComposeViewControllerResult)result
//{
//    if (result == LinkedInComposeViewControllerResultDone) {
//        [self showLinkedInOAuthPage];
//    }
//}

@end
