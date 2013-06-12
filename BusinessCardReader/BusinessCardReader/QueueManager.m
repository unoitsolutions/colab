//
//  QueueManager.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/3/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "QueueManager.h"
#import "AppDelegate.h"

NSString *QueueManagerDidEnqueueContactNotification = @"QueueManagerDidEnqueueContactNotification";
NSString *QueueManagerDidDequeueContactNotification = @"QueueManagerDidDequeueContactNotification";

@interface QueueManager ()

- (void)_showWarningNotification:(NSString *)message;
- (void)_showErrorNotification:(NSString *)message;
- (void)_showSuccessNotification:(NSString *)message;

@end

@implementation QueueManager

+ (QueueManager *)defaultManager
{
    static QueueManager *_defaultManager;
    if (!_defaultManager) {
        _defaultManager = [[QueueManager alloc] init];
        [_defaultManager loadFromDatabase];
    }
    return _defaultManager;
}

- (void)loadFromDatabase
{
    self.queue = [NSMutableArray arrayWithArray:[[DB defaultManager] retrieveAllContactJoinProcessQueueItem]];
}

- (void)doStart
{
    assert(NO);
}

- (void)doPause
{
    assert(NO);
}

- (void)doContinue
{
    assert(NO);
}

- (void)doStop
{
    assert(NO);
}

- (void)enqueueContact:(BCRContact *)contact
{
    [self.queue addObject:contact];
    
    // save queue to database
    [[DB defaultManager].db beginTransaction];
    [[DB defaultManager] createContact:contact forEvent:[[BCRAccountManager defaultManager] currentEvent]];
    DBProcessQueueItem *item = [[DBProcessQueueItem alloc] init];
    [[DB defaultManager] createProcessQueueItem:item forContact:contact];
    [[DB defaultManager].db commit];
    
    // notify observers
    [[NSNotificationCenter defaultCenter] postNotificationName:QueueManagerDidEnqueueContactNotification object:nil];
    
    // upload image
    [contact setDelegate:self];
    [contact performSelectorInBackground:@selector(doCardImageUpload) withObject:nil];
    
//    // start ocr process
//    [contact setDelegate:self];
//    [contact performSelectorInBackground:@selector(doOCRProcessing) withObject:nil];
}

- (void)dequeueContact:(BCRContact *)contact
{
    [self.queue removeObject:contact];
    
    // update DB
    [[DB defaultManager].db beginTransaction];
    [[DB defaultManager] deleteProcessQueueItem:nil forContact:contact];
    [[DB defaultManager].db commit];
    
    // notify observers
    [[NSNotificationCenter defaultCenter] postNotificationName:QueueManagerDidDequeueContactNotification object:nil];
    
    // cleanup
    contact.delegate = nil;

}

#pragma mark - AEContactDelegate

//- (void)contact:(BCRContact *)contact didFinishOCRProcessingWithInfo:(NSDictionary *)info
//{
//    NSError *error = [info objectForKey:@"error"];
//    if (error) {
//        DLOG(@"error: %@",error);
//        if (![[error domain] isEqualToString:@"ABBYY"] || ![[error.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"Business card not found on image"]) {
//            // create success notification
//            [self _showWarningNotification:@"A new contact was created. However, the image is not a valid business card."];
//        }else{
//            // create error notification
//            [self _showErrorNotification:[error localizedDescription]];
//            
//#warning implement
//            // TODO: push to back of queue
//            
//            return;
//        }
//    }
//    
//    DLOG(@"info: %@",info);
//    
//    // update status
//    [contact setStatus:BCRContactOCRProcessedStatus];
//    [[DB defaultManager] updateContact:contact];
//
//    // upload contact
//    [contact doContactUpload];
//}

- (void)contact:(BCRContact *)contact didFinishContactUploadWithInfo:(NSDictionary *)info
{
    NSError *error = [info objectForKey:@"error"];  DLOG(@"error: %@",error);
    if (error) {
        // create error notification
        [self _showErrorNotification:[error localizedDescription]];
        
#warning implement
        // TODO: push to back of queue
        
#warning remove debug code
        // TODO: remove this temporary code
        [self dequeueContact:contact];
    }else{
        // update id
        NSString *oldContactID = contact.contactID;
        NSString *contactID = [[(NSArray *)[[info objectForKey:@"result"] objectForKey:@"contacts"] objectAtIndex:0] objectForKey:@"id"];
        [contact setContactID:contactID];
        
        // update image filename
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileName = [NSString stringWithFormat:@"%@.png",oldContactID];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        NSString *newFileName = [NSString stringWithFormat:@"%@.png",contact.contactID];
        NSString *newFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:newFileName];
        
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:newFilePath error:&error];
        if (!result || error) {
            assert(NO);
        }
        
        // update status
        [contact setStatus:BCRContactUploadedStatus];
        [[DB defaultManager] updateContact:contact];
        
        
    }
}

//- (void)contact:(BCRContact *)contact didFinishLRSUploadWithInfo:(NSDictionary *)info
//{
//    NSError *error = [info objectForKey:@"error"];
//    if (error) {
//        // create error notification
//        [self _showErrorNotification:[error localizedDescription]];
//        
//#warning implement
//        // TODO: push to back of queue
//    }else{
//#warning implement
//        // TODO: create success notification
//        [self _showSuccessNotification:@"A new contact was submitted."];
//
//        // update status
//        [contact setStatus:BCRContactLRSSubmittedStatus];
//        [[DB defaultManager] updateContact:contact];
//        
//        // dequeue contact
//        [self dequeueContact:contact];
//    }
//}

- (void)contact:(BCRContact *)contact didFinishCardImageUpload:(NSDictionary *)info
{
    NSError *error = [info objectForKey:@"error"];
    if (error) {
        DLOG(@"error: %@",error);
        
        // create error notification
        [self _showErrorNotification:[error localizedDescription]];
    }else{
        DLOG(@"info: %@",info);
        
        // update status & contactID
        [contact setStatus:BCRContactUploadedStatus];
//        [contact setContactID:[info objectForKey:@"contactID"]];
        [[DB defaultManager] updateContact:contact];
        
        [self dequeueContact:contact];
        
        // TODO: create success notification
        [self _showSuccessNotification:@"A new contact was submitted."];
    }
}

#pragma mark - Convenience Methods

- (void)_showWarningNotification:(NSString *)message
{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [TSMessage showNotificationInViewController:del.mainVC withTitle:nil withMessage:message withType:TSMessageNotificationTypeWarning];
    [TSMessage showNotificationInViewController:del.mainVC.cardCaptureVC.imagePicker withTitle:nil withMessage:message withType:TSMessageNotificationTypeWarning];
}

- (void)_showErrorNotification:(NSString *)message
{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [TSMessage showNotificationInViewController:del.mainVC withTitle:nil withMessage:message withType:TSMessageNotificationTypeError];
    [TSMessage showNotificationInViewController:del.mainVC.cardCaptureVC.imagePicker withTitle:nil withMessage:message withType:TSMessageNotificationTypeError];
}

- (void)_showSuccessNotification:(NSString *)message
{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [TSMessage showNotificationInViewController:del.mainVC withTitle:nil withMessage:message withType:TSMessageNotificationTypeSuccess];
    [TSMessage showNotificationInViewController:del.mainVC.cardCaptureVC.imagePicker withTitle:nil withMessage:message withType:TSMessageNotificationTypeSuccess];
}

@end
