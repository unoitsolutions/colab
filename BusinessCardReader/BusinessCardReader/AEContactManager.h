//
//  AEContactManager.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/25/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEContact.h"

@interface AEContactManager : NSObject

@property (strong, nonatomic) NSMutableArray *contactList;

+ (AEContactManager *)defaultManager;

- (void)loadContactList;
- (void)addContact:(AEContact *)contact;

@end
