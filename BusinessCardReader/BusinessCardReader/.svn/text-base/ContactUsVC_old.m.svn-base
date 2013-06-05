//
//  ContactUsVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactUsVC_old.h"

@interface ContactUsVC_old ()

@end

@implementation ContactUsVC_old

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
    
//    self.navigationItem.title = @"Contact Us";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://at-event.com/contact-us/"]]];
    
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.callButton];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.emailButton];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.getDirectionsButton];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.viewMapButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setCallButton:nil];
    [self setEmailButton:nil];
    [self setGetDirectionsButton:nil];
    [self setViewMapButton:nil];
    [super viewDidUnload];
}

#pragma mark - Action Methods

- (IBAction)callButtonTapped:(id)sender
{
}

- (IBAction)emailButtonTapped:(id)sender
{
}

- (IBAction)getDirectionsButtonTapped:(id)sender
{
}

- (IBAction)viewMapButtonTapped:(id)sender
{
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
