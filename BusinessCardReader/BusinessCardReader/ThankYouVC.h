//
//  ThankYouVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/14/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"
#import "Client.h"

@class ThankYouVC;
@protocol ThankYouVCDelegate <DetailVCDelegate>

- (void)thankYouVCDidDismissWithScanMoreAction:(ThankYouVC *)thankYouVC;
- (void)thankYouVCDidDismissWithFinishAction:(ThankYouVC *)thankYouVC;

@end

@interface ThankYouVC : DetailVC

@property (weak, nonatomic) id<ThankYouVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)scanMoreButtonTapped:(id)sender;
- (IBAction)finishButtonTapped:(id)sender;

@end
