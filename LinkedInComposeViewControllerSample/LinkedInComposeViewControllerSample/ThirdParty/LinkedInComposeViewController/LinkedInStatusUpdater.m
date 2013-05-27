//
//  LinkedInStatusUpdater.m
//  LinkedInComposeViewController
//
//  Created by Patricia Marie Cesar on 5/23/13.
//  Copyright (c) 2013 Patricia Marie Cesar. All rights reserved.
//

#import "LinkedInStatusUpdater.h"
#import "LinkedInComposeViewControllerConfig.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "JSONKit.h"

@implementation LinkedInStatusUpdater

@synthesize consumerKey, accessToken;

- (void)postStatus:(NSString *)statusText
{
    NSURL *url = LINKEDIN_POST_URL;
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:self.consumerKey
                                       token:self.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSDictionary alloc]
                             initWithObjectsAndKeys:
                             @"anyone",@"code",nil], @"visibility",
                            statusText, @"comment", nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *updateString = [update JSONString];
    
    [request setHTTPBodyWithString:updateString];
	[request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(linkedInStatusUpdaterResult:didFinish:)
                  didFailSelector:@selector(linkedInStatusUpdaterResult:didFail:)];
    
}

- (void)linkedInStatusUpdaterResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:LINKEDIN_POST_MESSAGE_SUCCESS delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    self.statusUpdaterCompletionHandler(LinkedInStatusUpdaterResultSuccess);
    
}

- (void)linkedInStatusUpdaterResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:LINKEDIN_POST_MESSAGE_FAIL delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    self.statusUpdaterCompletionHandler(LinkedInStatusUpdaterResultFail);
    
}

@end
