//
//  CardCaptureVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/2/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "CardCaptureVC.h"
#import "EDStorage.h"
#import "QueueManager.h"
#import "BCRAccountManager.h"

@implementation CardCaptureVC

- (void)presentInViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion
{
    self.presentingViewController = viewController;
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    [self.presentingViewController presentViewController:self.imagePicker
                                                animated:flag
                                              completion:completion];

}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *image = ([info objectForKey:UIImagePickerControllerEditedImage] ? [info objectForKey:UIImagePickerControllerEditedImage] : [info objectForKey:UIImagePickerControllerOriginalImage]);
#ifdef MDEBUG
    //    image = [UIImage imageNamed:@"doc10003"];
#endif
    
    // create contact
    BCRContact *contact = [[BCRContact alloc] init];
    [contact setEventID:[BCRAccountManager defaultManager].currentEvent.eventID];
    [contact updateImage:image];
    [[BCRAccountManager defaultManager] setCurrentContact:contact];
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/createcontact&contactId=%@",contact.contactID]];
    
    // go to topicsVC
    self.topicPicker = [[TopicPickerVC alloc] initWithNibName:nil bundle:nil];
    self.topicPicker.delegate = self;
    [self.imagePicker pushViewController:self.topicPicker animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(cardCaptureVC:didFinishCardCaptureWithInfo:)]) {
            [self.delegate cardCaptureVC:self didFinishCardCaptureWithInfo:@{@"cancel":[NSNumber numberWithBool:YES]}];
        }
    }];
}


#pragma mark - TopicPickerVCDelegate Methods

- (void)topicPicker:(TopicPickerVC *)picker didFinishPickingTopicsWithInfo:(NSDictionary *)info
{
    DLOG(@"");
    
    // go to followup picker
    self.actionPicker = [[ActionPickerVC alloc] initWithNibName:nil bundle:nil];
    self.actionPicker.delegate = self;
    [self.imagePicker pushViewController:self.actionPicker animated:YES];
}

#pragma mark - ActionPickerVCDelegate Methods

- (void)actionPicker:(ActionPickerVC *)picker didFinishPickingFollowupActionsWithInfo:(NSDictionary *)info
{
    DLOG(@"");
    
    // go to thank you page
    self.thankYouVC = [[ThankYouVC alloc] initWithNibName:nil bundle:nil];
    self.thankYouVC.delegate = self;
    [self.imagePicker pushViewController:self.thankYouVC animated:YES];
}

#pragma mark - ThankYouVCDelegate Methods

- (void)thankYouVCDidDismissWithScanMoreAction:(ThankYouVC *)thankYouVC
{
    // enqueue contact
    [[QueueManager defaultManager] enqueueContact:[BCRAccountManager defaultManager].currentContact];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/scanmore"]];
    
    [self.imagePicker popToRootViewControllerAnimated:YES];
}

- (void)thankYouVCDidDismissWithFinishAction:(ThankYouVC *)thankYouVC
{
    
    // enqueue contact
    [[QueueManager defaultManager] enqueueContact:[BCRAccountManager defaultManager].currentContact];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/finish"]];
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(cardCaptureVC:didFinishCardCaptureWithInfo:)]) {
            [self.delegate cardCaptureVC:self didFinishCardCaptureWithInfo:nil];
        }
    }];
}

@end
