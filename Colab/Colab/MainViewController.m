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

@interface MainViewController ()

@end

@implementation MainViewController

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
    PhotoCaptureVC *vc = [[PhotoCaptureVC alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

@end
