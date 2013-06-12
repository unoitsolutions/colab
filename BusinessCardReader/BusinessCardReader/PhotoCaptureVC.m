//
//  PhotoCaptureVC.m
//  Colab
//
//  Created by Christine Ramos on 5/29/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import "PhotoCaptureVC.h"

#import "PreviewView.h"

#define BORDER_IMAGE    [UIImage imageNamed:@"black_border"]
#define CLOSE_ICON      [UIImage imageNamed:@"close"]
#define CAMERA_ICON     [UIImage imageNamed:@"scan_camera_btn"]

@interface PhotoCaptureVC ()

@property (nonatomic, strong) UIImageView *border;
@property (nonatomic, strong) UIButton *camera;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) PreviewView *imagePreview;

@end

@implementation PhotoCaptureVC

@synthesize border = _border;
@synthesize camera = _camera;
@synthesize closeButton = _closeButton;

@synthesize imagePreview = _imagePreview;
@synthesize pickerReference = _pickerReference;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainView.backgroundColor = [UIColor clearColor];
    self.view = mainView;
    
    [self createSubviews];
}

- (void)createSubviews
{
    self.border = [[UIImageView alloc] initWithImage:BORDER_IMAGE];
    self.camera = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.border.contentMode = UIViewContentModeScaleToFill;
    self.border.frame = CGRectMake(42.0f, 50.0f, 236.0f, 360.0f);
    
    self.border.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self createButtons];
    [self addSubviews];
}

- (void)createButtons
{
    self.camera.frame = CGRectMake(125.0f, 380.0f, 60.0f, 60.0f);
    self.closeButton.frame = CGRectMake(193.0f, 400.0f, 20.0f, 20.0f);
    
    [self.camera setBackgroundImage:CAMERA_ICON forState:UIControlStateNormal];
    [self.camera setBackgroundImage:CAMERA_ICON forState:UIControlStateSelected];
    [self.camera setBackgroundImage:CAMERA_ICON forState:UIControlStateHighlighted];
    
    [self.closeButton setBackgroundImage:CLOSE_ICON forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:CLOSE_ICON forState:UIControlStateSelected];
    [self.closeButton setBackgroundImage:CLOSE_ICON forState:UIControlStateHighlighted];
    
    [self addButtonActions];
}

- (void)addButtonActions
{
    [self.camera addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSubviews
{
    [self.view addSubview:self.border];
    [self.view addSubview:self.camera];
    [self.view addSubview:self.closeButton];
}

- (void)addObserverForOrientation
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

- (void)orientationChanged:(NSNotification *)note
{
    UIDevice *device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self portraitView];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            [self landscapeLeftView];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [self landscapeRightView];
            break;
            
        default:
            break;
    };
}

// handle UI position for portrait view
- (void)portraitView
{
    NSLog(@"portrait");
    
    if ([[self.view subviews] containsObject:self.imagePreview]) {
        [self.imagePreview portraitView];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.camera.transform = CGAffineTransformIdentity;
            self.camera.frame = CGRectMake(125.0f, 380.0f, 60.0f, 60.0f);
            self.closeButton.frame = CGRectMake(193.0f, 400.0f, 20.0f, 20.0f);
        }];
    }
}

// handle UI position for landscape left view
- (void)landscapeLeftView
{
    NSLog(@"landscapeLeft");
    
    if ([[self.view subviews] containsObject:self.imagePreview]) {
        [self.imagePreview landscapeLeftView];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.camera.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.camera.frame = CGRectMake(20.0f, 200.0f, 60.0f, 60.0f);
            self.closeButton.frame = CGRectMake(40.0f, 275.0f, 20.0f, 20.0f);
        }];
    }
}

// handle UI position for landscape right view
- (void)landscapeRightView
{
    NSLog(@"landscapeRight");
    
    if ([[self.view subviews] containsObject:self.imagePreview]) {
        [self.imagePreview landscapeRightView];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.camera.transform = CGAffineTransformMakeRotation(-M_PI_2);
            self.camera.frame = CGRectMake(240.0f, 200.0f, 60.0f, 60.0f);
            self.closeButton.frame = CGRectMake(260.0f, 275.0f, 20.0f, 20.0f);
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation: %d", toInterfaceOrientation);
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addObserverForOrientation];
}

- (void)takePicture
{
    NSLog(@"takePicture");
    [self.pickerReference takePicture];
}

- (void)dismissView
{
    NSLog(@"dismissView");
    [self.pickerReference dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"the image!!");
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // show preview
    self.imagePreview = [[PreviewView alloc] initWithFrame:self.view.bounds];
    [_imagePreview showImage:image];
    [self.view addSubview:_imagePreview];
    [self.view bringSubviewToFront:_imagePreview];
}

@end
