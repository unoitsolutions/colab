//
//  LinkedInComposeViewController.h
//  LinkedInComposeViewController
//
//  Created by Patricia Marie Cesar on 5/23/13.
//  Copyright (c) 2013 Patricia Marie Cesar. All rights reserved.
//

@class LinkedInComposeViewController;

#import <UIKit/UIKit.h>
#import "LinkedInComposeViewControllerConfig.h"
#import "REComposeViewController.h"

typedef NS_ENUM(NSInteger, LinkedInComposeViewControllerResult) {
    LinkedInComposeViewControllerResultCancelled,
    LinkedInComposeViewControllerResultDone
};

typedef void (^LinkedInComposeViewControllerCompletionHandler)(LinkedInComposeViewController *composeViewController, LinkedInComposeViewControllerResult result);

@protocol LinkedInComposeViewControllerDelegate;

@interface LinkedInComposeViewController : REComposeViewController

- (BOOL)setInitialText:(NSString *)text;

- (BOOL)setPlaceholder:(NSString *)placeholderText;

- (BOOL)addImage:(UIImage *)image;

@property (weak, nonatomic) id<LinkedInComposeViewControllerDelegate> delegateLinkedIn;

@property (copy, readwrite, nonatomic) LinkedInComposeViewControllerCompletionHandler linkedInCompletionHandler;

@end

@protocol LinkedInComposeViewControllerDelegate <NSObject>

@optional
- (void)linkedInComposeViewController:(LinkedInComposeViewController *)composeViewController didFinishWithResult:(LinkedInComposeViewControllerResult)result;

@end

