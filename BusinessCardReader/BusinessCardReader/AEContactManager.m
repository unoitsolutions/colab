//
//  AEContactManager.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/25/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "AEContactManager.h"


@implementation AEContactManager

+ (AEContactManager *)defaultManager
{
    static AEContactManager *_defaultManager;
    if(!_defaultManager){
        _defaultManager = [[AEContactManager alloc] init];
    }
    return _defaultManager;
}

#pragma mark - Operations

- (void)loadContactList
{
}

- (void)addContact:(AEContact *)contact
{
    // only add contact that has submitted status
    assert(contact.status == AEContactLRSSubmittedStatus);
}

@end
