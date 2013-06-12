//
//  MainViewController.m
//  Colab
//
//  Created by Fuentes, Pinuno [PRI-1PP] on 5/24/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoViewerVC.h"
#import "PhotoCaptureVC.h"

#import "PhotoCaptureView.h"

//transform values for full screen support
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.26

@interface MainViewController ()

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, strong) PhotoCaptureView *overlay;

@end

@implementation MainViewController

@synthesize picker = _picker;
@synthesize overlay = _overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait) {
       return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (IBAction)photoViewerButtonClicked:(id)sender
{
    PhotoViewerVC *vc = [[PhotoViewerVC alloc] initWithImage:[UIImage imageNamed:@"sample"]];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction)photoCaptureButtonClicked:(id)sender
{
    NSLog(@"hey");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PhotoCaptureVC *vc = [[PhotoCaptureVC alloc] init];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        //    [self createCameraCapture];
    }
}

- (void)createCameraCapture
{
    NSLog(@"open camera!");
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;
    self.picker.wantsFullScreenLayout = YES;
    self.picker.cameraViewTransform = CGAffineTransformScale(self.picker.cameraViewTransform,
                                                             CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
    self.picker.delegate = self;
    
    // Insert the overlay
    //    self.overlay = [[PhotoCaptureView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    //    self.overlay.pickerReference = self.picker;
    //    self.picker.cameraOverlayView = self.overlay.view;
    //    self.picker.delegate = self.overlay;
    
    [self presentModalViewController:self.picker animated:YES];
}

@end
