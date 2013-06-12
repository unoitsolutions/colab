//
//  PreviewView.h
//  Colab
//
//  Created by Christine Ramos on 6/9/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewView : UIView

@property (nonatomic, readonly) UIImage *image;

- (void)showImage:(UIImage *)image;

- (void)portraitView;
- (void)landscapeLeftView;
- (void)landscapeRightView;

@end
