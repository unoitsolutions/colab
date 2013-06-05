//
//  BCREvent.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/25/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "BCREvent.h"

@implementation BCREvent

- (id)initWithDBEvent:(DBEvent *)_event
{
    self = [super init];
    if (self) {
        self.eventID = _event.eventID;
        self.eventName = _event.eventName;
        self.description = _event.description;
        self.launchDate = _event.launchDate;
        self.endDate = _event.endDate;
        self.expiryDate = _event.expiryDate;
        self.city = _event.city;
        self.state = _event.state;
        self.country = _event.country;
        self.isActive = _event.isActive;
        self.topicList = _event.topicList;
        self.followupList = _event.followupList;
        self.appData = _event.appData;
        self.userID = _event.userID;
        self.companyID = _event.companyID;
    }
    return self;
}

- (NSMutableArray *)topicOptionList
{
    NSMutableArray *topicOptionList = [NSMutableArray array];
    NSMutableArray *rawArray = [NSMutableArray arrayWithArray:[self.topicList componentsSeparatedByString:@","]];
    for (NSString *topic in rawArray) {
        [topicOptionList addObject:[topic stringByTrimmingLeadingWhitespace]];
    }
    return topicOptionList;
}

- (NSMutableArray *)followupOptionList
{
    NSMutableArray *followupOptionList = [NSMutableArray array];
    NSMutableArray *rawArray = [NSMutableArray arrayWithArray:[self.followupList componentsSeparatedByString:@","]];
    for (NSString *followup in rawArray) {
        [followupOptionList addObject:[followup stringByTrimmingLeadingWhitespace]];
    }
    return followupOptionList;
}

@end
