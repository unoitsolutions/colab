//
//  QueueManager.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/3/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCRAccountManager.h"

extern NSString *QueueManagerDidEnqueueContactNotification;
extern NSString *QueueManagerDidDequeueContactNotification;

@interface QueueManager : NSObject <BCRContactDelegate>

@property (strong, nonatomic) NSMutableArray *queue;

+ (QueueManager *)defaultManager;

- (void)loadFromDatabase;

- (void)doStart;
- (void)doPause;
- (void)doContinue;
- (void)doStop;

- (void)enqueueContact:(BCRContact *)contact;
- (void)dequeueContact:(BCRContact *)contact;


@end
