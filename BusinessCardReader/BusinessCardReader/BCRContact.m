//
//  BCRContact.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/25/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "BCRContact.h"
#import "XMLReader.h"
#import "BCRAccountManager.h"
#import <AddressBookUI/AddressBookUI.h>

NSString* const BCRContactServiceOperationErrorDomain = @"BCRContactServiceOperationErrorDomain";

//static NSError *BCRContactOCRProcessingError;
//static NSError *BCRContactOCRProcessingInvalidImageError;
static NSError *BCRContactContactUploadError;
//static NSError *BCRContactLRSUploadError;
static NSError *BCRContactCardImageUploadError;

@implementation BCRContact

- (id)init
{
    if(self = [super init]){
        _topicOptionList = [[NSMutableArray alloc] init];
        _followupOptionList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithDBContact:(DBContact *)contact
{
    self = [self init];
    if (self) {
        self.contactID = contact.contactID;
        self.imageURL = contact.imageURL;
        self.firstName = contact.firstName;
        self.lastName = contact.lastName;
        self.phone = contact.phone;
        self.mobile = contact.mobile;
        self.fax = contact.fax;
        self.company = contact.company;
        self.job = contact.job;
        self.address = contact.address;
        self.city = contact.city;
        self.zip = contact.zip;
        self.country = contact.country;
        self.email = contact.email;
        self.web = contact.web;
        self.text = contact.text;
        self.followupList = contact.followupList;
        self.topicList = contact.topicList;
        self.status = contact.status;
        self.eventID = contact.eventID;
        assert(self.eventID);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    BCRContact *contact = [super copyWithZone:zone];
    contact->_topicOptionList = [_topicOptionList mutableCopyWithZone:zone];
    contact->_followupOptionList = [_followupOptionList mutableCopyWithZone:zone];
    return contact;
}

+ (void)initialize
{
    if (self == [BCRContact class]){
//        BCRContactOCRProcessingError = [[NSError alloc] initWithDomain:BCRContactServiceOperationErrorDomain code:BCRContactOCRProcessingErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OCR Process Failed",NSLocalizedDescriptionKey,nil]];
//        BCRContactOCRProcessingInvalidImageError = [[NSError alloc] initWithDomain:BCRContactServiceOperationErrorDomain code:BCRContactOCRProcessingInvalidImageErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Business card not found on image",NSLocalizedDescriptionKey,nil]];
        BCRContactContactUploadError = [[NSError alloc] initWithDomain:BCRContactServiceOperationErrorDomain code:BCRContactContactUploadErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Contact Upload Failed",NSLocalizedDescriptionKey,nil]];
//        BCRContactLRSUploadError = [[NSError alloc] initWithDomain:BCRContactServiceOperationErrorDomain code:BCRContactLRSUploadErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Lead Routing System Upload Failed",NSLocalizedDescriptionKey,nil]];
        BCRContactCardImageUploadError = [[NSError alloc] initWithDomain:BCRContactServiceOperationErrorDomain code:BCRContactCardImageUploadErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Business Card Upload Failed",NSLocalizedDescriptionKey,nil]];
    }
}

#pragma mark - Setters & Getters

- (NSMutableArray *)topicOptionList
{
    [_topicOptionList removeAllObjects];
    NSMutableArray *rawArray = [NSMutableArray arrayWithArray:[self.topicList componentsSeparatedByString:@","]];
    for (NSString *topic in rawArray) {
        [_topicOptionList addObject:[topic stringByTrimmingLeadingWhitespace]];
    }
    return _topicOptionList;
}

- (NSMutableArray *)followupOptionList
{
    [_followupOptionList removeAllObjects];
    NSMutableArray *rawArray = [NSMutableArray arrayWithArray:[self.followupList componentsSeparatedByString:@","]];
    for (NSString *topic in rawArray) {
        [_followupOptionList addObject:[topic stringByTrimmingLeadingWhitespace]];
    }
    return _followupOptionList;
}

- (UIImage *)image
{
    if (!_image) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileName = [NSString stringWithFormat:@"%@.png",self.contactID];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (result) {
            self.image = [UIImage imageWithContentsOfFile:filePath];
        }
    }
    return _image;
}

#pragma mark - Operations

- (void)updateImage:(UIImage *)image
{
    // save image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [NSString stringWithFormat:@"%@.png",self.contactID];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    // debug image save
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    assert(result);
    
    UIImage *__image = [UIImage imageWithContentsOfFile:filePath];
    self.imageURL = [[NSURL fileURLWithPath:filePath] absoluteString];
    self.image = __image;
}

- (void)populatePropertiesWithData:(NSData *)xmlData
{
    NSString* xmlString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    DLOG(@"xml: %@",xmlString);
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[XMLReader dictionaryForXMLString:xmlString error:nil]];
    DLOG(@"dict: %@",dataDict);
    
    NSArray *fields = (NSArray *)[[[dataDict objectForKey:@"document"] objectForKey:@"businessCard"] objectForKey:@"field"];
    for (NSDictionary *field in fields) {
        NSString *fieldType = [field objectForKey:@"type"];
        NSString *fieldValue = [(NSString *)[[field objectForKey:@"value"] objectForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //        DLOG(@"%@: %@",fieldType, fieldValue);
        
        if([fieldType isEqualToString:@"Name"]){
            self.firstName = fieldValue;
        }else if([fieldType isEqualToString:@"Phone"]){
            if (self.phone.length > 0) {
                self.phone = [NSString stringWithFormat:@"%@ | %@",self.phone, fieldValue];
            }else{
                self.phone = fieldValue;
            }
        }else if([fieldType isEqualToString:@"Mobile"]){
            if (self.mobile.length > 0) {
                self.mobile = [NSString stringWithFormat:@"%@ | %@",self.mobile, fieldValue];
            }else{
                self.mobile = fieldValue;
            }
        }else if([fieldType isEqualToString:@"Fax"]){
            if (self.fax.length > 0) {
                self.fax = [NSString stringWithFormat:@"%@ | %@",self.fax, fieldValue];
            }else{
                self.fax = fieldValue;
            }
        }else if([fieldType isEqualToString:@"Company"]){
            self.company = fieldValue;
        }else if([fieldType isEqualToString:@"Job"]){
            self.job = fieldValue;
        }else if([fieldType isEqualToString:@"Address"]){
            if (self.address.length > 0) {
                self.address = [NSString stringWithFormat:@"%@ | %@",self.address, fieldValue];
            }else{
                self.address = fieldValue;
            }
        }else if([fieldType isEqualToString:@"Email"]){
            if (self.email.length > 0) {
                self.email = [NSString stringWithFormat:@"%@ | %@",self.email, fieldValue];
            }else{
                self.email = fieldValue;
            }
        }else if([fieldType isEqualToString:@"Web"]){
            if (self.web.length > 0) {
                self.web = [NSString stringWithFormat:@"%@ | %@",self.web, fieldValue];
            }else{
                self.web = fieldValue;
            }
        }else if([fieldType isEqualToString:@"Text"]){
        }
    }
    
}

- (NSError *)saveToDevice
{
    // initiate address book
    ABAddressBookRef addressBook;
    addressBook = ABAddressBookCreate();
    
    CFErrorRef error = NULL;
    BOOL success = NO;
    
    // create a record
    ABRecordRef aRecord = ABPersonCreate();
    
    // set first name
    if (self.firstName.length > 0) {
        success = ABRecordSetValue(aRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.firstName), &error);
        if (!success) {
            CFRelease(addressBook);
            return (NSError *)CFBridgingRelease(error);
        }
    }
    
    
    // set last name
    if (self.lastName.length > 0) {
        success = ABRecordSetValue(aRecord, kABPersonLastNameProperty, (__bridge CFTypeRef)(self.lastName), &error);
        if (!success) {
            CFRelease(addressBook);
            return (NSError *)CFBridgingRelease(error);
        }
    } 
    
    // set email
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonEmailProperty);
    ABMultiValueIdentifier multivalueIdentifier = NSIntegerMin;
    if (self.email.length > 0) {
        success = ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(self.email), kABHomeLabel, &multivalueIdentifier);
        if (!success) {
            CFRelease(multi);
            CFRelease(addressBook);
            return (NSError *)CFBridgingRelease(error);
        }
    } 
    success = ABRecordSetValue(aRecord, kABPersonEmailProperty, multi, &error);
    if (!success) {
        CFRelease(multi);
        CFRelease(addressBook);
        return (NSError *)CFBridgingRelease(error);
    }
    CFRelease(multi);
    
    // set phone numbers
    multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    if (self.phone.length > 0) {
        success = ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(self.phone), kABHomeLabel, &multivalueIdentifier);
        if (!success) {
            CFRelease(multi);
            CFRelease(addressBook);
            return (NSError *)CFBridgingRelease(error);
        }
    }
    if (self.fax.length > 0) {
        success = ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(self.fax), kABOtherLabel, &multivalueIdentifier);
        if (!success) {
            CFRelease(multi);
            CFRelease(addressBook);
            return (NSError *)CFBridgingRelease(error);
        }
    }
    if (self.mobile.length > 0) {
        success = ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(self.mobile), kABPersonPhoneMobileLabel, &multivalueIdentifier);
        if (!success) {
            CFRelease(multi);
            CFRelease(addressBook);
            return (NSError *)CFBridgingRelease(error);
        }
    }
    success = ABRecordSetValue(aRecord, kABPersonPhoneProperty, multi, &error);
    if (!success) {
        CFRelease(multi);
        CFRelease(addressBook);
        return (NSError *)CFBridgingRelease(error);
    }
    CFRelease(multi);
    
    // set address
    ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
    CFStringRef keys[5];
    CFStringRef values[5];
    keys[0] = kABPersonAddressStreetKey;
    keys[1] = kABPersonAddressCityKey; 
    keys[2] = kABPersonAddressZIPKey;
    keys[3] = kABPersonAddressCountryKey;
    values[0] = (__bridge CFTypeRef)(self.address.length > 0 ? self.address : @"");
    values[1] = (__bridge CFTypeRef)(self.city.length > 0 ? self.city : @"");
    values[2] = (__bridge CFTypeRef)(self.zip.length > 0 ? self.zip : @"");
    values[3] = (__bridge CFTypeRef)(self.country.length > 0 ? self.country : @"");
    CFDictionaryRef aDict = CFDictionaryCreate(
                                               kCFAllocatorDefault,
                                               (void *)keys,
                                               (void *)values,
                                               4,
                                               &kCFCopyStringDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks
                                               );
    
    ABMultiValueIdentifier identifier;
    success = ABMultiValueAddValueAndLabel(address, aDict, kABHomeLabel, &identifier);
    if (!success) {
        CFRelease(aDict);
        CFRelease(address);
        CFRelease(addressBook);
        return (NSError *)CFBridgingRelease(error);
    }
    CFRelease(aDict);
    success = ABRecordSetValue(aRecord, kABPersonAddressProperty, address, &error);
    if (!success) {
        CFRelease(address);
        CFRelease(addressBook);
        return (NSError *)CFBridgingRelease(error);
    }
    CFRelease(address);
    
    // add record to address book
    success = ABAddressBookAddRecord(addressBook, aRecord, &error);
    if (!success) {
        CFRelease(addressBook);
        return (NSError *)CFBridgingRelease(error);
    }
    
    // save changes to address book
    success = ABAddressBookSave(addressBook, &error);
    if (!success) {
        CFRelease(addressBook);
        return (NSError *)CFBridgingRelease(error);
    }
    
    CFRelease(addressBook);
    NSLog(@"saved");
    return nil;
}



