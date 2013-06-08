//
//  ContactEditVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/22/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactEditVC.h"
#import "ContactEditCell.h"

@interface ContactEditVC ()

@end


@implementation ContactEditVC

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
    if(self.contact.image) self.imageView.image = self.contact.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setBackButton:nil];
    [self setImageView:nil];
    [self setTableView:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}

#pragma mark - Setters & Getters

- (void)setContact:(BCRContact *)contact
{
    _contact = contact;
    self.contactCopy = contact;
    assert(self.contactCopy.eventID);
}

#pragma mark - Action Methods

- (IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonTapped:(id)sender
{
    // empty fields validation
    if (self.contactCopy.lastName.length <=0 ||
        self.contactCopy.email.length <=0 ||
        self.contactCopy.company.length <=0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Last Name, Email Address and Company are required fields. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
        
        
    }
    
    // email address validation
    NSString *emailAddrress = self.contactCopy.email;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:emailAddrress]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid email address. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // phone number validation
    NSString *phone = self.contactCopy.phone;
    NSString *phoneRegex = @"^[0-9]{10,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(phone.length > 0 && ![phoneTest evaluateWithObject:phone]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid phone number. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // mobile number validation
    phone = self.contactCopy.mobile;
    if(phone.length > 0 && ![phoneTest evaluateWithObject:phone]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid mobile number. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // fax number validation
    phone = self.contactCopy.fax;
    if(phone.length > 0 && ![phoneTest evaluateWithObject:phone]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid fax number. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // go to topicsVC
    self.topicPicker = [[TopicPickerVC alloc] initWithNibName:nil bundle:nil];
    self.topicPicker.topicList = [[BCRAccountManager defaultManager] eventWithEventID:self.contactCopy.eventID].topicOptionList;
    self.topicPicker.contact = self.contactCopy;
    self.topicPicker.delegate = self;
    [self.navigationController pushViewController:self.topicPicker animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 4;
    }else if (section == 3) {
        return 2;
    }else if (section == 4) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contact_row_bg";
    static NSString *CellIdentifier1 = @"contact_row1_bg";
    
    ContactEditCell *cell  = [tableView dequeueReusableCellWithIdentifier:(indexPath.section == 1 ? CellIdentifier1 : CellIdentifier)];
    if (cell == nil) {
        cell = [[ContactEditCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:(indexPath.section == 1 ? CellIdentifier1 : CellIdentifier)];
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textFieldUIControlEventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];

        cell.backgroundView = view;
    }
    cell.textField.tag = (indexPath.section * 10) + indexPath.row;
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0 ) {
            cell.textLabel.text = @"Address";
            cell.textField.text = self.contactCopy.address;
        }else if (indexPath.row == 1 ) {
            cell.textLabel.text = @"City";
            cell.textField.text = self.contactCopy.city;
        }else if (indexPath.row == 2 ) {
            cell.textLabel.text = @"Zip";
            cell.textField.text = self.contactCopy.zip;
        }else if (indexPath.row == 3 ) {
            cell.textLabel.text = @"Country";
            cell.textField.text = self.contactCopy.country;
        }
    }else if (indexPath.section == 0) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"First Name";
            cell.textField.text = self.contactCopy.firstName;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Last Name";
            cell.textField.text = self.contactCopy.lastName;
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Company";
            cell.textField.text = self.contactCopy.company;
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"Job";
            cell.textField.text = self.contactCopy.job;
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Phone";
            cell.textField.text = self.contactCopy.phone;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Mobile";
            cell.textField.text = self.contactCopy.mobile;

        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Fax";
            cell.textField.text = self.contactCopy.fax;
        }
    }else if (indexPath.section == 3) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Email";
            cell.textField.text = self.contactCopy.email;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Web";
            cell.textField.text = self.contactCopy.web;
        }
    }else if (indexPath.section == 4) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Topic(s)";
            cell.textField.text = self.contactCopy.topicList;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Action(s)";
            cell.textField.text = self.contactCopy.followupList;
        }
    }
    
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
//    if (indexPath.section == 2) {
//        return 50;
//    }else{
        return 37;
