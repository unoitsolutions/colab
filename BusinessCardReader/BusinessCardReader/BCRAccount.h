//
//  BCRAccount.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/25/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "DBAccount.h"

@interface BCRAccount : DBAccount

@property (strong, nonatomic) NSString *authKey;

@end