#pragma mark - Service Operations

//- (void)doOCRProcessing
//{
//    DLOG(@"");
//    assert(!self.client);
//
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        self.client = [[Client alloc] initWithApplicationID:OCR_APP_ID password:OCR_APP_PASSWORD];
//        [self.client setDelegate:self];
//        ProcessingParams* params = [[ProcessingParams alloc] init];
//        [self.client processBusinessCard:self.image withParams:params];
//    });
//}
//
//- (void)doLRSUpload
//{
//#warning implement
//    // TODO: implement
//    assert(NO);
//
//    // update delegate
//    if ([self.delegate respondsToSelector:@selector(contact:didFinishLRSUploadWithInfo:)]) {
//        [self.delegate contact:self didFinishLRSUploadWithInfo:@{@"error":BCRContactLRSUploadError}];
//    }
//}

- (void)doContactUpload
{
    APIManager *manager = [[APIManager alloc] init];
    manager.delegate = self;
    
    [manager doSaveContacts:@{
     @"userID":[[BCRAccountManager defaultManager] loggedInAccount].userID,
     @"companyID":[[BCRAccountManager defaultManager] loggedInAccount].companyID,
     @"authKey":[[BCRAccountManager defaultManager] loggedInAccount].authKey,
     @"app":@{@"id":@"1",@"appName":@"BCR"},
     @"event":@{@"id":[[BCRAccountManager defaultManager] currentEvent].eventID,@"company":@{@"id":[[BCRAccountManager defaultManager] loggedInAccount].companyID},@"appData":@{@"id":[[BCRAccountManager defaultManager] currentEvent].appData}},
     @"contacts":@[@{
     @"id":(self.status == BCRContactCreatedStatus ? @"-1" : self.contactID),
     @"eventId":(self.eventID.length <= 0 ? [[BCRAccountManager defaultManager] currentEvent].eventID : self.eventID),
     @"fields":@[
     @{@"fieldName":@"FirstName",@"value":(self.firstName ? self.firstName : @"")},
     @{@"fieldName":@"LastName",@"value":(self.lastName ? self.lastName : @"")},
     @{@"fieldName":@"Phone",@"value":(self.phone ? self.phone : @"")},
     @{@"fieldName":@"Mobile",@"value":(self.mobile ? self.mobile : self.mobile)},
     @{@"fieldName":@"Fax",@"value":(self.fax ? self.fax : self.fax)},
     @{@"fieldName":@"Company",@"value":(self.company ? self.company : @"")},
     @{@"fieldName":@"Job",@"value":(self.job ? self.job : @"")},
     @{@"fieldName":@"OfficeAddress",@"value":(self.address ? self.address : @"")},
     @{@"fieldName":@"City",@"value":(self.city ? self.city : @"")},
     @{@"fieldName":@"ZipCode",@"value":(self.zip ? self.zip : @"")},
     @{@"fieldName":@"Country",@"value":(self.country ? self.country : @"")},
     @{@"fieldName":@"Email",@"value":(self.email ? self.email : @"")},
     @{@"fieldName":@"Web",@"value":(self.web ? self.web : @"")},
     @{@"fieldName":@"Text",@"value":(self.text ? self.text : @"")},
     @{@"fieldName":@"FollowUpAction",@"value":(self.followupList ? self.followupList : @"")},
     @{@"fieldName":@"Topics",@"value":(self.topicList ? self.topicList : self.topicList)},
     ]
     }]
     }];
    DLOG(@"");
}

