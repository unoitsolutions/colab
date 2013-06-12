//
//  DB.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "DB.h"
#import "BCRContact.h"

@interface DB ()

- (BOOL)_createTables;

@end

@implementation DB

+ (DB *)defaultManager
{
    static DB *_defaultManager = nil;
    if (!_defaultManager) {
        _defaultManager = [[DB alloc] init];
    }
    return _defaultManager;
}

#pragma mark - Operations

- (BOOL)open
{
    // prepare DB
    self.db = [FMDatabase databaseWithPath:DB_PATH];
    self.db.logsErrors = YES;
    self.db.traceExecution = NO;
    [self.db open];
    
    // debug
    DLOG(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
    
    // create table if necessary
    return [self _createTables];
}

#pragma mark - Account

- (BOOL)createAccount:(DBAccount *)account
{
    NSDictionary *argsDict = @{@"userID":account.userID,
                               @"companyID":account.companyID};
    NSString *sql = @"INSERT INTO Account (userID,companyID) VALUES (:userID, :companyID);";
    BOOL result = [self.db executeUpdate:sql withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    return result;
}

- (BOOL)createOrUpdateAccount:(DBAccount *)account
{
    NSDictionary *argsDict = @{@"userID":account.userID,
                               @"companyID":account.companyID};
    NSString *sql = @"INSERT OR REPLACE INTO Account (userID,companyID) VALUES (:userID, coalesce((SELECT companyID from Account where userID = :userID),:companyID));";
    BOOL result = [self.db executeUpdate:sql withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    return result;
}

- (DBAccount *)retrieveAccountWithUserID:(NSString *)userID
{
    DBAccount *account = [[DBAccount alloc] init];
    
    NSDictionary *argsDict = @{@"userID":userID};
    NSString *sql = @"SELECT * FROM Account WHERE userID = :userID";
    
    FMResultSet *result = [self.db executeQuery:sql withParameterDictionary:argsDict];
    while ([result next]) {
        account.userID = [result stringForColumn:@"userID"];
        account.companyID = [result stringForColumn:@"companyID"];
        break;
    }
    if (account.userID.length <= 0 && account.companyID.length <=0) return nil;
    return account;
}

#pragma mark - Event

- (NSMutableArray *)retrieveAllEventsForAccount:(DBAccount *)account
{
    NSMutableArray *list = [NSMutableArray array];
    NSDictionary *argsDict = @{@"userID":account.userID};
    NSString *sql = @"SELECT * FROM Event WHERE userID = :userID";
    
    FMResultSet *result = [self.db executeQuery:sql withParameterDictionary:argsDict];
    while ([result next]) {
        DBEvent *event = [[DBEvent alloc] init];
        event.eventID = [result stringForColumn:@"eventID"];
        event.eventName = [result stringForColumn:@"eventName"];
        event.description = [result stringForColumn:@"description"];
        event.launchDate = [result stringForColumn:@"launchDate"];
        event.endDate = [result stringForColumn:@"endDate"];
        event.expiryDate = [result stringForColumn:@"expiryDate"];
        event.city = [result stringForColumn:@"city"];
        event.state = [result stringForColumn:@"state"];
        event.country = [result stringForColumn:@"country"];
        event.isActive = [result boolForColumn:@"isActive"];
        event.topicList = [result stringForColumn:@"topicList"];
        event.followupList = [result stringForColumn:@"followupList"];
        event.appData = [result stringForColumn:@"appData"];
        event.userID = [result stringForColumn:@"userID"];
        event.companyID = [result stringForColumn:@"companyID"];
        
        [list addObject:event];
        
    }
    return list;
}

- (BOOL)deleteAllEventsForAccount:(DBAccount *)account
{
    NSDictionary *argsDict = @{@"userID":account.userID};
    BOOL result = [self.db executeUpdate:@"DELETE FROM Event WHERE userID = :userID" withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    
    return result;
}

- (BOOL)createEvent:(DBEvent *)event forAccount:(DBAccount *)account
{
    NSDictionary *argsDict = @{@"eventID":event.eventID,
                               @"eventName":event.eventName,
                               @"description":event.description,
                               @"launchDate":event.launchDate,
                               @"endDate":@"",
                               @"expiryDate":event.expiryDate,
                               @"city":event.city,
                               @"state":event.state,
                               @"country":event.country,
                               @"isActive":[NSNumber numberWithBool:event.isActive],
                               @"topicList":event.topicList,
                               @"followupList":event.followupList,
                               @"appData":event.appData,
                               @"userID":account.userID,
                               @"companyID":account.companyID};
    
    BOOL result = [self.db executeUpdate:@"INSERT INTO Event (eventID, eventName, description, launchDate, endDate, expiryDate, city, state, country, isActive, topicList, followupList, appData, userID, companyID) VALUES (:eventID, :eventName, :description, :launchDate, :endDate, :expiryDate, :city, :state, :country, :isActive, :topicList, :followupList, :appData, :userID, :companyID)" withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    
    return result;
}

#pragma mark - Contact

- (BOOL)createContact:(DBContact *)contact forEvent:(DBEvent *)event
{
    contact.eventID = event.eventID;
    
    NSDictionary *argsDict = @{@"contactID":contact.contactID,
                               @"imageURL":contact.imageURL,
                               @"firstName":contact.firstName,
                               @"lastName":contact.lastName,
                               @"phone":contact.phone,
                               @"mobile":contact.mobile,
                               @"fax":contact.fax,
                               @"company":contact.company,
                               @"job":contact.job,
                               @"address":contact.address,
                               @"city":contact.city,
                               @"zip":contact.zip,
                               @"country":contact.country,
                               @"email":contact.email,
                               @"web":contact.web,
                               @"text":contact.text,
                               @"followupList":contact.followupList,
                               @"topicList":contact.topicList,
                               @"status":[NSNumber numberWithInteger:contact.status],
                               @"eventID":contact.eventID};
    DLOG(@"argsDict count: %d",argsDict.count);
    
    BOOL result = [self.db executeUpdate:@"INSERT INTO Contact (contactID, imageURL, firstName, lastName, phone, mobile, fax, company, job, address, city, zip, country, email, web, text, followupList, topicList, status, eventID) VALUES (:contactID, :imageURL, :firstName, :lastName, :phone, :mobile, :fax, :company, :job, :address, :city, :zip, :country, :email, :web, :text, :followupList, :topicList, :status, :eventID)" withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    
//    imageURL = :imageURL,\
//    firstName = :firstName,\
//    lastName = :lastName,\
//    phone = :phone,\
//    mobile = :mobile,\
//    fax = :fax,\
//    company = :company,\
//    job = :job,\
//    address = :address,\
//    city = :city,\
//    zip = :zip,\
//    country = :country,\
//    email = :email,\
//    web = :web,\
//    text = :text,\
//    followupList = :followupList,\
//    topicList = :topicList,\
//    status = :status,\
//    eventID = :eventID\
    
    return result;
}

- (BOOL)updateContact:(DBContact *)contact
{
    NSDictionary *argsDict = @{@"contactID":contact.contactID,
                               @"imageURL":contact.imageURL,
                               @"firstName":contact.firstName,
                               @"lastName":contact.lastName,
                               @"phone":contact.phone,
                               @"mobile":contact.mobile,
                               @"fax":contact.fax,
                               @"company":contact.company,
                               @"job":contact.job,
                               @"address":contact.address,
                               @"city":contact.city,
                               @"zip":contact.zip,
                               @"country":contact.country,
                               @"email":contact.email,
                               @"web":contact.web,
                               @"text":contact.text,
                               @"followupList":contact.followupList,
                               @"topicList":contact.topicList,
                               @"status":[NSNumber numberWithInteger:contact.status],
                               @"eventID":contact.eventID};
    
    BOOL result = [self.db executeUpdate:@"UPDATE Contact SET\
                   imageURL = :imageURL,\
                   firstName = :firstName,\
                   lastName = :lastName,\
                   phone = :phone,\
                   mobile = :mobile,\
                   fax = :fax,\
                   company = :company,\
                   job = :job,\
                   address = :address,\
                   city = :city,\
                   zip = :zip,\
                   country = :country,\
                   email = :email,\
                   web = :web,\
                   text = :text,\
                   followupList = :followupList,\
                   topicList = :topicList,\
                   status = :status,\
                   eventID = :eventID\
                   WHERE contactID = :contactID" withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    
    return result;
}

- (BOOL)createOrUpdateContact:(DBContact *)contact
{
    NSDictionary *argsDict = @{@"contactID":contact.contactID,
                               @"imageURL":contact.imageURL,
                               @"firstName":contact.firstName,
                               @"lastName":contact.lastName,
                               @"phone":contact.phone,
                               @"mobile":contact.mobile,
                               @"fax":contact.fax,
                               @"company":contact.company,
                               @"job":contact.job,
                               @"address":contact.address,
                               @"city":contact.city,
                               @"zip":contact.zip,
                               @"country":contact.country,
                               @"email":contact.email,
                               @"web":contact.web,
                               @"text":contact.text,
                               @"followupList":contact.followupList,
                               @"topicList":contact.topicList,
                               @"status":[NSNumber numberWithInteger:contact.status],
                               @"eventID":contact.eventID};
    
    NSString *sql = @"SELECT contactID FROM Contact WHERE contactID = :contactID";
    FMResultSet *resultSet = [self.db executeQuery:sql withParameterDictionary:argsDict];
    BOOL result = NO;
    if ([resultSet next]) {
        result = [self.db executeUpdate:@"UPDATE Contact SET\
                  imageURL = :imageURL,\
                  firstName = :firstName,\
                  lastName = :lastName,\
                  phone = :phone,\
                  mobile = :mobile,\
                  fax = :fax,\
                  company = :company,\
                  job = :job,\
                  address = :address,\
                  city = :city,\
                  zip = :zip,\
                  country = :country,\
                  email = :email,\
                  web = :web,\
                  text = :text,\
                  followupList = :followupList,\
                  topicList = :topicList,\
                  status = :status,\
                  eventID = :eventID\
                  WHERE contactID = :contactID AND status != 3" withParameterDictionary:argsDict];
        FMDBQuickCheck(result);
        
    }else{
        result = [self.db executeUpdate:@"INSERT INTO Contact (contactID, imageURL, firstName, lastName, phone, mobile, fax, company, job, address, city, zip, country, email, web, text, followupList, topicList, status, eventID) VALUES (:contactID, :imageURL, :firstName, :lastName, :phone, :mobile, :fax, :company, :job, :address, :city, :zip, :country, :email, :web, :text, :followupList, :topicList, :status, :eventID)" withParameterDictionary:argsDict];
        FMDBQuickCheck(result);
    }
    
    return result;
}

- (NSMutableArray *)retrieveAllNonProcessQueueItemContact
{
    NSMutableArray *list = [NSMutableArray array];
    NSString *sql = @"SELECT c.contactID, c.imageURL, c.firstName, c.lastName, c.phone, c.mobile, c.fax, c.company, c.job, c.address, c.city, c.zip, c.country, c.email, c.web, c.text, c.followupList, c.topicList, c.status, c.eventID, p.flag FROM Contact c LEFT OUTER JOIN ProcessQueueItem p ON c.contactID = p.contactID";
    
    FMResultSet *result = [self.db executeQuery:sql withParameterDictionary:nil];
    while ([result next]) {
        NSString *flag = [result stringForColumn:@"flag"];
        if ([flag isEqualToString:@"1"]) continue;
        
        DBContact *contact = [[DBContact alloc] init];
        contact.contactID = [result stringForColumn:@"contactID"];
        contact.imageURL = [result stringForColumn:@"imageURL"];
        contact.firstName = [result stringForColumn:@"firstName"];
        contact.lastName = [result stringForColumn:@"lastName"];
        contact.phone = [result stringForColumn:@"phone"];
        contact.mobile = [result stringForColumn:@"mobile"];
        contact.fax = [result stringForColumn:@"fax"];
        contact.company = [result stringForColumn:@"company"];
        contact.job = [result stringForColumn:@"job"];
        contact.address = [result stringForColumn:@"address"];
        contact.city = [result stringForColumn:@"city"];
        contact.zip = [result stringForColumn:@"zip"];
        contact.country = [result stringForColumn:@"country"];
        contact.email = [result stringForColumn:@"email"];
        contact.web = [result stringForColumn:@"web"];
        contact.text = [result stringForColumn:@"text"];
        contact.followupList = [result stringForColumn:@"followupList"];
        contact.topicList = [result stringForColumn:@"topicList"];
        contact.status = [result intForColumn:@"status"];
        contact.eventID = [result stringForColumn:@"eventID"];
        assert(contact.eventID);
        
        [list addObject:contact];
    }
    return list;
}

- (NSMutableArray *)retrieveAllContactJoinProcessQueueItem
{
    NSMutableArray *list = [NSMutableArray array];
    NSString *sql = @"SELECT * FROM Contact INNER JOIN ProcessQueueItem ON Contact.contactID = ProcessQueueItem.contactID";
    
    FMResultSet *result = [self.db executeQuery:sql withParameterDictionary:nil];
    while ([result next]) {
        DBContact *contact = [[DBContact alloc] init];
        contact.contactID = [result stringForColumn:@"contactID"];
        contact.imageURL = [result stringForColumn:@"imageURL"];
        contact.firstName = [result stringForColumn:@"firstName"];
        contact.lastName = [result stringForColumn:@"lastName"];
        contact.phone = [result stringForColumn:@"phone"];
        contact.mobile = [result stringForColumn:@"mobile"];
        contact.fax = [result stringForColumn:@"fax"];
        contact.company = [result stringForColumn:@"company"];
        contact.job = [result stringForColumn:@"job"];
        contact.address = [result stringForColumn:@"address"];
        contact.city = [result stringForColumn:@"city"];
        contact.zip = [result stringForColumn:@"zip"];
        contact.country = [result stringForColumn:@"country"];
        contact.email = [result stringForColumn:@"email"];
        contact.web = [result stringForColumn:@"web"];
        contact.text = [result stringForColumn:@"text"];
        contact.followupList = [result stringForColumn:@"followupList"];
        contact.topicList = [result stringForColumn:@"topicList"];
        contact.status = [result intForColumn:@"status"];
        contact.eventID = [result stringForColumn:@"eventID"];
        
        [list addObject:contact];
    }
    return list;
}

#pragma mark - ProcessQueueItem

- (BOOL)createProcessQueueItem:(DBProcessQueueItem *)item forContact:(DBContact *)contact
{
    DLOG(@"");
    item.contactID = contact.contactID;
    item.flag = @"1";
    
    NSDictionary *argsDict = @{@"contactID":contact.contactID,@"flag":item.flag};
    NSString *sql = @"INSERT INTO ProcessQueueItem (contactID, flag) VALUES (:contactID, :flag);";
    BOOL result = [self.db executeUpdate:sql withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    return result;
}

- (BOOL)deleteProcessQueueItem:(DBProcessQueueItem *)item forContact:(DBContact *)contact
{
    NSDictionary *argsDict = @{@"contactID":contact.contactID};
    BOOL result = [self.db executeUpdate:@"DELETE FROM ProcessQueueItem WHERE contactID = :contactID" withParameterDictionary:argsDict];
    FMDBQuickCheck(result);
    return result;
}

#pragma mark - Convenience Methods

- (BOOL)_createTables
{
    [self.db beginTransaction];
    
//#define FORCE_DROP_ALL_TABLES YES
    
    // Account
#ifdef FORCE_DROP_ALL_TABLES
    FMDBQuickCheck([self.db executeUpdate:@"DROP TABLE IF EXISTS \"Account\""]);
#endif
    FMDBQuickCheck([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS \"Account\" (\"userID\" VARCHAR NOT NULL  UNIQUE , \"companyID\" VARCHAR NOT NULL )"]);
    
    // Event
#ifdef FORCE_DROP_ALL_TABLES
    FMDBQuickCheck([self.db executeUpdate:@"DROP TABLE IF EXISTS \"Event\""]);
#endif
    FMDBQuickCheck([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS \"Event\" (\"eventID\" VARCHAR,\"eventName\" VARCHAR,\"description\" VARCHAR,\"launchDate\" DATETIME,\"endDate\" DATETIME,\"expiryDate\" DATETIME,\"city\" VARCHAR,\"state\" VARCHAR,\"country\" VARCHAR,\"isActive\" BOOL,\"topicList\" VARCHAR,\"followupList\" VARCHAR,\"appData\" VARCHAR, \"userID\" VARCHAR DEFAULT (null) , \"companyID\" VARCHAR)"]);
    
    // Contact
#ifdef FORCE_DROP_ALL_TABLES
    FMDBQuickCheck([self.db executeUpdate:@"DROP TABLE IF EXISTS \"Contact\""]);
#endif
    FMDBQuickCheck([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS \"Contact\" (\"contactID\" VARCHAR NOT NULL ,\"imageURL\" VARCHAR,\"firstName\" VARCHAR,\"lastName\" VARCHAR,\"phone\" VARCHAR,\"mobile\" VARCHAR,\"fax\" VARCHAR,\"company\" VARCHAR,\"job\" VARCHAR,\"address\" VARCHAR DEFAULT (null),\"city\" VARCHAR,\"zip\" VARCHAR,\"country\" VARCHAR ,\"email\" VARCHAR,\"web\" VARCHAR,\"text\" VARCHAR,\"followupList\" VARCHAR DEFAULT (null) ,\"topicList\" VARCHAR DEFAULT (null) , \"status\" INTEGER NOT NULL  DEFAULT 0 ,\"eventID\" VARCHAR DEFAULT (null))"]);
    
    
    // ProcessQueueItem
#ifdef FORCE_DROP_ALL_TABLES
    FMDBQuickCheck([self.db executeUpdate:@"DROP TABLE IF EXISTS \"ProcessQueueItem\""]);
#endif
    FMDBQuickCheck([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS \"ProcessQueueItem\" (\"contactID\" VARCHAR NOT NULL , \"flag\" VARCHAR DEFAULT '1')"]);
    
    [self.db commit];
    
    return YES;
}

@end
