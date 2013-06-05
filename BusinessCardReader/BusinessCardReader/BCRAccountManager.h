//
//  BCRAccountManager.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/26/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "BCRAccount.h"
#import "BCREvent.h"
#import "BCRContact.h"

typedef enum{
    BCRAccountManagerLoginErrorType,
    BCRAccountManagerSyncEventListErrorType,
    BCRAccountManagerSyncContactListErrorType
} BCRAccountManagerErrorType;

@class BCRAccountManager;
@protocol BCRAccountManagerDelegate <NSObject>

@optional
- (void)manager:(BCRAccountManager *)manager didLoginWithInfo:(NSDictionary *)info;
- (void)manager:(BCRAccountManager *)manager didLogoutWithInfo:(NSDictionary *)info;
- (void)manager:(BCRAccountManager *)manager didSyncEventListWithInfo:(NSDictionary *)info;
- (void)manager:(BCRAccountManager *)manager didSyncContactListWithInfo:(NSDictionary *)info;

@end

@interface BCRAccountManager : NSObject <APIManagerDelegate>

@property (nonatomic, strong) BCRAccount *loggedInAccount;
@property (nonatomic) BOOL isPersistentLogin;
@property (strong, nonatomic) NSMutableArray *eventList;
//@property (strong, nonatomic) NSMutableArray *nonProcessingContactList;
@property (weak, nonatomic) BCREvent *currentEvent;
@property (strong, nonatomic) BCRContact *currentContact;
@property (weak, nonatomic) id<BCRAccountManagerDelegate> delegate;

+ (BCRAccountManager *)defaultManager;

- (void)loadLoggedInAccount;
- (void)saveLoggedInAccount:(NSDictionary *)info;
- (void)clearLoggedInAccount;

- (void)loginWithInfo:(NSDictionary *)info;
- (void)logout;

- (void)syncEventList;
- (void)syncContactList;

- (BCREvent *)eventWithEventID:(NSString *)eventID;

// theme
- (UIColor *)defaultBGColor;
- (UIColor *)defaultNavbarBGColor;
- (UIImage *)defaultNavbarMenuBGImage;
- (UIImage *)defaultNavbarCameraBGImage;

@end