- (void)doCardImageUpload
{
    APIManager *manager = [[APIManager alloc] init];
    manager.delegate = self;
    
//    NSString *companyID = [info objectForKey:@"companyID"];
//    NSString *userID = [info objectForKey:@"userID"];
//    NSDictionary *contact = [info objectForKey:@"contact"];
//    NSString *authKey = [info objectForKey:@"authKey"];
//    NSData *image = [info objectForKey:@"image"];
    
    NSString *contactRaw = @"{\"user\":{},\"event\":{\"id\":1,\"appData\":{\"id\":1}},\"contacts\":[{\"id\":\"-1\",\"eventId\":1,\"fields\":[{\"fieldName\":\"FollowUpAction\",\"value\":\"CallUrgent\"},{\"fieldName\":\"Topics\",\"value\":\"None\"}]}]}";
    CFStringRef safeString = CFURLCreateStringByAddingPercentEscapes (
                                                                      NULL,
                                                                      (CFStringRef)contactRaw,
                                                                      NULL,
                                                                      (CFStringRef)@"!*'\"(){};:@&=+$,/?%#[]% ",
                                                                      kCFStringEncodingUTF8
                                                                      );
    NSString *contact = (__bridge NSString *)safeString;
   
//    NSString *contact = [contactRaw urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *contact = [contactRaw stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager doCardImageUpload:@{
     @"userID":@"20",//[[BCRAccountManager defaultManager] loggedInAccount].userID,
     @"companyID":@"73",//[[BCRAccountManager defaultManager] loggedInAccount].companyID,
     @"authKey":@"0101010",//[[BCRAccountManager defaultManager] loggedInAccount].authKey,
     @"contact":@"%7B%22user%22%3A%7B%7D%2C%22event%22%3A%7B%22id%22%3A1%2C%22appData%22%3A%7B%22id%22%3A1%7D%7D%2C%22contacts%22%3A%5B%7B%22id%22%3A%22-1%22%2C%22eventId%22%3A1%2C%22fields%22%3A%5B%7B%22fieldName%22%3A%22FollowUpAction%22%2C%22value%22%3A%22CallUrgent%22%7D%2C%7B%22fieldName%22%3A%22Topics%22%2C%22value%22%3A%22None%22%7D%5D%7D%5D%7D",//contact,
     @"image":UIImageJPEGRepresentation(self.image, 0.0)
     }];
    
