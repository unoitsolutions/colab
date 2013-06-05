//
//  CardCaptureVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/2/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TopicPickerVC.h"
#import "ActionPickerVC.h"
#import "ThankYouVC.h"

@class CardCaptureVC;
@protocol CardCaptureVCDelegate <NSObject>

- (void)cardCaptureVC:(CardCaptureVC *)vc didFinishCardCaptureWithInfo:(NSDictionary *)info;

@end

@interface CardCaptureVC : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TopicPickerVCDelegate, ActionPickerVCDelegate, ThankYouVCDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) TopicPickerVC *topicPicker;
@property (strong, nonatomic) ActionPickerVC *actionPicker;
@property (strong, nonatomic) ThankYouVC *thankYouVC;

@property (weak, nonatomic) UIViewController *presentingViewController;
@property (weak, nonatomic) id<CardCaptureVCDelegate>delegate;

- (void)presentInViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion;

@end
