//
//  APIManager.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "APIManager.h"
#import "UIColor+Hex.h"

//NSString * const BASE_URL = @"http://192.168.1.64:8888"; // local dev
NSString * const BASE_URL = @"http://ec2-54-234-140-55.compute-1.amazonaws.com"; // dev
//NSString *BASE_URL = @"http://ec2-50-19-138-74.compute-1.amazonaws.com";  // prod
NSString * const APP_NAME = @"bcr";
NSString * const APIManagerErrorDomain = @"APIManagerErrorDomain";

static NSError *APIManagerServerError;
static NSError *APIManagerInvalidResponseError;
static NSError *APIManagerRequestFailedError;
static NSError *APIManagerAuthenticationError;

@implementation APIManager

+ (void)initialize
{
    if (self == [APIManager class]){
        APIManagerServerError = [[NSError alloc] initWithDomain:APIManagerErrorDomain code:APIManagerServerErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Server Error.",NSLocalizedDescriptionKey,nil]];
        APIManagerInvalidResponseError = [[NSError alloc] initWithDomain:APIManagerErrorDomain code:APIManagerInvalidResponseErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Invalid Response Error.",NSLocalizedDescriptionKey,nil]];
        APIManagerRequestFailedError = [[NSError alloc] initWithDomain:APIManagerErrorDomain code:APIManagerRequestFailedErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Request Failed Error.",NSLocalizedDescriptionKey,nil]];
        APIManagerAuthenticationError = [[NSError alloc] initWithDomain:APIManagerErrorDomain code:APIManagerAuthenticationErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Authentication Error.",NSLocalizedDescriptionKey,nil]];
    }
}

#pragma mark - Operations

- (void)doLogin:(NSDictionary *)info
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doLogin/"]];
    
    NSString *username = [info objectForKey:@"username"];
    NSString *password = [info objectForKey:@"password"];
    
    __block NSString *urlString = [NSString stringWithFormat:@"%@/cea/app/%@/login",BASE_URL,APP_NAME];
    
//    NSString *inputBodyString = @"66b7e081c712a961d29ba04ede899e4874432a7f:dedec8ac2204c450d0379cacf6d3e47d13bc8dbd";
    NSString *inputBodyString = [NSString stringWithFormat:@"%@:%@",[username sha1],[password sha1]];
    NSMutableData *inputBody = [NSMutableData dataWithData:[inputBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:inputBody];
    
    ASIBasicBlock completionBlock = ^{
        NSDictionary *info = nil;
        NSInteger statusCode = [request responseStatusCode];
        if ((int)statusCode / 100 >= 4) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doLogin/%@",APIManagerServerError.localizedDescription]];
            
            DLOG(@"url: %@",urlString);
            DLOG(@"status code: %d",statusCode);
            DLOG(@"input body: %@",inputBodyString);
            DLOG(@"response: %@",[request responseString]);

            info = @{@"error":APIManagerServerError};
        }
        else{
            NSError *parseError = nil;
            NSObject *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&parseError];
            if (parseError) {
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doLogin/%@",APIManagerInvalidResponseError.localizedDescription]];
                
                DLOG(@"url: %@",urlString);
                DLOG(@"status code: %d",statusCode);
                DLOG(@"input body: %@",inputBodyString);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"error":APIManagerInvalidResponseError};
            }else{
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doLogin/success"]];
                
                DLOG(@"url: %@",urlString);
                DLOG(@"status code: %d",statusCode);
                DLOG(@"input body: %@",inputBodyString);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"result":json };
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(APIManager:didLoginWithInfo:)]) {
            [self.delegate APIManager:self didLoginWithInfo:info];
        }
    };
    
    [request setCompletionBlock:completionBlock];
    [request setFailedBlock:^{
        DLOG(@"error: %@",[request error]);
        NSError *error = [request error];
        if ([error.domain isEqualToString:NetworkRequestErrorDomain] && error.code == ASIAuthenticationErrorType) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doLogin/%@",APIManagerAuthenticationError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didLoginWithInfo:)]) {
                [self.delegate APIManager:self didLoginWithInfo:@{@"error":APIManagerAuthenticationError}];
            }
        }else{
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doLogin/%@",APIManagerRequestFailedError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didLoginWithInfo:)]) {
                [self.delegate APIManager:self didLoginWithInfo:@{@"error":APIManagerRequestFailedError}];
            }
        }
    }];
    [request startAsynchronous];
}

