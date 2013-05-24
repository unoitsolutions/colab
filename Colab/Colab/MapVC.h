//
//  MapVC.h
//  Colab
//
//  Created by Fuentes, Pinuno [PRI-1PP] on 5/24/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapVC : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)segmentedControlValueChanged:(id)sender;

- (id)initWithCLPlacemark:(CLPlacemark *)placemark;
- (id)initWithAddressString:(NSString *)addressString;

@end
