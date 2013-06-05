//
//  ContactUsVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "ContactUsVC.h"

@interface ContactUsVC ()

@end

@implementation ContactUsVC

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
    [self setNavigationBar:nil];
    [self setMenuButton:nil];
    [self setCameraButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)menuButtonTapped:(id)sender
{
    DLOG(@"");
    if ([self.delegate respondsToSelector:@selector(detailVC:menuBarButtonTapped:)]) {
        [self.delegate detailVC:self menuBarButtonTapped:sender];
    }
}

- (IBAction)cameraButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailVC:cameraButtonTapped:)]) {
        [self.delegate detailVC:self cameraButtonTapped:sender];
    }
}

- (IBAction)callButtonTapped:(id)sender
{
    @try {
        NSString *phoneNumber = @"3522269617";
        NSString *urlString = [@"telprompt://" stringByAppendingString:phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to place the call." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        
    }
}

- (IBAction)emailButtonTapped:(id)sender
{
    @try {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        if (controller) {
            NSString *emailAddress = @"info@at-event.com";
            NSString *emailSubject = @"";
            NSString *emailBody = @"";
            
            [controller setSubject:emailSubject];
            [controller setToRecipients:[NSArray arrayWithObject:emailAddress]];
            [controller setMessageBody:emailBody isHTML:NO];
            controller.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>)self;
            
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        }
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        
    }
}

- (IBAction)getDirectionsButtonTapped:(id)sender
{
    @try {
        Class itemClass = [MKMapItem class];
        if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
            CLLocation *coord = [[CLLocation alloc] initWithLatitude:37.773123 longitude:-121.963652];
            MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate:coord.coordinate addressDictionary: nil];
            MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark:place];
            destination.name = @"2410 Camino Ramon, Suite 150 San Ramon, CA 94583";
            NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
            NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     MKLaunchOptionsDirectionsModeDriving,
                                     MKLaunchOptionsDirectionsModeKey, nil];
            [MKMapItem openMapsWithItems: items launchOptions: options];
        } else {
            NSString* address = @"2410 Camino Ramon, Suite 150 San Ramon, CA 94583";
            NSString* currentLocation = @"Current Location";
            NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%@&daddr=%@",[currentLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get directions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        
    }
}

- (IBAction)viewMapButtonTapped:(id)sender
{
    @try {
        Class itemClass = [MKMapItem class];
        if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
            CLLocation *coord = [[CLLocation alloc] initWithLatitude:37.773123 longitude:-121.963652];
            MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate:coord.coordinate addressDictionary: nil];
            MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark:place];
            destination.name = @"2410 Camino Ramon, Suite 150 San Ramon, CA 94583";
            NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];\
            [MKMapItem openMapsWithItems: items launchOptions:nil];
        } else {
            NSString* address = @"2410 Camino Ramon, Suite 150 San Ramon, CA 94583";
            NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%@",[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to view map." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        
    }
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
