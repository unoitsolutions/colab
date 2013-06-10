//
//  ContactDetailVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/8/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactDetailVC.h"
#import "ContactEditVC.h"

@interface ContactDetailVC ()

@end

@interface ContactDetailCell : UITableViewCell

@end



@implementation ContactDetailVC

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
    
    self.view.backgroundColor = [[BCRAccountManager defaultManager] defaultBGColor];
    self.navigationBar.backgroundColor = [[BCRAccountManager defaultManager] defaultNavbarBGColor];
//    [self.backButton setBackgroundImage:[[BCRAccountManager defaultManager] defaultNavbarMenuBGImage] forState:UIControlStateNormal];
//    [self.cameraButton setBackgroundImage:[[BCRAccountManager defaultManager] defaultNavbarCameraBGImage] forState:UIControlStateNormal];
    
    if(self.contact.image) self.imageView.image = self.contact.image;
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",(!self.contact.firstName.isNull ? [NSString stringWithFormat:@"%@ ",self.contact.firstName] : @""),self.contact.lastName];
    self.companyLabel.text = self.contact.company;
    self.jobLabel.text = self.contact.job;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setNameLabel:nil];
    [self setCompanyLabel:nil];
    [self setJobLabel:nil];
    [self setNavigationBar:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
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

#pragma mark - Action Methods

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButtonTapped:(id)sender
{   
    ContactEditVC *vc = [[ContactEditVC alloc] initWithNibName:nil bundle:nil];
    vc.contact = self.contact;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)zoomButtonTapped:(id)sender
{
    PhotoViewerVC *vc = [[PhotoViewerVC alloc] initWithImage:self.imageView.image];
    id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
    [(UIViewController *)rootVC presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"No camera found on this device."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 2;
    }else if (section == 3) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contact_row_bg";
    static NSString *CellIdentifier1 = @"contact_row1_bg";
    
    ContactDetailCell *cell  = [tableView dequeueReusableCellWithIdentifier:(indexPath.section == 1 ? CellIdentifier1 : CellIdentifier)];
    if (cell == nil) {
        cell = [[ContactDetailCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:(indexPath.section == 1 ? CellIdentifier1 : CellIdentifier)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:(indexPath.section == 1 ? CellIdentifier1 : CellIdentifier)]];
        cell.backgroundView = view;
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"Address";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.contact.address, (!self.contact.city.isNull ? [NSString stringWithFormat:@" %@",self.contact.city] : @""), (!self.contact.zip.isNull ? [NSString stringWithFormat:@" %@",self.contact.zip] : @""), (!self.contact.country.isNull ? [NSString stringWithFormat:@" %@",self.contact.country] : @"")];
        cell.textLabel.numberOfLines = cell.detailTextLabel.numberOfLines = 2;
    }else if (indexPath.section == 0) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Phone";
            cell.detailTextLabel.text = self.contact.phone;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Mobile";
            cell.detailTextLabel.text = self.contact.mobile;
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Fax";
            cell.detailTextLabel.text = self.contact.fax;
        }
    }else if (indexPath.section == 2) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = self.contact.email;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Web";
            cell.detailTextLabel.text = self.contact.web;
        }
    }else if (indexPath.section == 3) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Topic(s)";
            cell.detailTextLabel.text = self.contact.topicList;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Action(s)";
            cell.detailTextLabel.text = self.contact.followupList;
        }
    }
    
    
//    BCRContact *contact = [self.contactList objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = (contact.name.length > 0 ? contact.name : @"<Unnamed>");
//    cell.detailTextLabel.text = contact.company;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 292, 10)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50;
    }else{
        return 37;
    }
}

@end


@implementation ContactDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
        self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews]; // layouts the cell as UITableViewCellStyleValue2 would normally look like
    
    // change frame of one or more labels
    self.textLabel.frame = CGRectMake(5, 0, 45, self.contentView.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(55, 0, 232, self.contentView.frame.size.height);
}

@end







