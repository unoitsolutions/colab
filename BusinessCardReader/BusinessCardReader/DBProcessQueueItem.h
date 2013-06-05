//
//  DBProcessQueueItem.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBRow.h"

@interface DBProcessQueueItem : DBRow

@property (strong, nonatomic) NSString *contactID;
@property (strong, nonatomic) NSString *flag;

@end
