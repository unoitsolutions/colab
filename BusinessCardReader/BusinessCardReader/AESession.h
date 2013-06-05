//
//  AESession.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AECompany;
@class AETheme;

@interface AESession : NSObject

@property (strong, nonatomic) NSString *authToken;
@property (strong, nonatomic) AETheme *theme;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) AECompany *company;

@property (strong, nonatomic) DBAccount *dbAccount;

@end