//    }
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldUIControlEventEditingChanged:(UITextField *)textField
{
    NSInteger row = textField.tag % 10;
    NSInteger section = textField.tag / 10;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    if (indexPath.section == 2) {
        if(indexPath.row == 0){
            self.contactCopy.address = textField.text;
        }if(indexPath.row == 1){
            self.contactCopy.city = textField.text;
        }else if(indexPath.row == 2){
            self.contactCopy.zip = textField.text;
        }else if(indexPath.row == 3){
            self.contactCopy.country = textField.text;
        }
    }else if (indexPath.section == 0) {
        if(indexPath.row == 0){
            self.contactCopy.firstName = textField.text;
        }else if(indexPath.row == 1){
            self.contactCopy.lastName = textField.text;
        }else if(indexPath.row == 2){
            self.contactCopy.company = textField.text;
        }else if(indexPath.row == 3){
            self.contactCopy.job = textField.text;
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0){
            self.contactCopy.phone = textField.text;
        }else if(indexPath.row == 1){
            self.contactCopy.mobile = textField.text;
            
        }else if(indexPath.row == 2){
            self.contactCopy.fax = textField.text;
        }
    }else if (indexPath.section == 3) {
        if(indexPath.row == 0){
            self.contactCopy.email = textField.text;
        }else if(indexPath.row == 1){
            self.contactCopy.web = textField.text;
        }
    }else if (indexPath.section == 4) {
        if(indexPath.row == 0){
            self.contactCopy.topicList = textField.text;
        }else if(indexPath.row == 1){
            self.contactCopy.followupList = textField.text;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 272)];
    
    [self.doneButton removeFromSuperview];
    self.doneButton.frame = CGRectMake(0, 10, 292, 41);
    [view addSubview:self.doneButton];
    
    self.tableView.tableFooterView = view;
    
    NSInteger row = textField.tag % 10;
    NSInteger section = textField.tag / 10;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 71)];
    self.tableView.tableFooterView = view;
    
    [self.doneButton removeFromSuperview];
    self.doneButton.frame = CGRectMake(0, 10, 292, 41);
    [view addSubview:self.doneButton];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - BCRContactDelegate Methods

- (void)contact:(BCRContact *)contact didFinishContactUploadWithInfo:(NSDictionary *)info
{
    contact.delegate = nil;
    
    NSError *error = [info objectForKey:@"error"];  DLOG(@"error: %@",error);
    if (error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save changes. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        BOOL result = [[DB defaultManager] updateContact:self.contactCopy];
        if (!result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Unable to save changes. Please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        self.contact.contactID = self.contactCopy.contactID;
        self.contact.imageURL = self.contactCopy.imageURL;
        self.contact.firstName = self.contactCopy.firstName;
        self.contact.lastName = self.contactCopy.lastName;
        self.contact.phone = self.contactCopy.phone;
        self.contact.mobile = self.contactCopy.mobile;
        self.contact.fax = self.contactCopy.fax;
        self.contact.company = self.contactCopy.company;
        self.contact.job = self.contactCopy.job;
        self.contact.address = self.contactCopy.address;
        self.contact.city = self.contactCopy.city;
        self.contact.zip = self.contactCopy.zip;
        self.contact.country = self.contactCopy.country;
        self.contact.email = self.contactCopy.email;
        self.contact.web = self.contactCopy.web;
        self.contact.text = self.contactCopy.text;
        self.contact.followupList = self.contactCopy.followupList;
        self.contact.topicList = self.contactCopy.topicList;
        self.contact.eventID = self.contactCopy.eventID;
        assert(self.contact.eventID);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The changes have been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
    
}

#pragma mark - TopicPickerVCDelegate Methods

- (void)topicPicker:(TopicPickerVC *)picker didFinishPickingTopicsWithInfo:(NSDictionary *)info
{
    // go to followup picker
    self.actionPicker = [[ActionPickerVC alloc] initWithNibName:nil bundle:nil];
    self.actionPicker.actionList = [[BCRAccountManager defaultManager] eventWithEventID:self.contactCopy.eventID].followupOptionList;
    self.actionPicker.contact = self.contactCopy;
    self.actionPicker.delegate = self;
    [self.navigationController pushViewController:self.actionPicker animated:YES];
}

#pragma mark - ActionPickerVCDelegate Methods

- (void)actionPicker:(ActionPickerVC *)picker didFinishPickingFollowupActionsWithInfo:(NSDictionary *)info
{
    if (![[BCRAccountManager defaultManager] currentEvent].eventID) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Topic and Followup Action options found."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    // upload contact
    self.contactCopy.delegate = self;
    [self.contactCopy doContactUpload];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