- (void)doGetEvents:(NSDictionary *)info
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetEvents/"]];
    
    NSString *companyID = [info objectForKey:@"companyID"]; DLOG(@"companyID: %@",companyID);
    NSString *authKey = [info objectForKey:@"authKey"];
    
    __block NSString *urlString = [NSString stringWithFormat:@"%@/cea/company/%@/app/%@/events",BASE_URL,companyID, APP_NAME];
    
    NSError *inputBodyError = nil;
    NSDictionary *inputBodyDictionary = @{@"authKey":authKey};
    __block NSData *inputBodyData = [NSJSONSerialization dataWithJSONObject:inputBodyDictionary options:0 error:&inputBodyError];
    if (inputBodyError) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetEvents/%@",APIManagerRequestFailedError.localizedDescription]];
        
        DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
        DLOG(@"input body error: %@",inputBodyError);
        if ([self.delegate respondsToSelector:@selector(APIManager:didGetEventsWithInfo:)]) {
            [self.delegate APIManager:self didGetEventsWithInfo:@{@"error":APIManagerRequestFailedError}];
        }
        return;
    }
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request appendPostData:inputBodyData];
    
    ASIBasicBlock completionBlock = ^{
        NSDictionary *info = nil;
        NSInteger statusCode = [request responseStatusCode];
        if ((int)statusCode / 100 >= 4) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetEvents/%@",APIManagerServerError.localizedDescription]];
            
            DLOG(@"url: %@",urlString);
            DLOG(@"status code: %d",statusCode);
            DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
            DLOG(@"response: %@",[request responseString]);
            
            info = @{@"error":APIManagerServerError};
        }
        else{
            NSError *parseError = nil;
            NSObject *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&parseError];
            if (parseError) {
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetEvents/%@",APIManagerInvalidResponseError.localizedDescription]];
                
                DLOG(@"url: %@",urlString);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"error":APIManagerInvalidResponseError};
            }else{
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetEvents/success"]];
                
                // debug
                DLOG(@"url: %@",urlString);
                DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"result":json };
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(APIManager:didGetEventsWithInfo:)]) {
            [self.delegate APIManager:self didGetEventsWithInfo:info];
        }
    };
    
    [request setCompletionBlock:completionBlock];
    [request setFailedBlock:^{
        DLOG(@"error: %@",[request error]);
        NSError *error = [request error];
        if ([error.domain isEqualToString:NetworkRequestErrorDomain] && error.code == ASIAuthenticationErrorType) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetEvents/%@",APIManagerAuthenticationError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didGetEventsWithInfo:)]) {
                [self.delegate APIManager:self didGetEventsWithInfo:@{@"error":APIManagerAuthenticationError}];
            }
        }else{
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetEvents/%@",APIManagerRequestFailedError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didGetEventsWithInfo:)]) {
                [self.delegate APIManager:self didGetEventsWithInfo:@{@"error":APIManagerRequestFailedError}];
            }
        }
        
        
    }];
    [request startAsynchronous];
}

- (void)doGetContacts:(NSDictionary *)info
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetContacts/"]];
    
    NSString *userID = [info objectForKey:@"userID"];
    NSString *companyID = [info objectForKey:@"companyID"]; DLOG(@"companyID: %@",companyID);
    NSString *authKey = [info objectForKey:@"authKey"];
    
    __block NSString *urlString = [NSString stringWithFormat:@"%@/cea/company/%@/user/%@/contacts?appType=BCR",BASE_URL,companyID, userID];
    
    NSError *inputBodyError = nil;
    NSDictionary *inputBodyDictionary = @{@"authKey":authKey};
    __block NSData *inputBodyData = [NSJSONSerialization dataWithJSONObject:inputBodyDictionary options:0 error:&inputBodyError];
    if (inputBodyError) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetContacts/%@",APIManagerRequestFailedError.localizedDescription]];
        
        DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
        DLOG(@"input body error: %@",inputBodyError);
        if ([self.delegate respondsToSelector:@selector(APIManager:didGetContactsWithInfo:)]) {
            [self.delegate APIManager:self didGetContactsWithInfo:@{@"error":APIManagerRequestFailedError}];
        }
        return;
    }

    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request appendPostData:inputBodyData];
    
    ASIBasicBlock completionBlock = ^{
        NSDictionary *info = nil;
        NSInteger statusCode = [request responseStatusCode];
        if ((int)statusCode / 100 >= 4) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetContacts/%@",APIManagerServerError.localizedDescription]];
            
            DLOG(@"url: %@",urlString);
            DLOG(@"status code: %d",statusCode);
            DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
            DLOG(@"response: %@",[request responseString]);
            
            info = @{@"error":APIManagerServerError};
        }
        else{
            NSError *parseError = nil;
            NSObject *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&parseError];
            if (parseError) {
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetContacts/%@",APIManagerInvalidResponseError.localizedDescription]];
                
                DLOG(@"url: %@",urlString);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"error":APIManagerInvalidResponseError};
            }else{
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetContacts/success"]];
                
                info = @{@"result":json };
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(APIManager:didGetContactsWithInfo:)]) {
            [self.delegate APIManager:self didGetContactsWithInfo:info];
        }
    };
    
    [request setCompletionBlock:completionBlock];
    [request setFailedBlock:^{
        DLOG(@"error: %@",[request error]);
        NSError *error = [request error];
        if ([error.domain isEqualToString:NetworkRequestErrorDomain] && error.code == ASIAuthenticationErrorType) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetContacts/%@",APIManagerAuthenticationError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didGetContactsWithInfo:)]) {
                [self.delegate APIManager:self didGetContactsWithInfo:@{@"error":APIManagerAuthenticationError}];
            }
        }
        else{
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doGetContacts/%@",APIManagerRequestFailedError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didGetContactsWithInfo:)]) {
                [self.delegate APIManager:self didGetContactsWithInfo:@{@"error":APIManagerRequestFailedError}];
            }
        }
    }];
    [request startAsynchronous];
}

