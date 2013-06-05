//
//  DBAccount.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBRow.h"

@interface DBAccount : DBRow

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *companyID;

@end
