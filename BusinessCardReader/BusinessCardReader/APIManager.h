//
//  APIManager.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef enum{
    APIManagerServerErrorType,
    APIManagerInvalidResponseErrorType,
    APIManagerRequestFailedErrorType,
    APIManagerAuthenticationErrorType
} APIManagerErrorType;

@class APIManager;
@protocol APIManagerDelegate <NSObject>

@optional
- (void)APIManager:(APIManager *)manager didLoginWithInfo:(NSDictionary *)info;
- (void)APIManager:(APIManager *)manager didGetEventsWithInfo:(NSDictionary *)info;
- (void)APIManager:(APIManager *)manager didGetContactsWithInfo:(NSDictionary *)info;
- (void)APIManager:(APIManager *)manager didSaveContactsWithInfo:(NSDictionary *)info;
//- (void)APIManager:(APIManager *)manager didLRSUploadWithInfo:(NSDictionary *)info;
- (void)APIManager:(APIManager *)manager didInitRetrievePasswordWithInfo:(NSDictionary *)info;
- (void)APIManager:(APIManager *)manager didCardImageUpload:(NSDictionary *)info;

@end

@interface APIManager : NSObject

@property (weak, nonatomic) id<APIManagerDelegate> delegate;

- (void)doLogin:(NSDictionary *)info;
- (void)doGetEvents:(NSDictionary *)info;
- (void)doGetContacts:(NSDictionary *)info;
- (void)doSaveContacts:(NSDictionary *)info;
- (void)doInitRetrievePassword:(NSDictionary *)info;
- (void)doCardImageUpload:(NSDictionary *)info;

@end