- (void)doSaveContacts:(NSDictionary *)info
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doSaveContacts/"]];
    
    NSString *userID = [info objectForKey:@"userID"];
    NSString *companyID = [info objectForKey:@"companyID"];
    NSString *authKey = [info objectForKey:@"authKey"];
    NSDictionary *app = [info objectForKey:@"app"];
    NSDictionary *event = [info objectForKey:@"event"];
    NSArray *contacts = [info objectForKey:@"contacts"];
    
    __block NSString *urlString = [NSString stringWithFormat:@"%@/cea/company/%@/user/%@/contacts?op=save",BASE_URL,companyID, userID];
    
    NSError *inputBodyError = nil;
    NSDictionary *inputBodyDictionary = @{@"authKey":authKey,@"app":app,@"contacts":contacts,@"event":event};
    __block NSData *inputBodyData = [NSJSONSerialization dataWithJSONObject:inputBodyDictionary options:0 error:&inputBodyError];

    if (inputBodyError) {
        DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
        DLOG(@"input body error: %@",inputBodyError);
        if ([self.delegate respondsToSelector:@selector(APIManager:didSaveContactsWithInfo:)]) {
            [self.delegate APIManager:self didSaveContactsWithInfo:@{@"error":APIManagerRequestFailedError}];
        }
        return;
    }
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request appendPostData:inputBodyData];
    
    ASIBasicBlock completionBlock = ^{
        NSDictionary *info = nil;
        NSInteger statusCode = [request responseStatusCode];
        if ((int)statusCode / 100 >= 4) {
            DLOG(@"url: %@",urlString);
            DLOG(@"status code: %d",statusCode);
            DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
            DLOG(@"response: %@",[request responseString]);
            
            info = @{@"error":APIManagerServerError};
        }
        else{
            NSError *parseError = nil;
            NSObject *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&parseError];
            if (parseError) {
                DLOG(@"url: %@",urlString);
                DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"error":APIManagerInvalidResponseError};
            }else{
                DLOG(@"url: %@",urlString);
                DLOG(@"input body: %@",[[NSString alloc] initWithData:inputBodyData encoding:NSUTF8StringEncoding]);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"result":json };
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(APIManager:didSaveContactsWithInfo:)]) {
            [self.delegate APIManager:self didSaveContactsWithInfo:info];
        }
    };
    [request setCompletionBlock:completionBlock];
    [request setFailedBlock:^{
        DLOG(@"error: %@",[request error]);
        NSError *error = [request error];
        if ([error.domain isEqualToString:NetworkRequestErrorDomain] && error.code == ASIAuthenticationErrorType) {
            if ([self.delegate respondsToSelector:@selector(APIManager:didSaveContactsWithInfo:)]) {
                [self.delegate APIManager:self didSaveContactsWithInfo:@{@"error":APIManagerAuthenticationError}];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(APIManager:didSaveContactsWithInfo:)]) {
                [self.delegate APIManager:self didSaveContactsWithInfo:@{@"error":APIManagerRequestFailedError}];
            }
        }
    }];
    [request startAsynchronous];
}

- (void)doDeleteContacts:(NSDictionary *)info
{
    if ([self.delegate respondsToSelector:@selector(APIManager:didDeleteContactsWithInfo:)]) {
        [self.delegate APIManager:self didDeleteContactsWithInfo:@{@"error":APIManagerRequestFailedError}];
    }
}

