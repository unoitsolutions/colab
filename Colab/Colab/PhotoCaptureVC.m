//
//  PhotoCaptureVC.m
//  Colab
//
//  Created by Patricia Marie Cesar on 5/29/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import "PhotoCaptureVC.h"

@interface PhotoCaptureVC ()

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation PhotoCaptureVC

@synthesize picker = _picker;

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
	// Do any additional setup after loading the view.
    
    [self createCameraCapture];
}

- (void)createCameraCapture
{
    NSLog(@"open camera!");
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.picker.showsCameraControls = YES;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;
    self.picker.wantsFullScreenLayout = YES;
    self.picker.delegate = self;
    
    self.view = self.picker.view;
    [_picker viewWillAppear:YES]; // trickery to make it show
    [_picker viewDidAppear:YES];
    [_picker viewDidLoad];
    
    // Insert the overlay
    //    self.overlay = [[PhotoCaptureView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    //    self.overlay.pickerReference = self.picker;
    //    self.picker.cameraOverlayView = self.overlay.view;
    //    self.picker.delegate = self.overlay;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
