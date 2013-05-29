//
//  AppDelegate.m
//  Colab
//
//  Created by Pinuno Fuentes on 5/22/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    mainVC.view.backgroundColor = [UIColor lightGrayColor];
    [self.window setRootViewController:mainVC];
    
    // TODO: implement PhotoViewerVC
    
    
    
    // TODO: implement MapVC
    
    
    
    // TODO: implement Forgot Password
    
    
    
    // TODO: implement camera
    
    
    
    
    // email
//    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
//    if (controller) {
//        NSString *emailAddress = @"nstinks0186@gmail.com";
//        NSString *emailSubject = [NSString localizedStringWithFormat:@"Email Subject"];
//        NSString *emailBody = @"Email Body";
//        
//        [controller setSubject:emailSubject];
//        [controller setToRecipients:[NSArray arrayWithObject:emailAddress]];
//        [controller setMessageBody:emailBody isHTML:NO];
//        controller.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>)self;
//        
//        [mainVC presentViewController:controller animated:YES completion:^{
//            
//        }];
//    }
    
    
    // call
//    NSString *phoneNumber = @"3522269617";
//    NSString *urlString = [@"telprompt://" stringByAppendingString:phoneNumber];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
