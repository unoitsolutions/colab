//
//  PhotoCaptureVC.h
//  Colab
//
//  Created by Christine Ramos on 5/29/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCaptureVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerReference;

@end
