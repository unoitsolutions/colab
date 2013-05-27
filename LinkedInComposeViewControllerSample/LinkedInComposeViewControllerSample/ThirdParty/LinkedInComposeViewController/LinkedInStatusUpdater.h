//
//  LinkedInStatusUpdater.h
//  LinkedInComposeViewController
//
//  Created by Patricia Marie Cesar on 5/23/13.
//  Copyright (c) 2013 Patricia Marie Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAToken.h"
#import "OAConsumer.h"


typedef NS_ENUM(NSInteger, LinkedInStatusUpdaterResult) {
    LinkedInStatusUpdaterResultFail,
    LinkedInStatusUpdaterResultSuccess
};

typedef void (^LinkedInStatusUpdaterCompletionHandler)(LinkedInStatusUpdaterResult result);

@interface LinkedInStatusUpdater : NSObject

@property (strong, nonatomic) OAConsumer *consumerKey;
@property (strong, nonatomic) OAToken *accessToken;
@property (nonatomic, copy, readwrite) LinkedInStatusUpdaterCompletionHandler statusUpdaterCompletionHandler;

- (void)postStatus:(NSString *)statusText;

@end
