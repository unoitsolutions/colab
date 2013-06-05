//
//  DB.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DBAccount.h"
#import "DBEvent.h"
#import "DBEvent.h"
#import "DBContact.h"
#import "DBProcessQueueItem.h"

@interface DB : NSObject

@property (strong, nonatomic) FMDatabase *db;

+ (DB *)defaultManager;

- (BOOL)open;

// Account
- (BOOL)createAccount:(DBAccount *)account;
- (BOOL)createOrUpdateAccount:(DBAccount *)account;
- (DBAccount *)retrieveAccountWithUserID:(NSString *)userID;

// Event
- (NSMutableArray *)retrieveAllEventsForAccount:(DBAccount *)account;
- (BOOL)deleteAllEventsForAccount:(DBAccount *)account;
- (BOOL)createEvent:(DBEvent *)event forAccount:(DBAccount *)account;

// Contact
- (BOOL)createContact:(DBContact *)contact forEvent:(DBEvent *)event;
- (BOOL)updateContact:(DBContact *)contact;
- (BOOL)createOrUpdateContact:(DBContact *)contact;
- (NSMutableArray *)retrieveAllNonProcessQueueItemContact;
- (NSMutableArray *)retrieveAllContactJoinProcessQueueItem;

// ProcessQueueItem
- (BOOL)createProcessQueueItem:(DBProcessQueueItem *)item forContact:(DBContact *)contact;
- (BOOL)deleteProcessQueueItem:(DBProcessQueueItem *)item forContact:(DBContact *)contact;

@end

/********************
 *  Account
 ********************/
