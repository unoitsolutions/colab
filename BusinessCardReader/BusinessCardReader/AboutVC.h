//
//  AboutVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVC.h"

@interface AboutVC : DetailVC

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;

@end
