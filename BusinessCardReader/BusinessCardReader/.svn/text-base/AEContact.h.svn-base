//
//  AEContact.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"

typedef enum {
    AEContactOCRProcessingErrorType,
    AEContactContactUploadErrorType,
    AEContactLRSUploadErrorType,
} AEContactServiceOperationErrorType;

typedef enum{
    AEContactCreatedStatus,
    AEContactOCRProcessedStatus,
    AEContactUploadedStatus,
    AEContactLRSSubmittedStatus
} AEContactStatus;

@class AEContact;
@protocol AEContactDelegate <NSObject>

- (void)contact:(AEContact *)contact didFinishOCRProcessingWithInfo:(NSDictionary *)info;
- (void)contact:(AEContact *)contact didFinishContactUploadWithInfo:(NSDictionary *)info;
- (void)contact:(AEContact *)contact didFinishLRSUploadWithInfo:(NSDictionary *)info;

@end

@interface AEContact : NSObject <NSXMLParserDelegate, ClientDelegate>

@property  NSString *contactID;
@property (strong, nonatomic) NSURL *bCardImageURL;
@property (strong, nonatomic) UIImage *bCardImage;

@property (strong, nonatomic) NSString *followup;
@property (strong, nonatomic) NSString *topic;

// ocr data
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *job;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *web;
@property (strong, nonatomic) NSString *text;

@property (nonatomic) AEContactStatus status;

@property (weak, nonatomic) id<AEContactDelegate> delegate;

@property (strong, nonatomic) Client *client;

- (void)updateImage:(UIImage *)image;
- (void)populatePropertiesWithData:(NSData *)xmlData;

- (void)doOCRProcessing;
- (void)doContactUpload;
- (void)doLRSUpload;

@end
