//
//  MapVC.m
//  Colab
//
//  Created by Fuentes, Pinuno [PRI-1PP] on 5/24/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()

- (void)showMap;
- (void)createPin;
- (void)showLoadingView;
- (void)hideLoadingView;

@end

@implementation MapVC

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

- (void)viewDidUnload
{
    [self setSegmentedControl:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)segmentedControlValueChanged:(id)sender
{
}

#pragma mark - Convenience Methods

- (void)showMap
{
#warning Unimplemented method
    
    // TODO: use geolocation if necessary
    
    // TODO: init map
    
    // TODO: create pin and add to map
    
}

- (void)createPin:(id<MKAnnotation>)pin
{
#warning Unimplemented method
}

- (void)showLoadingView
{
#warning Unimplemented method
}

- (void)hideLoadingView
{
#warning Unimplemented method
}

@end
