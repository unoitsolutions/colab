//
//  PreviewView.m
//  Colab
//
//  Created by Christine Ramos on 6/9/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import "PreviewView.h"

#import <QuartzCore/QuartzCore.h>

// for portrait (revert if lanscape)
#define kHeight 40.0f
#define kWidth  100.0f

@interface PreviewView ()

@property (nonatomic, strong) UIView *alphaBorder;
@property (nonatomic, strong) UIImageView *theImage;

@property (nonatomic, strong) UIButton *retake;
@property (nonatomic, strong) UIButton *use;

@end

@implementation PreviewView

@synthesize image = _image;

@synthesize alphaBorder = _alphaBorder;
@synthesize theImage = _theImage;

@synthesize retake = _retake;
@synthesize use = _use;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    

}
*/

- (void)showImage:(UIImage *)image
{
    _image = image;
    
    self.theImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _theImage.image = image;
    _theImage.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:self.theImage];
    [self addHoleSubview];
}

// source: http://stackoverflow.com/a/15377207
- (void)addHoleSubview
{
    self.alphaBorder = [[UIView alloc] initWithFrame:self.frame];
    _alphaBorder.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _alphaBorder.autoresizingMask = 0;
    [self addSubview:_alphaBorder];
    
    [self addMaskToHoleView];
    [self createButtons];
}

// source: http://stackoverflow.com/a/15377207
- (void)addMaskToHoleView
{
    CGRect bounds = _alphaBorder.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGRect hollow = CGRectMake(48.0f, 56.0f, 224.0f, 348.0f);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:hollow];
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    _alphaBorder.layer.mask = maskLayer;
}

- (void)createButtons
{
    self.use = [UIButton buttonWithType:UIButtonTypeCustom];
    self.retake = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.use.frame = CGRectMake(50.0f, 411.0f, kWidth, kHeight);
    [self.use setTitle:@"Use" forState:UIControlStateNormal];
    self.use.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
    
    self.retake.frame = CGRectMake(170.0f, 411.0f, kWidth, kHeight);
    [self.retake setTitle:@"Retake" forState:UIControlStateNormal];
    self.retake.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    
    [self.use addTarget:self action:@selector(useButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.retake addTarget:self action:@selector(retakeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.use];
    [self addSubview:self.retake];
}

- (void)retakeButtonAction
{
    [self removeFromSuperview];
}

- (void)portraitView
{
    NSLog(@"portrait");
    [UIView animateWithDuration:0.5f animations:^{
        self.use.transform = CGAffineTransformIdentity;
        self.retake.transform = CGAffineTransformIdentity;
        
        self.use.frame = CGRectMake(50.0f, 411.0f, kWidth, kHeight);
        self.retake.frame = CGRectMake(170.0f, 411.0f, kWidth, kHeight);
    }];
}

// handle UI position for landscape left view
- (void)landscapeLeftView
{
    NSLog(@"landscapeLeft");
    [UIView animateWithDuration:0.5f animations:^{
        self.use.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.retake.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        self.use.frame = CGRectMake(7.0f, 124.0f, kHeight, kWidth);
        self.retake.frame = CGRectMake(7.0f, 238.0f, kHeight, kWidth);
    }];
}

// handle UI position for landscape right view
- (void)landscapeRightView
{
    NSLog(@"landscapeRight");
    [UIView animateWithDuration:0.5f animations:^{
        self.use.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.retake.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        self.use.frame = CGRectMake(272.0f, 238.0f, kHeight, kWidth);
        self.retake.frame = CGRectMake(272.0f, 124.0f, kHeight, kWidth);
    }];
}

- (void)useButtonAction
{
    // _image;
    [self cropTheImageWithScale:5.0];
    _image = [self scaleAndRotateImage:_image];
    
    self.theImage.contentMode = UIViewContentModeScaleToFill;
    self.theImage.image = _image;
    NSLog(@"use this image: %@", _image);
}

- (void)cropTheImageWithScale:(CGFloat)scale
{
    CGRect crop = CGRectMake(48.0f, 56.0f, 224.0f, 348.0f);
    
    crop = CGRectMake(crop.origin.x * scale,
                      crop.origin.y * scale,
                      crop.size.width * scale,
                      crop.size.height * scale);
    
    CGImageRef tmp = CGImageCreateWithImageInRect([_image CGImage], crop);
    _image = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    //[self saveImage];
}

// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
