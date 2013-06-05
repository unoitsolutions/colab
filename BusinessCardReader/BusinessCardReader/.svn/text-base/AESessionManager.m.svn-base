//
//  AESessionManager.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "AESessionManager.h"
#import "AECompany.h"
#import "QueueManager.h"

NSString *AESessionManagerNotificationLoginFinished = @"AESessionManagerNotificaitionLoginFinished";
NSString *AESessionManagerNotificationLogoutFinished = @"AESessionManagerNotificationLogoutFinished";

@interface AESessionManager ()

@end

@implementation AESessionManager

+ (AESessionManager *)defaultManager
{
    static AESessionManager *_defaultManager;
    if (!_defaultManager) {
        _defaultManager = [[AESessionManager alloc] init];
        
        NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.atevent.BusinessCardReader.SessionManager.session"];
        if (info) {
            _defaultManager.session = [[AESession alloc] init];
            _defaultManager.session.authToken = [info objectForKey:@"authKey"];
            _defaultManager.session.userID = [info objectForKey:@"userID"];
            _defaultManager.session.company = [[AECompany alloc] initWithID:[info objectForKey:@"companyID"]];
        }
        _defaultManager.isPersistentLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.atevent.BusinessCardReader.SessionManager.isPersistentLogin"];
        
        DLOG(@"savedSession: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"com.atevent.BusinessCardReader.SessionManager.session"]);
    }
    return _defaultManager;
}

#pragma mark - Operations

- (void)loginWithInfo:(NSDictionary *)info
{
    self.isPersistentLogin = NO;
    NSNumber *val = [info objectForKey:@"isPersistent"];
    self.isPersistentLogin = [val boolValue];
    DLOG(@"isPersistentLogin: %i",self.isPersistentLogin);
    
    NSString *rawUsername = [info objectForKey:@"username"];
    NSString *rawPassword = [info objectForKey:@"password"];
    if ([rawUsername isEqualToString:@"demo"] && [rawPassword isEqualToString:@"demo"]) {
        rawUsername = @"adeeb";
        rawPassword = @"adeeb";
    }
    
    // sha1
    NSString *inputBody = [NSString stringWithFormat:@"%@:%@",[rawUsername sha1],[rawPassword sha1]];

#ifdef MDEBUG
//    inputBody = @"66b7e081c712a961d29ba04ede899e4874432a7f:dedec8ac2204c450d0379cacf6d3e47d13bc8dbd";
#endif
    
    // TODO: implement
    APIManager *manager = [[APIManager alloc] init];
    manager.delegate = self;
    [manager doLogin:@{@"inputBody":inputBody}];
}

- (void)logout
{
    // stop processing
    [[QueueManager defaultManager] doStop];
    
    self.session = nil;
    self.selectedEvent = nil;
    self.currentContact = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.atevent.BusinessCardReader.SessionManager.session"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"com.atevent.BusinessCardReader.SessionManager.isPersistentLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // send notification
    NSNotification *notification = [NSNotification notificationWithName:AESessionManagerNotificationLogoutFinished
                                                                 object:nil
                                                               userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
#pragma mark - APIManagerDelegate Methods

- (void)APIManager:(APIManager *)manager didLoginWithInfo:(NSDictionary *)info
{
    manager.delegate = nil;
    
    if (![info objectForKey:@"error"]) {
        self.session = [[AESession alloc] init];
        self.session.authToken = [info objectForKey:@"authKey"];
        self.session.userID = [info objectForKey:@"userID"];
        self.session.company = [info objectForKey:@"company"];
        
        // update db
        DBAccount *account = [[DBAccount alloc] init];
        account.userID = self.session.userID;
        account.companyID = self.session.company.companyID;
        [[DB defaultManager] createOrUpdateAccount:account];
        self.session.dbAccount = account;
        
        DLOG(@"isPersistentLogin: %i",self.isPersistentLogin);
        if (self.isPersistentLogin) {             
            [[NSUserDefaults standardUserDefaults] setObject:@{@"authKey": [info objectForKey:@"authKey"], @"userID":[info objectForKey:@"userID"], @"companyID":self.session.company.companyID}   forKey:@"com.atevent.BusinessCardReader.SessionManager.session"];
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.atevent.BusinessCardReader.SessionManager.session"];
        }
        [[NSUserDefaults standardUserDefaults] setBool:self.isPersistentLogin forKey:@"com.atevent.BusinessCardReader.SessionManager.isPersistentLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        DLOG(@"savedSession: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"com.atevent.BusinessCardReader.SessionManager.session"]);
    }
    
    // send notification
    NSNotification *notification = [NSNotification notificationWithName:AESessionManagerNotificationLoginFinished
                                                                 object:nil
                                                               userInfo:info];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
