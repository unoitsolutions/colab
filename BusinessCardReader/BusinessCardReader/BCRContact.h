//
//  BCRContact.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/25/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "DBContact.h"
#import "Client.h"
#import "APIManager.h"

typedef enum {
    BCRContactOCRProcessingErrorType,
    BCRContactOCRProcessingInvalidImageErrorType,
    BCRContactContactUploadErrorType,
    BCRContactLRSUploadErrorType,
} BCRContactServiceOperationErrorType;

typedef enum{
    BCRContactCreatedStatus,
    BCRContactOCRProcessedStatus,
    BCRContactUploadedStatus,
    BCRContactLRSSubmittedStatus
} BCRContactStatus;

@class BCRContact;
@protocol BCRContactDelegate <NSObject>

@optional
- (void)contact:(BCRContact *)contact didFinishOCRProcessingWithInfo:(NSDictionary *)info;
- (void)contact:(BCRContact *)contact didFinishContactUploadWithInfo:(NSDictionary *)info;
- (void)contact:(BCRContact *)contact didFinishLRSUploadWithInfo:(NSDictionary *)info;

@end

@interface BCRContact : DBContact <NSXMLParserDelegate, ClientDelegate, APIManagerDelegate>
{
    NSMutableArray *_topicOptionList;
    NSMutableArray *_followupOptionList;
}

@property (strong, nonatomic) UIImage *image;
@property (readonly) NSMutableArray *topicOptionList;
@property (readonly) NSMutableArray *followupOptionList;

@property (strong, nonatomic) Client *client;
@property (nonatomic) NSInteger status;
@property (weak, nonatomic) id<BCRContactDelegate> delegate;

- (id)initWithDBContact:(DBContact *)contact;
- (id)copyWithZone:(NSZone *)zone;

- (void)updateImage:(UIImage *)image;
- (void)populatePropertiesWithData:(NSData *)xmlData;

- (void)doOCRProcessing;
- (void)doContactUpload;
- (void)doLRSUpload;

@end
