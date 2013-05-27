//
//  LinkedInComposeViewController.m
//  LinkedInComposeViewController
//
//  Created by Patricia Marie Cesar on 5/23/13.
//  Copyright (c) 2013 Patricia Marie Cesar. All rights reserved.
//

#import "LinkedInComposeViewController.h"

@interface LinkedInComposeViewController () <REComposeViewControllerDelegate>

@end

@implementation LinkedInComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUpUIElements];
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUIElements
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:LINKEDIN_SHEET_LOGO];
    titleImageView.frame = LINKEDIN_SHEET_LOGO_FRAME;
    self.navigationItem.titleView = titleImageView;
    [self.navigationBar setBackgroundImage:LINKEDIN_SHEET_BG forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem.tintColor = LINKEDIN_SHEET_BUTTON_COLOR_LEFT;
    self.navigationItem.rightBarButtonItem.tintColor = LINKEDIN_SHEET_BUTTON_COLOR_RIGHT;
}

- (BOOL)setInitialText:(NSString *)text
{
    if(text) {
        self.text = text;
        return YES;
    }
    return NO;
}

- (BOOL)setPlaceholder:(NSString *)placeholderText
{
    if(placeholderText) {
        self.placeholderText = placeholderText;
        return YES;
    }
    return NO;
}

- (BOOL)addImage:(UIImage *)image
{
    if(image){
        self.attachmentImage = image;
        return YES;
    }
    return NO;
}

- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result
{
    [composeViewController dismissViewControllerAnimated:YES completion:nil];
    
    LinkedInComposeViewControllerResult linkedInResult;
    
    switch (result) {
        case REComposeResultCancelled:
            linkedInResult = LinkedInComposeViewControllerResultCancelled;
            break;
        case REComposeResultPosted:
            linkedInResult = LinkedInComposeViewControllerResultDone;
            break;
        default:
            break;
    }
    
    if(self.delegateLinkedIn && [self.delegateLinkedIn respondsToSelector:@selector(linkedInComposeViewController:didFinishWithResult:)]) {
        
        [self.delegateLinkedIn linkedInComposeViewController:self didFinishWithResult:linkedInResult];
        
    }
    if(self.linkedInCompletionHandler) {
        
        self.linkedInCompletionHandler(self, linkedInResult);
        
    }
}


//- (BOOL)addURL:(NSURL *)url
//{
//    self.
//}

@end
