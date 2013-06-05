//
//  PhotoViewerVC.m
//  Colab
//
//  Created by Fuentes, Pinuno [PRI-1PP] on 5/24/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import "PhotoViewerVC.h"

#define IMAGE_CLOSE [UIImage imageNamed:@"close"]

#define BUTTON_PADDING 10

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface PhotoViewerVC () <UIScrollViewDelegate>
{
    UIImageView *imageView;
    UIButton *closeButton;
}

@property (strong, nonatomic) UIScrollView *photoScrollView;
@property (strong, nonatomic) UIImage *photo;

@end

@implementation PhotoViewerVC

@synthesize photo;

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.photo = image;
        [self setUpPhotoViewer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // this will not be called
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideStatusBar];
    [self updateUIElements:self.photoScrollView];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showStatusBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    DLOG(@"orientation: %d", toInterfaceOrientation);
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self updateUIElements:self.photoScrollView];
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Set up

- (void)setUpPhotoViewer
{
    if(!self.photoScrollView)
        self.photoScrollView = [[UIScrollView alloc] init];
    if(!imageView)
        imageView = [[UIImageView alloc] initWithImage:self.photo];
                                
    //self.photoScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.photoScrollView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, SCREEN_HEIGHT);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.photoScrollView.delegate = self;
    self.photoScrollView.backgroundColor = [UIColor blackColor];
    self.photoScrollView.contentSize = imageView.frame.size;
    self.photoScrollView.minimumZoomScale = self.photoScrollView.frame.size.width/imageView.frame.size.width;
    self.photoScrollView.maximumZoomScale = 2.0;
    self.photoScrollView.zoomScale = self.photoScrollView.minimumZoomScale;
    
    [self setUpCloseButton];
    
    [self.photoScrollView addSubview:imageView];
    [self.photoScrollView addSubview:closeButton];
    
    self.view = self.photoScrollView;
    
} /* source : iDevZilla */


- (void)setUpCloseButton
{
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:IMAGE_CLOSE forState:UIControlStateNormal];
    closeButton.frame = [self computeCloseButtonFrame];
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button methods

- (void)closeButtonClicked
{
    [self dismissModalViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(photoViewerVCDidCancel:)]) {
        [self.delegate photoViewerVCDidCancel:self];
    }
}

#pragma mark - UIScrollViewDelegate method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self updateUIElements:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateUIElements:scrollView];
}

#pragma mark - Other methods

- (void)updateUIElements:(id)sender
{
    if([sender isKindOfClass:[UIScrollView class]]) {
        UIScrollView *photoScrollView = (UIScrollView *)sender;
        
        imageView.frame = [self centeredFrameForScrollView:photoScrollView andUIView:imageView];
        
        CGRect fixedFrame = [self computeCloseButtonFrame];
        fixedFrame.origin.y = photoScrollView.contentOffset.y + BUTTON_PADDING;
        fixedFrame.origin.x = photoScrollView.contentOffset.x + SCREEN_WIDTH - IMAGE_CLOSE.size.width - BUTTON_PADDING;
        closeButton.frame = fixedFrame;
    }
}

- (void)hideStatusBar
{
    [UIView animateWithDuration:0.8 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

- (void)showStatusBar
{
    [UIView animateWithDuration:0.5 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}

- (CGRect)computeCloseButtonFrame
{
    CGRect closeButtonFrame;
    
    closeButtonFrame.origin.x = SCREEN_WIDTH - IMAGE_CLOSE.size.width - BUTTON_PADDING;
    closeButtonFrame.origin.y = 0 + BUTTON_PADDING;
    closeButtonFrame.size.width = IMAGE_CLOSE.size.width;
    closeButtonFrame.size.height = IMAGE_CLOSE.size.height;
    
    return closeButtonFrame;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView
{
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;

} /* source : iDevZilla */

@end
