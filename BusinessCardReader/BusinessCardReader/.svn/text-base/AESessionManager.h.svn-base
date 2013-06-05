//
//  AESessionManager.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "AESession.h"
#import "AEEvent.h"
#import "AEContact.h"

extern NSString *AESessionManagerNotificationLoginFinished;
extern NSString *AESessionManagerNotificationLogoutFinished;

@interface AESessionManager : NSObject <APIManagerDelegate>

@property (strong, nonatomic) AESession *session;
@property (strong, nonatomic) AEEvent *selectedEvent;
@property (strong, nonatomic) AEContact *currentContact;
@property (strong, nonatomic) NSMutableArray *cachedContactList;
@property (nonatomic) BOOL isPersistentLogin;

+ (AESessionManager *)defaultManager;

/**
 *  Operations
 */

- (void)loginWithInfo:(NSDictionary *)info;
- (void)logout;



@end
