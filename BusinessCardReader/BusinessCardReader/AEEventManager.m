//
//  AEEventManager.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "AEEventManager.h"
#import "AESessionManager.h"
#import "AEContactManager.h"
#import "QueueManager.h"

@implementation AEEventManager

+ (AEEventManager *)defaultManager
{
    static AEEventManager *_defaultManager;
    if(!_defaultManager){
        _defaultManager = [[AEEventManager alloc] init];
    }
    return _defaultManager;
}

#pragma mark - Operations

-(void)retrieveList
{
    // request list from server
    APIManager *manager = [[APIManager alloc] init];
    manager.delegate = self;
    [manager doGetEvents:nil];
}

#pragma mark - APIManagerDelegate Methods

- (void)APIManager:(APIManager *)manager didGetEventsWithInfo:(NSDictionary *)info
{
    manager.delegate = nil;
    
    if([info objectForKey:@"error"] == nil){
        // update list
        self.eventList = [info objectForKey:@"eventList"];
        
        // update db
        DBAccount *dbAccount = [AESessionManager defaultManager].session.dbAccount;
        [[DB defaultManager].db beginTransaction];
        [[DB defaultManager] deleteAllEventsForAccount:dbAccount];
        for (AEEvent *event in self.eventList) {
            DBEvent *dbEvent = [[DBEvent alloc] init];
            [[DB defaultManager] createEvent:dbEvent forAccount:dbAccount];
            event.dbEvent = dbEvent;
        }
        [[DB defaultManager].db commit];
        
        // load contact list
        [[AEContactManager defaultManager] loadContactList];
        
        // start queue manager
        [[QueueManager defaultManager] loadFromDatabase];
        [[QueueManager defaultManager] doStart];
        
        // update delegate
        if([self.delegate respondsToSelector:@selector(manager:didRetrieveListWithInfo:)]){
            [self.delegate manager:self didRetrieveListWithInfo:nil];
        }
    }else{
        // TODO: retrieve events from db
        
        // TODO: update delegate
    }
    
    
    
}

@end
