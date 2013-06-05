//
//  AEEventManager.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"
#import "AEEvent.h"

@class AEEventManager;
@protocol AEEventManagerDelegate <NSObject>

- (void)manager:(AEEventManager *)mgr didRetrieveListWithInfo:(NSDictionary *)info;

@end

@interface AEEventManager : NSObject <APIManagerDelegate>

+ (AEEventManager *)defaultManager;

@property (strong, nonatomic) NSMutableArray *eventList;
@property (weak, nonatomic) id<AEEventManagerDelegate> delegate;

// api calls
-(void)retrieveList;

@end
