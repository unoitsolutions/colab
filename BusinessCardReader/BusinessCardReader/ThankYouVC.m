//
//  ThankYouVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/14/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ThankYouVC.h"
#import "BCRAccountManager.h"
#import "QueueManager.h"

@interface ThankYouVC ()

@end

@implementation ThankYouVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // update contact
    BCRContact *contact = [[BCRAccountManager defaultManager] currentContact];
    [[DB defaultManager] updateContact:contact];
    
    // update image
    self.imageView.image = contact.image;
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)scanMoreButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(thankYouVCDidDismissWithScanMoreAction:)]) {
        [self.delegate thankYouVCDidDismissWithScanMoreAction:self];
    }
}

- (IBAction)finishButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(thankYouVCDidDismissWithFinishAction:)]) {
        [self.delegate thankYouVCDidDismissWithFinishAction:self];
    }
}
@end
