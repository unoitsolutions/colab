//
//  BCRAccountManager.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/26/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "BCRAccountManager.h"
#import "Reachability.h"

NSString* const BCRAccountManagerErrorDomain = @"BCRAccountManagerErrorDomain";

static BCRAccountManager *_defaultManager;
static NSError *BCRAccountManagerLoginError;
static NSError *BCRAccountManagerSyncEventListError;
static NSError *BCRAccountManagerSyncContactListError;

@implementation BCRAccountManager

+ (void)initialize
{
    if (self == [BCRAccountManager class]){
        BCRAccountManagerLoginError = [[NSError alloc] initWithDomain:BCRAccountManagerErrorDomain code:BCRAccountManagerLoginErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Login failed.",NSLocalizedDescriptionKey,nil]];
        BCRAccountManagerSyncEventListError = [[NSError alloc] initWithDomain:BCRAccountManagerErrorDomain code:BCRAccountManagerSyncEventListErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Load event list failed.",NSLocalizedDescriptionKey,nil]];
        BCRAccountManagerSyncContactListError = [[NSError alloc] initWithDomain:BCRAccountManagerErrorDomain code:BCRAccountManagerSyncEventListErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Load contact list failed.",NSLocalizedDescriptionKey,nil]];
    }
}

+ (BCRAccountManager *)defaultManager
{
    if (!_defaultManager) {
        _defaultManager = [[BCRAccountManager alloc] init];
        _defaultManager.isPersistentLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.atevent.BusinessCardReader.BCRAccountManager.isPersistentLogin"];
    }
    return _defaultManager;
}

#pragma mark - Operations

- (void)loadLoggedInAccount
{
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.atevent.BusinessCardReader.BCRAccountManager.loggedInAccount"];
    
    if (info) {
        NSString *userID = [info objectForKey:@"userID"];
        NSString *authKey = [info objectForKey:@"authKey"];
        
        self.loggedInAccount = [[BCRAccount alloc] init];
        self.loggedInAccount.userID = userID;
        self.loggedInAccount.authKey = authKey;
        
        DBAccount *savedAccount = [[DB defaultManager] retrieveAccountWithUserID:userID];
        if (!savedAccount){
            [self clearLoggedInAccount];
            self.loggedInAccount = nil;
            return;
        }
        self.loggedInAccount.companyID = savedAccount.companyID;
        
#ifdef DLOG
        NSLog(@"AccountManager: Saved session loaded");
#endif
    }
    else{
        
#ifdef DLOG
        NSLog(@"AccountManager: No saved session found");
#endif
    }
}

- (void)saveLoggedInAccount:(NSDictionary *)info
{
    [[NSUserDefaults standardUserDefaults] setObject:@{@"authKey": self.loggedInAccount.authKey, @"userID":self.loggedInAccount.userID} forKey:@"com.atevent.BusinessCardReader.BCRAccountManager.loggedInAccount"];
    [[NSUserDefaults standardUserDefaults] setBool:self.isPersistentLogin forKey:@"com.atevent.BusinessCardReader.SessionManager.isPersistentLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearLoggedInAccount
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.atevent.BusinessCardReader.BCRAccountManager.loggedInAccount"];
    [[NSUserDefaults standardUserDefaults] setBool:self.isPersistentLogin forKey:@"com.atevent.BusinessCardReader.SessionManager.isPersistentLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loginWithInfo:(NSDictionary *)info
{
    // get inputs
    self.isPersistentLogin = [(NSNumber *)[info objectForKey:@"isPersistent"] boolValue];
    NSString *rawUsername = [info objectForKey:@"username"];
    NSString *rawPassword = [info objectForKey:@"password"];
    if ([rawUsername isEqualToString:@"demo"] && [rawPassword isEqualToString:@"demo"]) {
        rawUsername = @"adeeb@ironhorseinteractive.com";
        rawPassword = @"adeeb";
    }
    
    // implement
    APIManager *manager = [[APIManager alloc] init];
    manager.delegate = self;
    [manager doLogin:@{@"username":rawUsername,@"password":rawPassword}];
}

- (void)logout
{
    self.loggedInAccount = nil;
    self.currentEvent = nil;
    self.currentContact = nil;
    [self clearLoggedInAccount];
    
    if ([self.delegate respondsToSelector:@selector(manager:didLogoutWithInfo:)]) {
        [self.delegate manager:self didLogoutWithInfo:@{}];
    }
}

- (void)syncEventList
{
    DLOG(@"");
    
    if (!self.loggedInAccount.authKey || !self.loggedInAccount.companyID) {
        // update delegate
        if ([self.delegate respondsToSelector:@selector(manager:didSyncEventListWithInfo:)]) {
            [self.delegate manager:self didSyncEventListWithInfo:@{@"error":BCRAccountManagerSyncEventListError}];
        }
        return;
    }
    
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        // retrieve list from server
        APIManager *manager = [[APIManager alloc] init];
        manager.delegate = self;
        [manager doGetEvents:@{
            @"companyID":self.loggedInAccount.companyID,
            @"authKey":self.loggedInAccount.authKey,
         }];
    }
    else{
#warning implement
        // TODO: retrieve event list from local DB
    }
}

- (void)syncContactList
{
    DLOG(@"");
    
    DLOG(@"| %@ | %@ | %@ |",self.loggedInAccount.userID, self.loggedInAccount.authKey, self.loggedInAccount.companyID);
    
    if (!self.loggedInAccount.userID || !self.loggedInAccount.authKey || !self.loggedInAccount.companyID) {
        // update delegate
        if ([self.delegate respondsToSelector:@selector(manager:didSyncContactListWithInfo:)]) {
            [self.delegate manager:self didSyncContactListWithInfo:@{@"error":BCRAccountManagerSyncContactListError}];
        }
        return;
    }
    
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        // retrieve list from server
        APIManager *manager = [[APIManager alloc] init];
        manager.delegate = self;
        [manager doGetContacts:@{
         @"userID":self.loggedInAccount.userID,
         @"authKey":self.loggedInAccount.authKey,
         @"companyID":self.loggedInAccount.companyID,
         }];
    }
    else{
        // retrieve contact list from local DB
        assert(NO);
    }
}

- (BCREvent *)eventWithEventID:(NSString *)eventID
{
    BCREvent *retVal = nil;
    for (BCREvent *_event in self.eventList) {
        DLOG(@"%@ ==? %@",eventID,_event.eventID);
        if ([_event.eventID isEqualToString:eventID]) {
            retVal = _event;
            break;
        }
    }
    return retVal;
}

#pragma mark - Theme

- (UIColor *)defaultBGColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_bg"]];
}

- (UIColor *)defaultNavbarBGColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_bg"]];
}

- (UIImage *)defaultNavbarMenuBGImage
{
    return [UIImage imageNamed:@"navbar_menu_btn"];
}

- (UIImage *)defaultNavbarCameraBGImage
{
    return [UIImage imageNamed:@"navbar_camera_btn"];
}

#pragma mark - APIManagerDelegate Methods

- (void)APIManager:(APIManager *)manager didLoginWithInfo:(NSDictionary *)info
{
    manager.delegate = nil;
    
    NSError *error = [info objectForKey:@"error"];
    if (!error) {
        NSDictionary *json = [info objectForKey:@"result"];
        
        NSString *authKey = [json objectForKey:@"authKey"];
        
        NSDictionary *userDict = [json objectForKey:@"user"];
        NSString *userID = [userDict objectForKey:@"id"];
        
        NSDictionary *companyDict = [userDict objectForKey:@"company"];
        NSString *companyID = [companyDict objectForKey:@"companyId"];
        
        self.loggedInAccount = [[BCRAccount alloc] init];
        self.loggedInAccount.userID = userID;
        self.loggedInAccount.authKey = authKey;
        self.loggedInAccount.companyID = companyID;
        
        DLOG(@"| %@ | %@ | %@ |",self.loggedInAccount.userID, self.loggedInAccount.authKey, self.loggedInAccount.companyID);
        
        // update db
        [[DB defaultManager] createOrUpdateAccount:self.loggedInAccount];
        
        // debug
        DBAccount *savedAccount = [[DB defaultManager] retrieveAccountWithUserID:userID];
        assert(savedAccount);
        
        // save authKey if necessary
        if (self.isPersistentLogin) {
            [self saveLoggedInAccount:info];
        }else{
            [self clearLoggedInAccount];
        }
        
        // update delegate
        if ([self.delegate respondsToSelector:@selector(manager:didLoginWithInfo:)]) {
            [self.delegate manager:self didLoginWithInfo:@{}];
        }
    }
    else{
        // update delegate
        if ([self.delegate respondsToSelector:@selector(manager:didLoginWithInfo:)]) {
            [self.delegate manager:self didLoginWithInfo:@{@"error":BCRAccountManagerLoginError,@"apiError":error}];
            
        }
    }
}

- (void)APIManager:(APIManager *)manager didGetEventsWithInfo:(NSDictionary *)info
{
    manager.delegate = nil;
    
    NSMutableArray *list = [NSMutableArray array];
    NSError *error = [info objectForKey:@"error"];
    if(error == nil){
        // update list
        NSArray *json = [info objectForKey:@"result"];
        DLOG(@"event count: %d",json.count);
        for (NSDictionary *eventDict in json) {
            BCREvent *event = [[BCREvent alloc] init];
            event.eventID = [eventDict objectForKey:@"id"]; 
            event.eventName = [eventDict objectForKey:@"name"];
            event.description = [eventDict objectForKey:@"description"];
            event.launchDate = [eventDict objectForKey:@"launchDate"];
            event.endDate = [eventDict objectForKey:@"endDate"];
            event.expiryDate = [eventDict objectForKey:@"expiryDate"];
            event.city = [eventDict objectForKey:@"locationCity"];
            event.state = [eventDict objectForKey:@"locationState"];
            event.country = [eventDict objectForKey:@"locationCountry"];
            event.isActive = YES;
            event.topicList = [[[eventDict objectForKey:@"appData"] objectForKey:@"keyTopics"] lastObject];
            event.followupList = [[[eventDict objectForKey:@"appData"] objectForKey:@"followUpActions"] lastObject];
            event.appData = [[eventDict objectForKey:@"appData"] objectForKey:@"id"];
            event.userID = self.loggedInAccount.userID;
            event.companyID = self.loggedInAccount.companyID;
            [list addObject:event];
        }
        
        // update db
        [[DB defaultManager].db beginTransaction];
        [[DB defaultManager] deleteAllEventsForAccount:self.loggedInAccount];
        for (BCREvent *event in list) {
            [[DB defaultManager] createEvent:event forAccount:self.loggedInAccount];
        }
        [[DB defaultManager].db commit];
        
        // update delegate
        if([self.delegate respondsToSelector:@selector(manager:didSyncEventListWithInfo:)]){
            [self.delegate manager:self didSyncEventListWithInfo:@{}];
        }
    }
    else{
        // update delegate
        if([self.delegate respondsToSelector:@selector(manager:didSyncEventListWithInfo:)]){
            [self.delegate manager:self didSyncEventListWithInfo:@{@"error":BCRAccountManagerSyncEventListError,@"apiError":error}];
        }
    }
}

- (void)APIManager:(APIManager *)manager didGetContactsWithInfo:(NSDictionary *)info
{
    manager.delegate = nil;
    
    DLOG(@"info: %@",info);
    NSError *error = [info objectForKey:@"error"];
    if(!error){
        // update db
        NSArray *list = [[info objectForKey:@"result"] objectForKey:@"contacts"];
//        DLOG(@"list: %d",list.count);
        for (NSDictionary *contactDict in list) {
            DBContact *contact = [[DBContact alloc] init];
            contact.contactID = [contactDict objectForKey:@"id"];
            contact.status = BCRContactUploadedStatus;
            contact.eventID = [contactDict objectForKey:@"eventId"];
            for (NSDictionary *fieldDict in [contactDict objectForKey:@"fields"]) {
                NSString *field = [fieldDict objectForKey:@"fieldName"];
                id value = [fieldDict objectForKey:@"value"];
                
                if ([[value class] isSubclassOfClass:[NSNull class]]) continue;
                if (![(NSString *)value isNull]) {
                    if ([field isEqualToString:@"FirstName"]) {
                        contact.firstName = value;
                    }else if ([field isEqualToString:@"LastName"]) {
                        contact.lastName = value;
                    }else if ([field isEqualToString:@"Phone"]) {
                        contact.phone = value;
                    }else if ([field isEqualToString:@"Mobile"]) {
                        contact.mobile = value;
                    }else if ([field isEqualToString:@"OfficeAddress"]) {
                        contact.address = value;
                    }else if ([field isEqualToString:@"City"]) {
                        contact.city = value;
                    }else if ([field isEqualToString:@"ZipCode"]) {
                        contact.zip = value;
                    }else if ([field isEqualToString:@"Country"]) {
                        contact.country = value;
                    }else if ([field isEqualToString:@"FollowUpAction"]) {
                        contact.followupList = value;
                    }else if ([field isEqualToString:@"Topics"]) {
                        contact.topicList = value;
                    }
                }
            }
            BOOL result = [[DB defaultManager] createOrUpdateContact:contact];
//            DLOG(@"updated: %d",result);
        }
        
        // update delegate
        if ([self.delegate respondsToSelector:@selector(manager:didSyncContactListWithInfo:)]) {
            [self.delegate manager:self didSyncContactListWithInfo:@{}];
        }
    }
    else{
        // update delegate
        if ([self.delegate respondsToSelector:@selector(manager:didSyncContactListWithInfo:)]) {
            [self.delegate manager:self didSyncContactListWithInfo:@{@"error":BCRAccountManagerSyncContactListError,@"apiError":error}];
        }
    }
}

@end
