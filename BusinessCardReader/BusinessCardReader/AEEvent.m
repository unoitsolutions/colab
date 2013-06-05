//
//  AEEvent.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "AEEvent.h"
#import "AESessionManager.h"
#import "AppDelegate.h"


@implementation AEEvent

- (id)init
{
    self = [super init];
    if(self){
        NSTimeInterval thirtyDays = 60*60*24*30;
    
        self.eventID = @"-1";
        self.eventName = @"";
        self.description = @"";
        self.launchDate = [NSDate dateWithTimeIntervalSinceNow:thirtyDays];
        self.endDate = [NSDate dateWithTimeInterval:thirtyDays sinceDate:self.launchDate];
        self.expiryDate = [NSDate dateWithTimeInterval:thirtyDays sinceDate:self.endDate];
        self.locationCity = @"";
        self.locationState = @"";
        self.locationCountry = @"";
        self.isActive = YES;
        
        self.topicList = [NSMutableArray array];
        self.followUpList = [NSMutableArray array];
    }
    return self;
}

@end