//    // update delegate
//    if ([self.delegate respondsToSelector:@selector(contact:didFinishContactUploadWithInfo:)]) {
//        [self.delegate contact:self didFinishContactUploadWithInfo:@{@"error":BCRContactContactUploadError}];
//    }
}

#pragma mark - ClientDelegate implementation

//- (void)clientDidFinishUpload:(Client *)sender
//{
//}
//
//- (void)clientDidFinishProcessing:(Client *)sender
//{
//}
//
//- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
//{
//    DLOG(@"");
//    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/ocrprocessed/success&contactId=%@",self.contactID]];
//    
//    // update contact
//    @try {
//        [self populatePropertiesWithData:downloadedData];
//    }
//    @catch (NSException *exception) {
//        DLOG(@"Error parsing data: %@.",exception);
//    }
//    @finally {
//        
//    }
//    
//    // cleanup
//    self.client.delegate = nil;
//    self.client = nil;
//    
//    // update delegate
//    if ([self.delegate respondsToSelector:@selector(contact:didFinishOCRProcessingWithInfo:)]) {
//        [self.delegate contact:self didFinishOCRProcessingWithInfo:@{}];
//    }
//}
//
//- (void)client:(Client *)sender didFailedWithError:(NSError *)error
//{
//    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/ocrprocessed/fail&contactId=%@&error=%@",self.contactID,[error localizedDescription]]];
//    
//    // cleanup
//    self.client.delegate = nil;
//    self.client = nil;
//    
//    // update delegate
//    if ([self.delegate respondsToSelector:@selector(contact:didFinishOCRProcessingWithInfo:)]) {
//        [self.delegate contact:self didFinishOCRProcessingWithInfo:@{@"error":BCRContactOCRProcessingError}];
//    }
//}

