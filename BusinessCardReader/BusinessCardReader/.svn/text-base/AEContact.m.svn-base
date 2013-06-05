//
//  AEContact.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/19/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "AEContact.h"
#import "XMLReader.h"
#import "AESessionManager.h"

NSString* const AEContactServiceOperationErrorDomain = @"AEContactServiceOperationErrorDomain";

static NSError *AEContactOCRProcessingError;
static NSError *AEContactContactUploadError;
static NSError *AEContactLRSUploadError;

@implementation AEContact

+ (void)initialize
{
    if (self == [AEContact class]){
        AEContactOCRProcessingError = [[NSError alloc] initWithDomain:AEContactServiceOperationErrorDomain code:AEContactOCRProcessingErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OCR Process Failed",NSLocalizedDescriptionKey,nil]];
        AEContactContactUploadError = [[NSError alloc] initWithDomain:AEContactServiceOperationErrorDomain code:AEContactContactUploadErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Contact Upload Failed",NSLocalizedDescriptionKey,nil]];
        AEContactLRSUploadError = [[NSError alloc] initWithDomain:AEContactServiceOperationErrorDomain code:AEContactLRSUploadErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Lead Routing System Upload Failed",NSLocalizedDescriptionKey,nil]];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
        self.contactID = (__bridge NSString *)newUniqueIdString;
        
        self.name = @"";
        self.phone = @"";
        self.mobile = @"";
        self.fax = @"";
        self.company = @"";
        self.job = @"";
        self.address = @"";
        self.email = @"";
        self.web = @"";
        self.text = @"";
        
        self.followup = @"";
        self.topic = @"";
    }
    return self;
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
    
    UIImage *_image = [UIImage imageWithContentsOfFile:filePath];
    self.bCardImageURL = [NSURL fileURLWithPath:filePath];
    self.bCardImage = _image;
    
//    self.bCardImageURL = [NSURL fileURLWithPath:filePath];
//    self.bCardImage = image;
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
            self.name = fieldValue;
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

#pragma mark - Service Operations

- (void)doOCRProcessing
{
    DLOG(@"");
    assert(!self.client);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.client = [[Client alloc] initWithApplicationID:OCR_APP_ID password:OCR_APP_PASSWORD];
        [self.client setDelegate:self];
        ProcessingParams* params = [[ProcessingParams alloc] init];
        [self.client processBusinessCard:self.bCardImage withParams:params];
    });
}

- (void)doContactUpload
{
    // TODO: implement
    assert(NO);
    
    // update delegate
    if ([self.delegate respondsToSelector:@selector(contact:didFinishContactUploadWithInfo:)]) {
        [self.delegate contact:self didFinishContactUploadWithInfo:@{@"error":AEContactContactUploadError}];
    }
}

- (void)doLRSUpload
{
    // TODO: implement
    assert(NO);
    
    // update delegate
    if ([self.delegate respondsToSelector:@selector(contact:didFinishLRSUploadWithInfo:)]) {
        [self.delegate contact:self didFinishLRSUploadWithInfo:@{@"error":AEContactLRSUploadError}];
    }
}

#pragma mark - ClientDelegate implementation

- (void)clientDidFinishUpload:(Client *)sender
{
}

- (void)clientDidFinishProcessing:(Client *)sender
{
}

- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
    DLOG(@"");
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/ocrprocessed/success&contactId=%@",self.contactID]];
    
    // update contact
    @try {
        [self populatePropertiesWithData:downloadedData];
    }
    @catch (NSException *exception) {
        DLOG(@"Error parsing data: %@.",exception);
    }
    @finally {
        
    }
    
    // cleanup
    self.client.delegate = nil;
    self.client = nil;
    
    // update delegate
    if ([self.delegate respondsToSelector:@selector(contact:didFinishOCRProcessingWithInfo:)]) {
        [self.delegate contact:self didFinishOCRProcessingWithInfo:@{}];
    }
}

- (void)client:(Client *)sender didFailedWithError:(NSError *)error
{
    DLOG(@"error: %@",[error localizedDescription]);
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/ocrprocessed/success&contactId=%@&error=%@",self.contactID,[error localizedDescription]]];
    
    // cleanup
    self.client.delegate = nil;
    self.client = nil;
    
    // update delegate
    if ([self.delegate respondsToSelector:@selector(contact:didFinishOCRProcessingWithInfo:)]) {
        [self.delegate contact:self didFinishOCRProcessingWithInfo:@{@"error":AEContactOCRProcessingError}];
    }
}

@end
