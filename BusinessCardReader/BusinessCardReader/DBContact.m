//
//  DBContact.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "DBContact.h"

@implementation DBContact

- (id)init
{
    self = [super init];
    if (self) {
        self.contactID = [NSString stringWithFormat:@"%f",-[[NSDate date] timeIntervalSince1970]];
        self.imageURL = @"";
        self.firstName = @"";
        self.lastName = @"";
        self.phone = @"";
        self.mobile = @"";
        self.fax = @"";
        self.company = @"";
        self.job = @"";
        self.address = @"";
        self.city = @"";
        self.zip = @"";
        self.country = @"";
        self.email = @"";
        self.web = @"";
        self.text = @"";
        self.status = 0;
        self.eventID = @"";
        self.followupList = @"";
        self.topicList= @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DBContact *contact = [[[self class] allocWithZone:zone] init];
    if (contact) {
        contact->_contactID = [_contactID copyWithZone:zone];
        contact->_imageURL  = [_imageURL copyWithZone:zone];
        contact->_firstName  = [_firstName copyWithZone:zone];
        contact->_lastName  = [_lastName copyWithZone:zone];
        contact->_phone  = [_phone copyWithZone:zone];
        contact->_mobile  = [_mobile copyWithZone:zone];
        contact->_fax  = [_fax copyWithZone:zone];
        contact->_company  = [_company copyWithZone:zone];
        contact->_job  = [_job copyWithZone:zone];
        contact->_address  = [_address copyWithZone:zone];
        contact->_city  = [_city copyWithZone:zone];
        contact->_zip  = [_zip copyWithZone:zone];
        contact->_country  = [_country copyWithZone:zone];
        contact->_email  = [_email copyWithZone:zone];
        contact->_web  = [_web copyWithZone:zone];
        contact->_text  = [_text copyWithZone:zone];
        contact->_status = _status;
        contact->_eventID = [_eventID copyWithZone:zone];
        contact->_followupList  = [_followupList copyWithZone:zone];
        contact->_topicList  = [_topicList copyWithZone:zone];
        assert(contact.eventID);
    }
    return contact;
}


@end
