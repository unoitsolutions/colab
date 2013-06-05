//
//  ThankYouVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/20/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ThankYouVC_old.h"
#import "BCRAccountManager.h"
#import "QueueManager.h"

@interface ThankYouVC_old ()

@end

@implementation ThankYouVC_old

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // logo
    UIImageView *view= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ateventIcon114"]];
    [view setContentMode:UIViewContentModeScaleAspectFit];
    view.frame =  CGRectMake(0, 0, 32, 32);
    self.navigationItem.titleView = view;
    
//    [self.view setBackgroundColor:[[AETheme sharedInstance] defaultBackgroundColor]];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.scanMoreButton];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.finishButton];

    // update contact
    BCRContact *contact = [[BCRAccountManager defaultManager] currentContact];
    [[DB defaultManager] updateContact:contact];
    
    // hack for hiding back button
    UIView *invisibleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    invisibleView.alpha = 0;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:invisibleView];
    backItem.enabled = NO;
    backItem.tintColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = backItem;

    // update image
    self.imageView.image = contact.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setScanMoreButton:nil];
    [self setFinishButton:nil];
    [super viewDidUnload];
}

#pragma mark - Action Methods

- (IBAction)scanMoreButtonTapped:(id)sender
{
    // enqueue contact
    [[QueueManager defaultManager] enqueueContact:[BCRAccountManager defaultManager].currentContact];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/scanmore"]];
    
    if ([self.delegate respondsToSelector:@selector(thankYouVCDidDismissWithScanMoreAction:)]) {
        [self.delegate thankYouVCDidDismissWithScanMoreAction:self];
    }
}

- (IBAction)finishButtonTapped:(id)sender
{
    // enqueue contact
    [[QueueManager defaultManager] enqueueContact:[BCRAccountManager defaultManager].currentContact];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"atEvent.bcr/cardcapture/finish"]];
    
    if ([self.delegate respondsToSelector:@selector(thankYouVCDidDismissWithFinishAction:)]) {
        [self.delegate thankYouVCDidDismissWithFinishAction:self];
    }
}

@end
