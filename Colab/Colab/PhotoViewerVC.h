//
//  PhotoViewerVC.h
//  Colab
//
//  Created by Fuentes, Pinuno [PRI-1PP] on 5/24/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPiewerVC;
@protocol PhotoViewerDelegate <NSObject>

- (void)photoViewerVCDidCancel:(PhotoPiewerVC *)vc;

@end

@interface PhotoViewerVC : UIViewController

@property (weak, nonatomic) id<PhotoViewerDelegate> delegate;

- (id)initWithImage:(UIImage *)image;

@end
