//
//  AEEvent.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEContact.h"

@class AECompany;

@interface AEEvent : NSObject

@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *launchDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *expiryDate;
@property (strong, nonatomic) NSString *locationCity;
@property (strong, nonatomic) NSString *locationState;
@property (strong, nonatomic) NSString *locationCountry;
@property (nonatomic) BOOL isActive;

@property (strong, nonatomic) NSMutableArray *followUpList;
@property (strong, nonatomic) NSMutableArray *topicList;

@property (weak, nonatomic) AECompany *company;

@property (strong, nonatomic) DBEvent *dbEvent;

@end