#pragma mark - APIManagerDelegate Methods

- (void)APIManager:(APIManager *)manager didSaveContactsWithInfo:(NSDictionary *)info
{
    DLOG(@" %@",info);
    
    NSError *error = [info objectForKey:@"error"];
    if (error) {
        // update delegate
        if ([self.delegate respondsToSelector:@selector(contact:didFinishContactUploadWithInfo:)]) {
            [self.delegate contact:self didFinishContactUploadWithInfo:@{@"error":BCRContactContactUploadError}];
        }
    }else{
        // update delegate
        if ([self.delegate respondsToSelector:@selector(contact:didFinishContactUploadWithInfo:)]) {
            [self.delegate contact:self didFinishContactUploadWithInfo:info];
        }
    }
}

- (void)APIManager:(APIManager *)manager didDeleteContactsWithInfo:(NSDictionary *)info
{
    DLOG(@" %@",info);
    
    NSError *error = [info objectForKey:@"error"];
    if (error) {
        DLOG(@"error: %@",error);
    }else{
        DLOG(@"success");
    }
}

//- (void)APIManager:(APIManager *)manager didLRSUploadWithInfo:(NSDictionary *)info
//{
//    DLOG(@" %@",info);
//    
//    NSError *error = [info objectForKey:@"error"];
//    if (error) {
//        // update delegate
//        if ([self.delegate respondsToSelector:@selector(contact:didFinishLRSUploadWithInfo:)]) {
//            [self.delegate contact:self didFinishLRSUploadWithInfo:@{@"error":BCRContactContactUploadError}];
//        }
//    }else{
//        // update delegate
//        if ([self.delegate respondsToSelector:@selector(contact:didFinishLRSUploadWithInfo:)]) {
//            [self.delegate contact:self didFinishLRSUploadWithInfo:@{}];
//        }
//    }
//}

- (void)APIManager:(APIManager *)manager didCardImageUpload:(NSDictionary *)info
{
    DLOG(@" %@",info);
    
    NSError *error = [info objectForKey:@"error"];
    if (error) {
        // update delegate
        if ([self.delegate respondsToSelector:@selector(contact:didFinishCardImageUpload:)]) {
            [self.delegate contact:self didFinishCardImageUpload:@{@"error":BCRContactCardImageUploadError}];
        }
    }else{
        // update delegate
        if ([self.delegate respondsToSelector:@selector(contact:didFinishCardImageUpload:)]) {
            [self.delegate contact:self didFinishCardImageUpload:info];
        }
    }
}

@end