- (void)doInitRetrievePassword:(NSDictionary *)info
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/sendEmail/"]];
    
    NSString *emailAddress = [[info objectForKey:@"emailaddress"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    __block NSString *urlString = [NSString stringWithFormat:@"%@/sendEmail/%@",BASE_URL,emailAddress];
//    __block NSString *urlString = [NSString stringWithFormat:@"%@/cea/recoverpassword/%@",BASE_URL,emailAddress];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    
    ASIBasicBlock completionBlock = ^{
        NSDictionary *info = nil;
        NSInteger statusCode = [request responseStatusCode];
        if ((int)statusCode / 100 >= 4) {
            
            DLOG(@"url: %@",urlString);
            DLOG(@"status code: %d",statusCode);
            DLOG(@"response: %@",[request responseString]); 
            
            if ([[request responseString] rangeOfString:@"No account found with that email address"].location != NSNotFound) {
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/sendEmail/%@",APIManagerServerError.localizedDescription]];
                info = @{@"error":APIManagerServerError, @"reason":@"No account found with that email address"};
            }
            else if ([[request responseString] rangeOfString:@"Reset password link has been sent to you."].location != NSNotFound) {
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/sendEmail/success"]];
                info = @{};
            }
            else{
                [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/sendEmail/%@",APIManagerServerError.localizedDescription]];
                info = @{@"error":APIManagerServerError};
            }
        }
        else{
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/sendEmail/success"]];
            info = @{};
        }
        
        if ([self.delegate respondsToSelector:@selector(APIManager:didInitRetrievePasswordWithInfo:)]) {
            [self.delegate APIManager:self didInitRetrievePasswordWithInfo:info];
        }
    };
    
    [request setCompletionBlock:completionBlock];
    [request setFailedBlock:^{
        DLOG(@"error: %@",[request error]);
        NSError *error = [request error];
        if ([error.domain isEqualToString:NetworkRequestErrorDomain] && error.code == ASIAuthenticationErrorType) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/sendEmail/%@",APIManagerAuthenticationError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didInitRetrievePasswordWithInfo:)]) {
                [self.delegate APIManager:self didInitRetrievePasswordWithInfo:@{@"error":APIManagerAuthenticationError}];
            }
        }else{
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/sendEmail/%@",APIManagerRequestFailedError.localizedDescription]];
            
            if ([self.delegate respondsToSelector:@selector(APIManager:didInitRetrievePasswordWithInfo:)]) {
                [self.delegate APIManager:self didInitRetrievePasswordWithInfo:@{@"error":APIManagerRequestFailedError}];
            }
        }
    }];
    [request startAsynchronous];
}

- (void)doCardImageUpload:(NSDictionary *)info
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/api/doCardImageUpload/"]];
    
    NSString *companyID = [info objectForKey:@"companyID"];
    NSString *userID = [info objectForKey:@"userID"];
    NSDictionary *contact = [info objectForKey:@"contact"];
    NSString *authKey = [info objectForKey:@"authKey"];
    NSData *image = [info objectForKey:@"image"];
    
    __block NSString *urlString = [[NSString stringWithFormat:@"%@/cea/company/%@/user/%@/contact/%@/key/%@/contacts?op=readsave",BASE_URL,companyID, userID,contact,authKey] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __block NSData *inputBodyData = image;
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request appendPostData:inputBodyData];
    
    ASIBasicBlock completionBlock = ^{
        NSDictionary *info = nil;
        NSInteger statusCode = [request responseStatusCode];
        if ((int)statusCode / 100 >= 4) {
            DLOG(@"url: %@",urlString);
            DLOG(@"status code: %d",statusCode);
            DLOG(@"response: %@",[request responseString]);
            
            info = @{@"error":APIManagerServerError};
        }
        else{
            NSError *parseError = nil;
            NSObject *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&parseError];
            if (parseError) {
                DLOG(@"url: %@",urlString);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"error":APIManagerInvalidResponseError};
            }else{
                DLOG(@"url: %@",urlString);
                DLOG(@"response: %@",[request responseString]);
                
                info = @{@"result":json };
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(APIManager:didCardImageUpload:)]) {
            [self.delegate APIManager:self didCardImageUpload:info];
        }
    };
    [request setCompletionBlock:completionBlock];
    [request setFailedBlock:^{
        DLOG(@"error: %@",[request error]);
        DLOG(@"urlstring: %@",urlString);
        DLOG(@"url: %@",[request url].absoluteString);
        NSError *error = [request error];
        if ([error.domain isEqualToString:NetworkRequestErrorDomain] && error.code == ASIAuthenticationErrorType) {
            if ([self.delegate respondsToSelector:@selector(APIManager:didCardImageUpload:)]) {
                [self.delegate APIManager:self didCardImageUpload:@{@"error":APIManagerAuthenticationError}];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(APIManager:didCardImageUpload:)]) {
                [self.delegate APIManager:self didCardImageUpload:@{@"error":APIManagerRequestFailedError}];
            }
        }
    }];
    [request startAsynchronous];
}

@end
