//
//  AppDelegate.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "AppDelegate.h"
#import "TSMiniWebBrowser.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // init db
    [[DB defaultManager] open];
    
    // init session
    [[BCRAccountManager defaultManager] loadLoggedInAccount];
    
    // setup testflight
#ifdef MDEBUG
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    [TestFlight takeOff:@"09a15a2a-722a-417d-ae11-b77b32016604"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    self.mainVC = [[MainVC alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:self.mainVC];
    
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
    DLOG(@"isPersistentLogin: %i",[BCRAccountManager defaultManager].isPersistentLogin);
    if (![BCRAccountManager defaultManager].isPersistentLogin) {
        [[BCRAccountManager defaultManager] logout];
    }
}

- (BOOL)openURL:(NSURL *)url
{
    if ([[url absoluteString] isEqualToString:@"http://admin.at-event.com/terms"]) {
        TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:url];
        webBrowser.mode = TSMiniWebBrowserModeNavigation;
        webBrowser.barStyle = UIBarStyleBlack;
        
        [self.mainVC.navController pushViewController:webBrowser animated:YES];
        return YES;
    }
    
    return NO;
}

@end
