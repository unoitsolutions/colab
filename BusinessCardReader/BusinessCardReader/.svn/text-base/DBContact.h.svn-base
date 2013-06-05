//
//  DBContact.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBRow.h"

@interface DBContact : DBRow

@property (strong, nonatomic) NSString *contactID;
@property (strong, nonatomic) NSString *imageURL;

// ocr data
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *job;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *web;
@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSString *followupList;
@property (strong, nonatomic) NSString *topicList;

@property (strong, nonatomic) NSString *eventID;

// for process queue
@property (nonatomic) NSInteger status;

- (id)copyWithZone:(NSZone *)zone;

@end
