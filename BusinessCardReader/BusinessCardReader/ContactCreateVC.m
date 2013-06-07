//
//  ContactCreateVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 5/27/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "ContactCreateVC.h"
#import "ContactEditCell.h"

@interface ContactCreateVC ()

@end

@implementation ContactCreateVC

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
    
    [self.menuButton setBackgroundImage:[[BCRAccountManager defaultManager] defaultNavbarMenuBGImage] forState:UIControlStateNormal];
    
    self.contact = [[BCRContact alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setMenuButton:nil];
    [self setCameraButton:nil];
    [self setTableView:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}

#pragma mark - Action Methods

- (IBAction)menuButtonTapped:(id)sender
{
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

- (IBAction)doneButtonTapped:(id)sender
{
    // empty fields validation
    if (self.contact.lastName.length <=0 ||
        self.contact.email.length <=0 ||
        self.contact.company.length <=0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Last Name, Email Address and Company are required fields. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
        
        
    }
    
    // email address validation
    NSString *emailAddrress = self.contact.email;
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
    NSString *phone = self.contact.phone;
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
    phone = self.contact.mobile;
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
    phone = self.contact.fax;
    if(phone.length > 0 && ![phoneTest evaluateWithObject:phone]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid fax number. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![[BCRAccountManager defaultManager] currentEvent].eventID) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Topic and Followup Action options found."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // go to topicsVC
    self.topicPicker = [[TopicPickerVC alloc] initWithNibName:nil bundle:nil];
    self.topicPicker.contact = self.contact;
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
    }
    else if (section == 1) {
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
            cell.textField.text = self.contact.address;
        }else if (indexPath.row == 1 ) {
            cell.textLabel.text = @"City";
            cell.textField.text = self.contact.city;
        }else if (indexPath.row == 2 ) {
            cell.textLabel.text = @"Zip";
            cell.textField.text = self.contact.zip;
        }else if (indexPath.row == 3 ) {
            cell.textLabel.text = @"Country";
            cell.textField.text = self.contact.country;
        }
    }else if (indexPath.section == 0) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"First Name";
            cell.textField.text = self.contact.firstName;
        }if(indexPath.row == 1){
            cell.textLabel.text = @"Last Name";
            cell.textField.text = self.contact.lastName;
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Company";
            cell.textField.text = self.contact.company;
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"Job";
            cell.textField.text = self.contact.job;
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Phone";
            cell.textField.text = self.contact.phone;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Mobile";
            cell.textField.text = self.contact.mobile;
            
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Fax";
            cell.textField.text = self.contact.fax;
        }
    }else if (indexPath.section == 3) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Email";
            cell.textField.text = self.contact.email;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Web";
            cell.textField.text = self.contact.web;
        }
    }else if (indexPath.section == 4) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Topic(s)";
            cell.textField.text = self.contact.topicList;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Action(s)";
            cell.textField.text = self.contact.followupList;
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
            self.contact.address = textField.text;
        }if(indexPath.row == 1){
            self.contact.city = textField.text;
        }else if(indexPath.row == 2){
            self.contact.zip = textField.text;
        }else if(indexPath.row == 3){
            self.contact.country = textField.text;
        }

    }else if (indexPath.section == 0) {
        if(indexPath.row == 0){
            self.contact.firstName = textField.text;
        }if(indexPath.row == 1){
            self.contact.lastName = textField.text;
        }else if(indexPath.row == 2){
            self.contact.company = textField.text;
        }else if(indexPath.row == 3){
            self.contact.job = textField.text;
        }
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0){
            self.contact.phone = textField.text;
        }else if(indexPath.row == 1){
            self.contact.mobile = textField.text;
        }else if(indexPath.row == 2){
            self.contact.fax = textField.text;
        }
    }else if (indexPath.section == 3) {
        if(indexPath.row == 0){
            self.contact.email = textField.text;
        }else if(indexPath.row == 1){
            self.contact.web = textField.text;
        }
    }else if (indexPath.section == 4) {
        if(indexPath.row == 0){
            self.contact.topicList = textField.text;
        }else if(indexPath.row == 1){
            self.contact.followupList = textField.text;
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
    
    BOOL result = [[DB defaultManager] createContact:self.contact forEvent:[[BCRAccountManager defaultManager] currentEvent]];
    if (!result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Unable to save changes. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSError *error = [info objectForKey:@"error"];  DLOG(@"error: %@",error);
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save changes. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The changes have been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - TopicPickerVCDelegate Methods

- (void)topicPicker:(TopicPickerVC *)picker didFinishPickingTopicsWithInfo:(NSDictionary *)info
{
    // go to followup picker
    self.actionPicker = [[ActionPickerVC alloc] initWithNibName:nil bundle:nil];
    self.actionPicker.contact = self.contact;
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
    self.contact.delegate = self;
    [self.contact doContactUpload];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(contactCreateVC:didCreateContact:)]) {
        [(id<ContactCreateVCDelegate>)self.delegate contactCreateVC:self didCreateContact:self.contact];
    }
}

@end
