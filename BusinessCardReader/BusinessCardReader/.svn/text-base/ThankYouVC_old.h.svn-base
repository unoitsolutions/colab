//
//  ThankYouVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/20/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@class ThankYouVC_old;
@protocol ThankYouVC_oldDelegate <NSObject>

- (void)thankYouVCDidDismissWithScanMoreAction:(ThankYouVC_old *)thankYouVC;
- (void)thankYouVCDidDismissWithFinishAction:(ThankYouVC_old *)thankYouVC;

@end

@interface ThankYouVC_old : UIViewController <ClientDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *scanMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (weak, nonatomic) id<ThankYouVC_oldDelegate> delegate;

- (IBAction)scanMoreButtonTapped:(id)sender;
- (IBAction)finishButtonTapped:(id)sender;

@end
